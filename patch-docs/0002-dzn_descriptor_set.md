# Patch 0002: `dzn_descriptor_set`

## Source
- `patches/0002-dzn_descriptor_set.diff`

## Scope
- File: `src/microsoft/vulkan/dzn_descriptor_set.c`
- Changes:
  - safe guard in `dzn_descriptor_heap_get_cpu_handle()`
  - OODM diagnostics (`DZN_OODM_TRACE`)
  - dynamic shader-visible CBV/SRV/UAV growth policy
  - baseline env override (`DZN_CBV_SRV_UAV_HEAP_MIN_DESC`)

## Why
- Prevent null/bounds dereference behavior in descriptor handle path.
- Better handle descriptor pressure while preserving tunable policy.

## Investigation-only parts
- `DZN_OODM_TRACE` diagnostics.

## Validation notes
- OODM path became explicit and attributable via trace markers.
- Dynamic growth path aligns with improved stable runs.

## Upstream note
- Handle guard and core robustness are high-value.
- Growth policy defaults may need broader workload feedback.
