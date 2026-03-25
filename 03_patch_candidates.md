# 3) Patch Candidates For Upstream

Source tree:
- `/home/malware/projects/civ7linux/mesa-debug/src/mesa`

## Candidate A: dzn queue family transfer granularity
- File: `src/microsoft/vulkan/dzn_device.c`
- Local change:
  - `minImageTransferGranularity` from `{0,0,0}` to `{1,1,1}` for direct/compute queues.
- Why:
  - Prior validation runs were dominated by copy/granularity VUIDs.
  - After this change, those VUIDs dropped sharply.
- Upstream readiness:
  - High. This is a spec-facing capability advertisement fix.

## Candidate B: dzn descriptor heap null/bounds safety
- File: `src/microsoft/vulkan/dzn_descriptor_set.c`
- Local change:
  - Guard in `dzn_descriptor_heap_get_cpu_handle` returns null handle when heap/cpu_base invalid or offset out of bounds.
- Why:
  - GDB fault observed with `heap=0x0` and direct dereference.
- Upstream readiness:
  - Medium-high. Defensive error-path hardening likely acceptable if behavior is correct for callers.

## Candidate C: dzn command buffer OOM/error propagation hardening
- File: `src/microsoft/vulkan/dzn_cmd_buffer.c`
- Local change:
  - Added missing checks and returns for descriptor heap allocation failures across RTV/DSV/null RTV and heap update paths.
  - Prevent repeated allocation attempts once command buffer has a recorded error.
- Why:
  - Repeated OODM paths and later crashes were observed.
- Upstream readiness:
  - High, after cleanup to keep only behavior changes (remove local telemetry logging if requested).

## Candidate D: runtime queue submit guardrails
- File: `src/vulkan/runtime/vk_queue.c`
- Local change:
  - `vk_queue_submit_add_command_buffer` now validates device mask, queue family, and command buffer state with error return.
  - `vk_queue_submit_create` now propagates failure.
- Why:
  - Frequent invalid submit patterns (`pCommandBuffers-00070`) in traces.
- Upstream readiness:
  - Medium. Runtime-layer policy changes may need maintainer discussion on exact error code and strictness.

## Candidate E: larger shader-visible CBV/SRV/UAV heap target
- File: `src/microsoft/vulkan/dzn_descriptor_set.c`
- Local change:
  - Raise default minimum shader-visible CBV/SRV/UAV heap target to `16384` descriptors.
  - Add env override: `DZN_CBV_SRV_UAV_HEAP_MIN_DESC`.
- Why:
  - OODM trace showed repeated growth failure at `offset=2022`, `req_desc=40`, `heap=2048`.
- Upstream readiness:
  - Medium. Needs broader perf/memory tradeoff validation and maintainer feedback.

## Local instrumentation (likely not upstream as-is)
- `DZN_CONTRACT_LOG` and `DZN_OODM_TRACE` logs in:
  - `src/microsoft/vulkan/dzn_device.c`
  - `src/microsoft/vulkan/dzn_descriptor_set.c`
  - `src/microsoft/vulkan/dzn_cmd_buffer.c`
- Use:
  - Investigation and reproducibility.
- Recommendation:
  - Keep in local branch, or submit separately only if maintainers request.

