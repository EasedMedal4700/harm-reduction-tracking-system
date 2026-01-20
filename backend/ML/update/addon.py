"""Upsert drug_profile_addons.tolerance_model from a JSON file.

Supports two input formats:

1) Generic mapping (legacy):
{
	"<uuid|slug|pretty|alias>": { "tolerance_model": { ... } },
	"...": { "tolerance_model": { ... } }
}

2) tolerance_neuro_buckets.json:
{
	"metadata": { ... },
	"substances": {
		"<slug|pretty|alias>": { ...tolerance model... },
		"...": { ... }
	}
}

Non-UUID keys are resolved case-insensitively via drug_profiles (slug/pretty_name/aliases).

Connection is configured via either:
- --database-url, or env var DATABASE_URL
- or --supabase (SUPABASE_* vars / USE_SUPABASE=true)
- or discrete flags: --host/--port/--dbname/--user/--password
"""

from __future__ import annotations

import argparse
import datetime as _dt
import json
import os
import socket
import sys
import uuid
import urllib.error
import urllib.parse
import urllib.request
from dataclasses import dataclass
from typing import Any, Iterable


def _require_psycopg2() -> tuple[Any, Any, Any]:
	try:
		import psycopg2  # type: ignore
		from psycopg2 import extras  # type: ignore
		from psycopg2.extras import execute_values  # type: ignore
	except Exception as exc:  # pragma: no cover
		raise RuntimeError(
			"Missing dependency: psycopg2. Install with: pip install psycopg2-binary"
		) from exc
	return psycopg2, extras, execute_values


@dataclass(frozen=True)
class AddonRow:
	# Resolved UUID. For convenience, input JSON may specify a UUID key,
	# or a substance identifier key (slug/pretty name/alias), which will be
	# resolved to a UUID at upsert time.
	drug_profile_id: uuid.UUID
	tolerance_model: dict[str, Any]


@dataclass(frozen=True)
class AddonInputRow:
	key: str
	tolerance_model: dict[str, Any]


def _parse_uuid(value: str) -> uuid.UUID:
	try:
		return uuid.UUID(value)
	except Exception as exc:
		raise ValueError(f"Invalid UUID: {value!r}") from exc


def _normalize_substance_key(value: str) -> str:
	# Case-insensitive, tolerant normalization for slugs/pretty names/aliases.
	# Mirrors common slugging patterns used elsewhere in this repo.
	s = value.strip().casefold()
	s = s.replace("_", "-")
	s = s.replace(" ", "-")
	while "--" in s:
		s = s.replace("--", "-")
	return s


def _try_parse_uuid(value: str) -> uuid.UUID | None:
	try:
		return uuid.UUID(value)
	except Exception:
		return None


def _extract_aliases(raw_aliases: Any) -> list[str]:
	if raw_aliases is None:
		return []
	if isinstance(raw_aliases, (list, tuple)):
		return [str(x) for x in raw_aliases if x is not None]
	if isinstance(raw_aliases, str):
		s = raw_aliases.strip()
		# Attempt to decode JSON-encoded aliases coming back from jsonb.
		if s.startswith("[") or s.startswith("{"):
			try:
				decoded = json.loads(s)
				return _extract_aliases(decoded)
			except Exception:
				return [raw_aliases]
		return [raw_aliases]
	return [str(raw_aliases)]


def _profile_id_from_row(row: dict[str, Any]) -> uuid.UUID | None:
	raw_id = row.get("id")
	if raw_id is None:
		raw_id = row.get("profile_id")
	if raw_id is None:
		raw_id = row.get("drug_profile_id")
	if raw_id is None:
		return None
	return raw_id if isinstance(raw_id, uuid.UUID) else _parse_uuid(str(raw_id))


