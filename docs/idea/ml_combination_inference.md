Machine-Learning–Assisted Drug Combination Inference

Research Proposal (Non-Medical, Guideline-Only)

## Status

Concept / Research Direction – Not Implemented

This document describes a future, experimental system intended to augment static drug-interaction charts through conservative, mechanism-based inference.
It does not claim medical accuracy, safety guarantees, or predictive certainty.

## Motivation

Static interaction matrices (e.g. TripSit-style charts) are the current gold standard for harm-reduction guidance. However, they have structural limitations:

- They only cover explicitly documented combinations
- They do not generalize well to novel or obscure substances
- They cannot explain why a combination is risky
- They cannot scale without manual expert curation

At the same time, traditional “risk prediction” ML models are ethically inappropriate in this domain.

This proposal explores a separate ML model whose sole purpose is:

To conservatively infer possible interaction risk categories for previously undocumented combinations, using pharmacological mechanism similarity — never to claim safety.

## Explicit Non-Goals

This model will never:

- Predict “safe” drug combinations
- Provide probabilities of harm or safety
- Replace known interaction rules
- Override expert-curated data
- Make medical claims

The output is guidance, not truth.

## High-Level Architecture

This model is fully separate from the tolerance model.

┌──────────────────────┐
│ Tolerance ML Model   │  →  Individual adaptation over time
└──────────────────────┘

┌────────────────────────────────────┐
│ Combination ML Model (This Doc)    │
│  - Pairwise / multi-drug analysis  │
│  - Mechanism similarity            │
│  - Conservative classification     │
└────────────────────────────────────┘

They may share inputs, but not logic or outputs.

## Core Idea

Instead of predicting outcomes, the model performs comparative reasoning:

“Given what we know about documented combinations, how similar is this unknown combination in terms of mechanisms, load, and pharmacokinetics?”

The result is a risk category suggestion, never lower than caution, and always paired with uncertainty metadata.

## Model Inputs

Each substance is represented as a structured vector, not free text:

- Neuro-mechanism weights
  (GABA, stimulant, NMDA, serotonin release, opioid, etc.)
- Pharmacokinetics
  (half-life, duration, onset)
- Potency normalization
- Known red-flag properties
  (MAOI, respiratory depression, seizure risk)

These inputs already exist in your data model.

## Training Data Concept

The model is trained only on known combinations, such as:

- Existing curated interaction matrices
- Expert-annotated combination categories
- Literature-backed interactions

Each training sample looks like:

```
{
  "drug_a_features": {...},
  "drug_b_features": {...},
  "known_classification": "Dangerous"
}
```

The model learns patterns of similarity, not outcomes.

## Inference Behavior

When presented with an unknown combination:

- The model compares it to known combinations
- Identifies closest mechanism matches
- Outputs a minimum-risk classification
- Attaches an uncertainty score
- Includes an explanation trace

### Example Output

```
{
  "classification": "Caution",
  "confidence": "Low",
  "reasoning": [
    "Shared serotonergic release",
    "Additive stimulant load",
    "Limited human data for compound B"
  ],
  "note": "This classification is inferred from pharmacological similarity and should be treated as a conservative guideline, not a statement of safety."
}
```

## Risk Floor Enforcement

A key design constraint:

- The ML model is not allowed to output “Low Risk” for undocumented combinations.

Minimum possible output:

- Caution

This ensures:

- No false reassurance
- No green-lighting of novel mixes
- Alignment with harm-reduction ethics

## Relationship to Rule-Based Systems

This ML model does not replace hard rules.

If any of the following are present:

- MAOI + serotonergic agent
- Dual respiratory depressants
- Known seizure-threshold lowering combinations

Then:

- ML output is ignored
- Deterministic classification applies
- Rules always win.

## Transparency & Explainability

Every output must include:

- Mechanism overlap summary
- Known vs inferred distinction
- Explicit uncertainty labeling
- Clear disclaimers

No black-box outputs are allowed.

## Ethical Position

This model is designed under the assumption that:

- Data in this domain is incomplete
- Individual physiology varies widely
- Harm reduction requires conservatism
- Overconfidence is dangerous

Therefore:

- Uncertainty increases caution
- Lack of data never reduces risk
- ML is advisory, not authoritative

## Why This Model Is Separate from Tolerance ML

Keeping these models separate avoids:

- Conflating long-term adaptation with acute interaction risk
- Accidental risk amplification
- Misinterpretation of outputs

Tolerance ML answers:

"How might this person respond over time?"

Combination ML answers:

"How risky might this pair be in general?"

Different questions → different models.

## Summary

This proposal describes a standalone, conservative ML system that:

- Infers interaction risk categories via similarity
- Never predicts safety
- Never overrides known dangers
- Always communicates uncertainty
- Exists to fill gaps, not replace expertise

It is intended as an experimental harm-reduction aid, not a medical or predictive system.