# Mesa Upstream Patch Bundle (Civ7 on WSL2/dzn)

This folder contains a submission-ready bundle for upstreaming the findings from the Civ7 Vulkan stability work on WSL2.

## Base revision
- Mesa tree: `/home/malware/projects/civ7linux/mesa-debug/src/mesa`
- Base commit: `16e15ee20514de1684b349e809fa9632e5afbe4d`

## Contents
- `01_environment.md`: exact environment and runtime profile.
- `02_reproduction.md`: reproducible test recipe.
- `03_patch_candidates.md`: patch-by-patch upstream suitability.
- `04_validation_and_results.md`: before/after outcomes.
- `05_evidence_index.md`: evidence files and key lines.
- `06_submission_checklist.md`: what to do before posting to Mesa.
- `templates/issue_template.md`: issue draft.
- `templates/mr_template.md`: merge request draft.
- `patches/0000-combined.diff`: all local Mesa changes.
- `patches/0001-*.diff` ... `0004-*.diff`: per-file diffs.

## Important note
Not all local changes should be upstreamed as-is. In particular, instrumentation-only changes (`DZN_CONTRACT_LOG`, `DZN_OODM_TRACE`) should usually be split out or kept local unless Mesa maintainers request them.

