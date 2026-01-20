import unittest
import uuid
import json
import tempfile
from pathlib import Path

from backend.ML.update import addon


class NormalizeSubstanceKeyTests(unittest.TestCase):
    def test_normalizes_case_whitespace_underscore(self):
        self.assertEqual(addon._normalize_substance_key(" VyVanSe "), "vyvanse")
        self.assertEqual(addon._normalize_substance_key("Magic Mushrooms"), "magic-mushrooms")
        self.assertEqual(addon._normalize_substance_key("hawaiian_baby_woodrose"), "hawaiian-baby-woodrose")


class BuildProfileLookupTests(unittest.TestCase):
    def test_maps_slug_pretty_alias_case_insensitive(self):
        id1 = uuid.uuid4()
        profiles = [
            {
                "id": id1,
                "name": "dexamphetamine",
                "slug": "dexamphetamine",
                "pretty_name": "Dexamphetamine",
                "aliases": ["Vyvanse", "Dexedrine"],
            }
        ]
        lookup = addon._build_profile_lookup(profiles)
        self.assertEqual(lookup["dexamphetamine"], id1)
        self.assertEqual(lookup["vyvanse"], id1)
        self.assertEqual(lookup["dexedrine"], id1)
        self.assertEqual(lookup["dexamphetamine"], id1)
        self.assertEqual(lookup["dexamphetamine"], id1)

    def test_raises_on_ambiguous_alias(self):
        a = uuid.uuid4()
        b = uuid.uuid4()
        profiles = [
            {"id": a, "name": "foo", "slug": "foo", "pretty_name": "Foo", "aliases": ["X"]},
            {"id": b, "name": "bar", "slug": "bar", "pretty_name": "Bar", "aliases": ["x"]},
        ]
        candidates = addon._build_profile_candidates(profiles)
        with self.assertRaises(ValueError):
            addon._resolve_profile_id(candidates=candidates, key="x")


class SqlTests(unittest.TestCase):
    def test_upsert_sql_contains_on_conflict_and_updated_at(self):
        sql = addon.UPSERT_SQL
        self.assertIn("ON CONFLICT", sql)
        self.assertIn("updated_at = now()", sql)


class LoadRowsTests(unittest.TestCase):
    def test_load_rows_accepts_neuro_buckets_format(self):
        payload = {
            "metadata": {"generated_at": "2026-01-01T00:00:00Z"},
            "substances": {
                "dexedrine": {"tolerance_decay_days": 5.0},
                "VyVaNsE": {"tolerance_decay_days": 5.0},
            },
        }
        with tempfile.TemporaryDirectory() as d:
            p = Path(d) / "tolerance_neuro_buckets.json"
            p.write_text(json.dumps(payload), encoding="utf-8")
            rows = addon._load_rows(str(p))
        self.assertEqual(len(rows), 2)
        self.assertEqual({r.key for r in rows}, {"dexedrine", "VyVaNsE"})
        self.assertTrue(all(isinstance(r.tolerance_model, dict) for r in rows))


class SupabaseDsnTests(unittest.TestCase):
    def test_supabase_ref_from_url(self):
        self.assertEqual(
            addon._supabase_ref_from_url("https://grjukeipqjwcusmmirzw.supabase.co"),
            "grjukeipqjwcusmmirzw",
        )
        self.assertEqual(
            addon._supabase_ref_from_url("https://grjukeipqjwcusmmirzw.supabase.co/anything"),
            "grjukeipqjwcusmmirzw",
        )


if __name__ == "__main__":
    unittest.main()