def _build_profile_candidates(
	profile_rows: Iterable[dict[str, Any]],
) -> dict[str, list[tuple[int, uuid.UUID]]]:
	"""Build candidates for normalized substance identifiers -> profile UUID.

	Lower priority value wins.
	- 0: slug
	- 1: name
	- 2: pretty_name
	- 3: aliases
	- 4: substance (legacy)
	"""
	candidates: dict[str, list[tuple[int, uuid.UUID]]] = {}

	def add_key(k: str, profile_id: uuid.UUID, priority: int) -> None:
		nk = _normalize_substance_key(k)
		if not nk:
			return
		candidates.setdefault(nk, []).append((priority, profile_id))

	for row in profile_rows:
		profile_id = _profile_id_from_row(row)
		if profile_id is None:
			continue

		v = row.get("slug")
		if isinstance(v, str) and v.strip():
			add_key(v, profile_id, 0)

		v = row.get("name")
		if isinstance(v, str) and v.strip():
			add_key(v, profile_id, 1)

		v = row.get("pretty_name")
		if isinstance(v, str) and v.strip():
			add_key(v, profile_id, 2)

		for alias in _extract_aliases(row.get("aliases")):
			if alias.strip():
				add_key(alias, profile_id, 3)

		v = row.get("substance")
		if isinstance(v, str) and v.strip():
			add_key(v, profile_id, 4)

	return candidates


def _resolve_profile_id(
	*, candidates: dict[str, list[tuple[int, uuid.UUID]]], key: str
) -> uuid.UUID:
	nk = _normalize_substance_key(key)
	items = candidates.get(nk)
	if not items:
		raise ValueError(f"Unknown substance key: {key!r}")
	best_priority = min(p for p, _ in items)
	best_ids = sorted({pid for p, pid in items if p == best_priority}, key=str)
	if len(best_ids) != 1:
		raise ValueError(
			f"Ambiguous substance key {key!r}; candidates at priority {best_priority}: {[str(x) for x in best_ids]}"
		)
	return best_ids[0]


def _build_profile_lookup(profile_rows: Iterable[dict[str, Any]]) -> dict[str, uuid.UUID]:
	"""Build a mapping of unambiguous normalized keys -> profile UUID."""
	candidates = _build_profile_candidates(profile_rows)
	lookup: dict[str, uuid.UUID] = {}
	for nk in candidates.keys():
		try:
			lookup[nk] = _resolve_profile_id(candidates=candidates, key=nk)
		except ValueError:
			# Keep ambiguous keys out; they will error only if the user tries to resolve them.
			continue
	return lookup


def _load_rows(json_path: str) -> list[AddonInputRow]:
	with open(json_path, "r", encoding="utf-8") as f:
		payload = json.load(f)

	# Support two input formats:
	# 1) Generic mapping (legacy): { "<uuid|slug|alias>": { "tolerance_model": {...} } }
	# 2) tolerance_neuro_buckets.json: { "metadata": {...}, "substances": { "slug": {...tolerance params...} } }
	if not isinstance(payload, dict):
		raise ValueError("Top-level JSON must be an object")

	if "substances" in payload and isinstance(payload.get("substances"), dict):
		substances = payload["substances"]
		rows: list[AddonInputRow] = []
		for substance_key, tolerance_model in substances.items():
			if not isinstance(substance_key, str):
				raise ValueError("substances keys must be strings")
			if not isinstance(tolerance_model, dict):
				raise ValueError(
					f"substances[{substance_key!r}] must be an object tolerance model"
				)
			rows.append(
				AddonInputRow(key=substance_key, tolerance_model=tolerance_model)
			)
		return rows

	# Legacy mapping format.
	rows2: list[AddonInputRow] = []
	for key, raw in payload.items():
		if not isinstance(key, str):
			raise ValueError("drug_profile_id keys must be strings")
		if not isinstance(raw, dict):
			raise ValueError(f"Value for {key} must be an object")

		tolerance_model = raw.get("tolerance_model")
		if not isinstance(tolerance_model, dict):
			raise ValueError(f"{key}: tolerance_model must be an object")

		rows2.append(AddonInputRow(key=key, tolerance_model=tolerance_model))

	return rows2


def _build_dsn(args: argparse.Namespace) -> str:
	# Optional: load env vars from a .env file (without requiring python-dotenv).
	# Note: main() also loads dotenv early so other transports (e.g. REST) can use it.
	dotenv_path = getattr(args, "dotenv", None)
	if dotenv_path:
		_load_dotenv_file(dotenv_path)

	database_url = args.database_url or os.getenv("DATABASE_URL")
	if database_url:
		return database_url

	# Supabase convenience mode: build a DSN from SUPABASE_* variables.
	use_supabase = bool(getattr(args, "supabase", False)) or _env_truthy(
		os.getenv("USE_SUPABASE")
	)
	if use_supabase:
		return _build_supabase_dsn_from_env()

	missing = [name for name in ("host", "dbname", "user") if not getattr(args, name, None)]
	if missing:
		raise ValueError(
			"Missing connection details. Provide --database-url (or DATABASE_URL), or: "
			+ ", ".join(f"--{m}" for m in missing)
		)

	host = args.host
	port = int(args.port)
	dbname = args.dbname
	user = args.user
	password = args.password

	# libpq-style DSN; avoids URL-escaping issues.
	parts = [f"host={host}", f"port={port}", f"dbname={dbname}", f"user={user}"]
	if password:
		parts.append(f"password={password}")
	return " ".join(parts)


