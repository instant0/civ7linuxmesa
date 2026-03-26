# 4) Validation And Results

## Baseline failure signatures
- `VK_ERROR_OUT_OF_DEVICE_MEMORY` / `VK_ERROR_OUT_OF_POOL_MEMORY` in descriptor-related paths.
- submit-state invalidation following allocation pressure.
- unstable runs exiting with `139`.

## Representative failing run
- Run ID: `20260325_222212`
- Exit code: `139`
- High-signal markers:
  - `DZN_OODM[pool_alloc] ... type=CBV_SRV_UAV ... target_heap_desc=2048 err=-2`
  - `DZN_OODM[update_heaps_alloc_slot]: err=-2`
  - `DZN_OODM[vk_command_buffer_end]: err=-2`

## Representative improved runs
- Run ID: `20260325_222638` (exit `0`)
- Run ID: `20260326_213955` (exit `0`)
- Markers:
  - no VUID spikes,
  - no OODM markers in the main trace log,
  - clean process exit.

## Inference
- The patch set materially improves stability in the tested workload.
- `dxgkio_query_adapter_info` warnings alone are not sufficient crash predictors.
