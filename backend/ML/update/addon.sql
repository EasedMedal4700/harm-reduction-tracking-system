CREATE TYPE dosing_confidence_level AS ENUM (
  'not',
  'low',
  'medium',
  'high',
  'super_high',
  'medical'
);

CREATE TABLE drug_profile_addons (
  drug_profile_id UUID PRIMARY KEY,  -- Use drug_profile_id as the PK

  -- Derived tolerance model
  tolerance_model JSONB NOT NULL,

  -- Derived half-life
  half_life_hours NUMERIC,
  half_life_medical BOOLEAN NOT NULL DEFAULT false,

  -- Semantic dosing confidence
  dosing_confidence dosing_confidence_level NOT NULL DEFAULT 'not',

  -- Governance
  is_active BOOLEAN NOT NULL DEFAULT false,

  -- Audit
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now(),

  -- Enforce 1 addon per profile (for now)
  UNIQUE (drug_profile_id)
);