def _env_truthy(value: str | None) -> bool:
	if value is None:
		return False
	return value.strip().casefold() in {"1", "true", "yes", "y", "on"}


def _load_dotenv_file(path: str) -> None:
	"""Load KEY=VALUE pairs from a .env file into os.environ if missing."""
	try:
		with open(path, "r", encoding="utf-8") as f:
			for raw_line in f:
				line = raw_line.strip()
				if not line or line.startswith("#"):
					continue
				if "=" not in line:
					continue
				key, value = line.split("=", 1)
				key = key.strip()
				value = value.strip()
				# Strip optional single/double quotes.
				if (value.startswith('"') and value.endswith('"')) or (
					value.startswith("'") and value.endswith("'")
				):
					value = value[1:-1]
				if key and key not in os.environ:
					os.environ[key] = value
	except FileNotFoundError:
		# If the repo doesn't have a .env locally, just continue.
		return


def _supabase_ref_from_url(supabase_url: str) -> str:
	# Expected: https://<ref>.supabase.co
	u = supabase_url.strip()
	if u.startswith("http://"):
		u = u[len("http://") :]
	elif u.startswith("https://"):
		u = u[len("https://") :]
	host = u.split("/", 1)[0]
	if not host:
		raise ValueError("SUPABASE_URL is invalid (missing host)")
	# host like <ref>.supabase.co
	ref = host.split(".", 1)[0]
	if not ref:
		raise ValueError("SUPABASE_URL is invalid (missing project ref)")
	return ref


def _build_supabase_dsn_from_env() -> str:
	supabase_url = os.getenv("SUPABASE_URL")
	supabase_db_password = os.getenv("SUPABASE_DB_PASSWORD")
	if not supabase_url:
		raise ValueError("USE_SUPABASE is set but SUPABASE_URL is missing")
	if not supabase_db_password:
		raise ValueError("USE_SUPABASE is set but SUPABASE_DB_PASSWORD is missing")

	ref = _supabase_ref_from_url(supabase_url)
	host = os.getenv("SUPABASE_DB_HOST") or f"db.{ref}.supabase.co"
	port = int(os.getenv("SUPABASE_DB_PORT") or "5432")
	dbname = os.getenv("SUPABASE_DB_NAME") or "postgres"
	user = os.getenv("SUPABASE_DB_USER") or "postgres"

	# Many Supabase direct DB hosts are IPv6-only; some environments lack IPv6 connectivity.
	# If we detect no IPv4 addresses, emit a hint to use the Supabase pooler host instead.
	try:
		infos = socket.getaddrinfo(host, port, type=socket.SOCK_STREAM)
		has_ipv4 = any(family == socket.AF_INET for family, *_ in infos)
		if not has_ipv4 and os.getenv("SUPABASE_DB_HOST") is None:
			print(
				"Warning: derived Supabase DB host appears IPv6-only. "
				"If connections fail, set SUPABASE_DB_HOST to your Supabase pooler host "
				"(from the Supabase dashboard connection string).",
				file=sys.stderr,
			)
	except Exception:
		pass

	parts = [
		f"host={host}",
		f"port={port}",
		f"dbname={dbname}",
		f"user={user}",
		f"password={supabase_db_password}",
		"sslmode=require",
	]
	return " ".join(parts)


def _supabase_rest_base_url_from_env() -> str:
	supabase_url = os.getenv("SUPABASE_URL")
	if not supabase_url:
		raise ValueError("SUPABASE_URL is missing")
	return supabase_url.rstrip("/")


def _supabase_api_key_from_env() -> str:
	# Prefer service role if present (bypasses RLS). Fall back to anon.
	key = (
		os.getenv("SUPABASE_SERVICE_ROLE_KEY")
		or os.getenv("SUPABASE_KEY")
		or os.getenv("SUPABASE_ANON_KEY")
	)
	if not key:
		raise ValueError(
			"Missing Supabase API key. Set SUPABASE_SERVICE_ROLE_KEY (preferred) or SUPABASE_ANON_KEY."
		)
	return key


