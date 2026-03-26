# Patch 0001: `dzn_device`

## Source
- `patches/0001-dzn_device.diff`

## Scope
- File: `src/microsoft/vulkan/dzn_device.c`
- Changes:
  - queue transfer granularity correction to `{1,1,1}`
  - contract logging (`DZN_CONTRACT_LOG`)
  - sync tracing (`DZN_SYNC_TRACE`)
  - dual-source blend feature gate (`DZN_EXPERIMENTAL_DUAL_SRC_BLEND`)

## Why
- Correct spec-facing queue capability advertisement.
- Gather high-signal runtime/feature negotiation evidence.

## Investigation-only parts
- `DZN_CONTRACT_LOG`
- `DZN_SYNC_TRACE`
- dual-src feature gate toggles for controlled A/B diagnostics.

## Validation notes
- Reduced transfer-granularity validation noise after correction.
- Contract logs confirmed application extension/feature request profile.

## Upstream note
- Granularity fix is high confidence.
- Instrumentation and experimental toggles likely belong in follow-up discussion or local branch.
