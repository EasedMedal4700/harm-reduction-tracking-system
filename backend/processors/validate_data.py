def validate_record(drug: dict):
    errors = []

    # Required top-level fields
    required_fields = [
        "drug", "summary", "half_life",
        "duration", "dosage", "tolerance",
        "effects", "sources"
    ]

    # 1. Check existence
    for f in required_fields:
        if f not in drug:
            errors.append(f"Missing field: {f}")
            continue  # Skip deeper checks if missing

        # 2. Check field is not None or empty
        value = drug[f]
        if value is None or value == "":
            errors.append(f"Field '{f}' is empty / None")

        # 3. Type checks for specific fields
        if f == "effects" and not isinstance(value, list):
            errors.append("Field 'effects' must be a list")

        if f == "duration" and not isinstance(value, dict):
            errors.append("Field 'duration' must be a dict")

        if f == "dosage" and not isinstance(value, dict):
            errors.append("Field 'dosage' must be a dict")

        if f == "sources" and not isinstance(value, list):
            errors.append("Field 'sources' must be a list")

    # 4. More specific logical checks
    # -----------------------------------

    # Duration fields that should exist if present
    expected_durations = [
        "total", "come_up", "peak",
        "total", "offset"
    ]

    if isinstance(drug.get("duration"), dict):
        if len(drug["duration"]) == 0:
            errors.append("Duration dict is empty (scraper missing?)")

    # Dosage sanity check
    if isinstance(drug.get("dosage"), dict):
        for k, v in drug["dosage"].items():
            if not isinstance(v, str):
                errors.append(f"Dosage value '{k}' is not a string")
            elif len(v) < 2:
                errors.append(f"Dosage '{k}' seems malformed: {v}")

    # Effects sanity
    if isinstance(drug.get("effects"), list):
        if len(drug["effects"]) == 0:
            errors.append("Effects list is empty (PW extraction failed?)")

    # Half-life sanity check
    half_life = drug.get("half_life")
    if half_life and not isinstance(half_life, str):
        errors.append("Half-life must be a string")
    if half_life and len(half_life) < 2:
        errors.append("Half-life value seems malformed")

    return errors