def _http_json(
	*,
	method: str,
	url: str,
	headers: dict[str, str] | None = None,
	body: Any | None = None,
	timeout_s: int = 60,
) -> Any:
	data: bytes | None
	if body is None:
		data = None
	else:
		data = json.dumps(body).encode("utf-8")

	req = urllib.request.Request(url, data=data, method=method)
	for k, v in (headers or {}).items():
		req.add_header(k, v)

	try:
		with urllib.request.urlopen(req, timeout=timeout_s) as resp:
			raw = resp.read()
			if not raw:
				return None
			return json.loads(raw.decode("utf-8"))
	except urllib.error.HTTPError as e:
		# Try to include server response without leaking secrets.
		try:
			payload = e.read().decode("utf-8", errors="replace")
		except Exception:
			payload = ""
		raise RuntimeError(f"HTTP {e.code} from Supabase REST: {payload}") from e


def _supabase_headers(prefer: str | None = None) -> dict[str, str]:
	key = _supabase_api_key_from_env()
	h: dict[str, str] = {
		"apikey": key,
		"Authorization": f"Bearer {key}",
		"Content-Type": "application/json",
		"Accept": "application/json",
	}
	if prefer:
		h["Prefer"] = prefer
	return h


def _fetch_drug_profiles_rest(*, page_size: int = 1000) -> list[dict[str, Any]]:
	base = _supabase_rest_base_url_from_env()
	endpoint = f"{base}/rest/v1/drug_profiles"
	# The Supabase schema in this repo exposes the primary key as profile_id.
	select = "profile_id,name,slug,pretty_name,aliases"

	all_rows: list[dict[str, Any]] = []
	offset = 0
	while True:
		qs = urllib.parse.urlencode(
			{
				"select": select,
				"limit": str(page_size),
				"offset": str(offset),
			},
			quote_via=urllib.parse.quote,
		)
		url = f"{endpoint}?{qs}"
		batch = _http_json(method="GET", url=url, headers=_supabase_headers())
		if not batch:
			break
		if not isinstance(batch, list):
			raise RuntimeError("Unexpected response for drug_profiles (expected list)")
		all_rows.extend(batch)
		if len(batch) < page_size:
			break
		offset += page_size
	return all_rows


def _resolve_input_rows_via_rest(rows: Iterable[AddonInputRow]) -> list[AddonRow]:
	rows_list = list(rows)
	if not rows_list:
		return []

	profile_rows = _fetch_drug_profiles_rest()
	profile_candidates = _build_profile_candidates(profile_rows)

	resolved: list[AddonRow] = []
	for r in rows_list:
		maybe_id = _try_parse_uuid(r.key)
		if maybe_id is not None:
			resolved.append(AddonRow(drug_profile_id=maybe_id, tolerance_model=r.tolerance_model))
			continue
		try:
			drug_profile_id = _resolve_profile_id(candidates=profile_candidates, key=r.key)
		except ValueError as exc:
			raise ValueError(
				f"Could not resolve substance key {r.key!r} via Supabase REST drug_profiles."
			) from exc
		resolved.append(AddonRow(drug_profile_id=drug_profile_id, tolerance_model=r.tolerance_model))
	return resolved


def upsert_addons_via_rest(*, rows: Iterable[AddonInputRow], page_size: int = 500) -> int:
	"""Upsert via Supabase PostgREST over HTTPS (port 443).

	This is a fallback when direct Postgres connectivity is blocked (common on locked-down networks)
	or when the derived db.<ref>.supabase.co host is unreachable (e.g. IPv6-only).
	"""
	rows_list = list(rows)
	if not rows_list:
		return 0

	resolved = _resolve_input_rows_via_rest(rows_list)
	base = _supabase_rest_base_url_from_env()
	endpoint = f"{base}/rest/v1/drug_profile_addons"

	# Upsert semantics: merge duplicates on conflict.
	prefer = "resolution=merge-duplicates,return=minimal"
	headers = _supabase_headers(prefer=prefer)

	now = _dt.datetime.now(tz=_dt.timezone.utc).isoformat()

	count = 0
	for i in range(0, len(resolved), page_size):
		chunk = resolved[i : i + page_size]
		body = [
			{
				"drug_profile_id": str(r.drug_profile_id),
				"tolerance_model": r.tolerance_model,
				"updated_at": now,
			}
			for r in chunk
		]
		qs = urllib.parse.urlencode({"on_conflict": "drug_profile_id"})
		url = f"{endpoint}?{qs}"
		_http_json(method="POST", url=url, headers=headers, body=body)
		count += len(chunk)
	return count


