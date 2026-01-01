# ML-Assisted Tolerance Model Inference

Research Proposal (Non-Authoritative, Guideline-Only)

## Context & Alignment With Existing Architecture

This application is designed around deterministic, explainable models for harm-reduction analytics.
As outlined in the main README and TECHNICAL_DEEP_DIVE:

- All substance logic is mechanism-driven
- State and calculations are fully transparent
- No server-side access to sensitive user data exists
- Outputs are guidelines, not medical advice
- Safety rules always override heuristics

The existing tolerance system reflects this philosophy by modeling substances using:

- Neurotransmitter “buckets” (e.g. GABA, serotonin release, stimulant)
- Weighted mechanism contributions
- Explicit tolerance gain and decay parameters
- Pharmacokinetic approximations (half-life, duration, thresholds)

This approach already works well for well-documented substances.

However, as noted in the TECHNICAL_DEEP_DIVE, a structural limitation exists:

Many substances—especially newer or less-studied compounds—lack direct, high-quality tolerance data.

Currently, these models must be manually estimated using expert judgment and literature synthesis. While this is acceptable, it does not scale and introduces unavoidable subjectivity.

This proposal explores a strictly bounded ML approach to assist with inferring tolerance models only, while preserving all architectural and ethical constraints.

## Problem Statement

For under-documented substances:

- Tolerance does exist
- Mechanistic overlap does matter
- Cross-tolerance does occur
- But precise parameters are unknown

At present, tolerance models for these substances are effectively:

“best-effort, manually reasoned approximations”

The goal is not to replace this reasoning, but to systematize it, make it reproducible, and expose uncertainty more clearly.

## Core Idea

Introduce an ML-assisted inference layer whose sole responsibility is:

Estimating a plausible tolerance model based on similarity to existing, manually curated models.

### Key constraint:

- The ML model does not decide behavior, safety, dosage, or recommendations.
- It only proposes tolerance-model parameters that already exist in the system.

## Why This Fits the Existing Design Philosophy

This proposal is explicitly aligned with the principles described in the README and TECHNICAL_DEEP_DIVE:

- ✔ Deterministic Core Remains Intact

  - All tolerance math stays unchanged
  - All safety logic stays rule-based
  - ML output is just structured input

- ✔ Explainability First

  Output includes:

  - which known substances it was derived from
  - confidence score
  - conservative defaults when uncertain
  - No black-box “scores”

- ✔ Privacy-Preserving

  - No user data
  - No behavioral feedback loops
  - Trained only on static, curated substance metadata

- ✔ Harm-Reduction Oriented

  - Never claims “safe”
  - Never reduces warnings
  - Only fills knowledge gaps conservatively

## Explicit Non-Goals (Hard Boundaries)

The ML system will never:

- Predict safety or risk
- Recommend combinations
- Modify interaction rules
- Infer dosage
- Learn from user actions
- Provide medical claims

Any output that could influence user behavior remains rule-gated and conservatively framed.

## What the ML Model Actually Does

### Input Features (Derived From Existing Data)

- Substance categories
- Neurotransmitter bucket presence
- Relative mechanism weights
- Duration / half-life ranges
- Known cross-tolerance patterns
- Similarity to substances with defined tolerance models

### Output (Only These Fields)

- Neuro bucket weights (estimated)
- Tolerance gain rate
- Tolerance decay time
- Potency normalization
- Confidence score

Nothing else.

### Output Example

```
{
  "model_origin": "ml_inferred",
  "confidence": 0.61,
  "derived_from": ["MDMA", "MDA", "5-APB"],
  "neuro_buckets": {
    "serotonin_release": { "weight": 0.9 },
    "stimulant": { "weight": 0.3 }
  },
  "tolerance_gain_rate": 1.0,
  "tolerance_decay_days": 28,
  "notes": "Estimated via pharmacological similarity. Conservative decay applied due to limited human data."
}
```

This structure mirrors existing tolerance models and integrates cleanly with the current system.

## Integration Strategy

- If a manual tolerance model exists → ML is ignored
- If no model exists → ML can propose one

UI labels clearly distinguish:

- “Defined model”
- “Estimated model”

Developers can override or lock models at any time

This preserves full developer control.

## User Communication & Safety Language

In line with the README’s safety stance:

- ML-derived tolerance models are explicitly labeled
- Language avoids certainty

Outputs are described as:

- “Estimated tolerance behavior”
- “Guideline-level information”
- “Not medical advice”

This ensures users understand:

- These are educational abstractions
- Not predictive or prescriptive truths

## Ethical Positioning

This approach reflects the app’s broader philosophy:

- Uncertainty is made visible, not hidden
- Lack of data does not imply safety
- Mechanistic reasoning is preferred over anecdote
- Conservative defaults are always chosen

Rather than encouraging use, the system helps explain why tolerance and cross-tolerance matter.

## Why This Is Optional (and Intentionally So)

As emphasized in the TECHNICAL_DEEP_DIVE:

- The system must remain valid even without ML.

This proposal is deliberately positioned as:

- Optional
- Future-facing
- Research-oriented

The app remains complete and coherent without it.

## Summary

This proposal introduces a narrow, controlled ML component that:

- Operates fully within existing architectural rules
- Assists only with tolerance model estimation
- Never asserts safety or medical claims
- Improves scalability and consistency
- Makes uncertainty explicit rather than implicit

All outputs remain guidelines, not truths.