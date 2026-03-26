# Mesa dzn Stability Patch Bundle (WSL2)

This repository contains a patch bundle and supporting notes for upstream discussion in Mesa.

## Base revision
- Mesa base commit: `16e15ee20514de1684b349e809fa9632e5afbe4d`

## Contents
- `01_environment.md`: sanitized environment summary.
- `02_reproduction.md`: generic reproduction guidance.
- `03_patch_candidates.md`: per-change upstream suitability.
- `04_validation_and_results.md`: before/after behavior summary.
- `05_evidence_index.md`: evidence map by run ID and signal type.
- `06_submission_checklist.md`: pre-submission checklist.
- `patch-docs/`: one independent tracker per patch file.
- `templates/issue_template.md`: issue draft template.
- `templates/mr_template.md`: merge request draft template.
- `patches/0000-combined.diff`: full local diff.
- `patches/0001-0004*.diff`: split diffs by area.

## Scope constraints
- No proprietary game name/path references.
- No personal usernames or local absolute-path assumptions in docs/templates.

## Note on instrumentation
Investigation-only logging (`DZN_CONTRACT_LOG`, `DZN_OODM_TRACE`, `DZN_SYNC_TRACE`) is intentionally retained here for reproducibility notes, but may be split from a minimal upstream MR if requested.