def _fetch_drug_profiles(conn: Any) -> list[dict[str, Any]]:
	"""Fetch minimal fields from drug_profiles for substance->id resolution."""
	with conn.cursor() as cur:
		cur.execute(
			"SELECT profile_id, name, slug, pretty_name, aliases FROM drug_profiles"
		)
		cols = [d[0] for d in cur.description]
		return [dict(zip(cols, r, strict=False)) for r in cur.fetchall()]


def _resolve_input_rows(conn: Any, rows: Iterable[AddonInputRow]) -> list[AddonRow]:
	"""Resolve AddonInputRow keys (UUID or substance identifier) into UUIDs."""
	rows_list = list(rows)
	if not rows_list:
		return []

	# Build candidates lazily only if needed.
	profile_candidates: dict[str, list[tuple[int, uuid.UUID]]] | None = None

	resolved: list[AddonRow] = []
	for r in rows_list:
		maybe_id = _try_parse_uuid(r.key)
		if maybe_id is not None:
			resolved.append(
				AddonRow(
					drug_profile_id=maybe_id,
					tolerance_model=r.tolerance_model,
				)
			)
			continue

		if profile_candidates is None:
			profiles = _fetch_drug_profiles(conn)
			profile_candidates = _build_profile_candidates(profiles)

		try:
			drug_profile_id = _resolve_profile_id(candidates=profile_candidates or {}, key=r.key)
		except ValueError as exc:
			raise ValueError(
				f"Could not resolve substance key {r.key!r} to a drug_profiles.profile_id. "
				"Expected a UUID key, or a slug/pretty name/alias (case-insensitive)."
			) from exc

		resolved.append(
			AddonRow(
				drug_profile_id=drug_profile_id,
				tolerance_model=r.tolerance_model,
			)
		)

	return resolved


UPSERT_SQL = """
	INSERT INTO drug_profile_addons (
		drug_profile_id,
		tolerance_model,
		created_at,
		updated_at
	)
	VALUES %s
	ON CONFLICT (drug_profile_id)
	DO UPDATE SET
		tolerance_model = EXCLUDED.tolerance_model,
		updated_at = now();
"""


def upsert_addons(
	*, dsn: str, rows: Iterable[AddonInputRow], page_size: int = 500
) -> int:
	psycopg2, extras, execute_values = _require_psycopg2()

	rows_list = list(rows)
	if not rows_list:
		return 0

	conn = None
	try:
		conn = psycopg2.connect(dsn)
		# Make json/jsonb come back as Python objects when possible.
		try:
			extras.register_default_jsonb(conn, loads=json.loads)  # type: ignore[attr-defined]
		except Exception:
			pass

		resolved = _resolve_input_rows(conn, rows_list)

		with conn.cursor() as cur:
			values = [
				(
					str(r.drug_profile_id),
					extras.Json(r.tolerance_model),
				)
				for r in resolved
			]

			template = (
				"(%s, %s::jsonb, now(), now())"
			)
			execute_values(cur, UPSERT_SQL, values, template=template, page_size=page_size)
		conn.commit()
		return len(resolved)
	except Exception:
		if conn is not None:
			conn.rollback()
		raise
	finally:
		if conn is not None:
			conn.close()


def _should_fallback_to_rest(exc: BaseException) -> bool:
	msg = str(exc).casefold()
	# Common networking/DNS/connectivity problems where REST (443) is more likely to work.
	needles = [
		"could not translate host name",
		"name or service not known",
		"getaddrinfo failed",
		"network is unreachable",
		"no route to host",
		"connection refused",
		"connection timed out",
		"timeout",
		"ssl",
	]
	return any(n in msg for n in needles)


