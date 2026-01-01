def merge_by_drug(records):
    merged = {}
    for r in records:
        drug = r["drug"]
        merged.setdefault(drug, []).append(r)
    return merged
