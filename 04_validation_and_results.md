# 4) Validation And Results

## Baseline instability signatures
- Early signatures included:
  - `VK_ERROR_OUT_OF_DEVICE_MEMORY` in dzn descriptor paths.
  - SIGSEGV in `dzn_descriptor_heap_get_cpu_handle`.
  - frequent invalid submit validation (`VUID-vkQueueSubmit-pCommandBuffers-00070`).
  - repeated crash site in app image around `ip 0x1df9b30`.

## High-signal failing run
- Run ID: `20260325_222212`
- Exit code: `139`
- Key evidence:
  - `DZN_OODM[pool_alloc] ... type=CBV_SRV_UAV ... req_desc=40 offset=2022 ... target_heap_desc=2048 err=-2`
  - `DZN_OODM[update_heaps_alloc_slot]: err=-2`
  - `DZN_OODM[vk_command_buffer_end]: err=-2`
  - dmesg: `segfault at 0 ip 0000000001df9b30 ... in Civ7_linux_Vulkan_FinalRelease`

## High-signal successful run
- Run ID: `20260325_222638`
- Exit code: `0`
- User stress conditions:
  - Increased graphics settings (`2560x1400`, low -> medium), map stress and combat.
- Key evidence:
  - `trace_summary.txt`: no VUIDs, no critical markers.
  - `game_trace.log`: no OODM markers.
  - clean process exit.

## Inference
- The local patch set significantly improved stability for this workload and removed the specific OODM signature in at least one heavy stress run.
- Remaining `dxgkio_query_adapter_info` warnings in dmesg appear in both failing and successful runs and are not sufficient crash predictors by themselves.