def _build_parser() -> argparse.ArgumentParser:
	p = argparse.ArgumentParser(
		description="Upsert drug_profile_addons rows from a JSON file into Postgres"
	)
	p.add_argument("json_path", help="Path to input JSON file")

	p.add_argument(
		"--database-url",
		default=None,
		help="libpq connection string or postgres:// URL (or set DATABASE_URL env var)",
	)
	p.add_argument(
		"--dotenv",
		default=".env",
		help="Path to .env file to load (default: .env). Use empty string to disable.",
	)
	p.add_argument(
		"--supabase",
		action="store_true",
		help="Build DSN from SUPABASE_* env vars (or set USE_SUPABASE=true)",
	)
	p.add_argument("--host", default=None)
	p.add_argument("--port", default=5432)
	p.add_argument("--dbname", default=None)
	p.add_argument("--user", default=None)
	p.add_argument("--password", default=None)

	p.add_argument(
		"--page-size",
		type=int,
		default=500,
		help="Batch size for execute_values()",
	)
	p.add_argument(
		"--limit",
		type=int,
		default=None,
		help="For testing: only process the first N rows from the input",
	)
	p.add_argument(
		"--transport",
		choices=["auto", "postgres", "rest"],
		default="auto",
		help="How to write data: postgres (direct DB), rest (Supabase HTTPS), auto (try postgres then rest)",
	)
	p.add_argument(
		"--dry-run",
		action="store_true",
		help="Validate input; if non-UUID keys are present, connect and resolve them; no DB writes performed",
	)
	return p


def main(argv: list[str] | None = None) -> int:
	args = _build_parser().parse_args(argv)

	# Allow disabling dotenv loading by passing --dotenv "".
	if hasattr(args, "dotenv") and isinstance(args.dotenv, str) and args.dotenv.strip() == "":
		args.dotenv = None

	# Load dotenv early so REST transport can use env vars too.
	if getattr(args, "dotenv", None):
		_load_dotenv_file(args.dotenv)

	rows = _load_rows(args.json_path)
	if getattr(args, "limit", None) is not None:
		rows = rows[: max(0, int(args.limit))]

	if args.dry_run:
		# If the JSON uses non-UUID keys, validate that they can be resolved.
		needs_resolution = any(_try_parse_uuid(r.key) is None for r in rows)
		if needs_resolution:
			if args.transport in {"rest"}:
				resolved = _resolve_input_rows_via_rest(rows)
				print(f"Validated and resolved {len(resolved)} row(s) via Supabase REST.")
			else:
				# postgres or auto
				dsn = _build_dsn(args)
				psycopg2, extras, _ = _require_psycopg2()
				conn = None
				try:
					conn = psycopg2.connect(dsn)
					try:
						extras.register_default_jsonb(conn, loads=json.loads)  # type: ignore[attr-defined]
					except Exception:
						pass
					resolved = _resolve_input_rows(conn, rows)
					print(f"Validated and resolved {len(resolved)} row(s) via Postgres.")
				except Exception as exc:
					if args.transport == "auto" and _should_fallback_to_rest(exc):
						print(
							"Postgres resolution failed; retrying resolution via Supabase REST (HTTPS/443).",
							file=sys.stderr,
						)
						resolved = _resolve_input_rows_via_rest(rows)
						print(
							f"Validated and resolved {len(resolved)} row(s) via Supabase REST.",
						)
					else:
						raise
				finally:
					if conn is not None:
						conn.close()
		else:
			print(f"Validated {len(rows)} row(s) (all UUID keys).")

		print("Dry run: no DB writes performed.")
		return 0

	if args.transport == "rest":
		count = upsert_addons_via_rest(rows=rows, page_size=args.page_size)
		print(f"Upserted {count} row(s) into drug_profile_addons via Supabase REST.")
		return 0

	# postgres or auto
	dsn = _build_dsn(args)
	try:
		count = upsert_addons(dsn=dsn, rows=rows, page_size=args.page_size)
		print(f"Upserted {count} row(s) into drug_profile_addons via Postgres.")
		return 0
	except Exception as exc:
		if args.transport != "auto" or not _should_fallback_to_rest(exc):
			raise
		print(
			"Postgres connection failed; retrying via Supabase REST (HTTPS/443). "
			"If this fails with 401/403, you likely need SUPABASE_SERVICE_ROLE_KEY or RLS policies.",
			file=sys.stderr,
		)
		count = upsert_addons_via_rest(rows=rows, page_size=args.page_size)
		print(f"Upserted {count} row(s) into drug_profile_addons via Supabase REST.")
		return 0


if __name__ == "__main__":
	raise SystemExit(main())
