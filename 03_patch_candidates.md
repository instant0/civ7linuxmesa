# 3) Patch Candidates For Upstream

## Candidate A: queue-family transfer granularity correction
- File: `src/microsoft/vulkan/dzn_device.c`
- Change: set `minImageTransferGranularity` from `{0,0,0}` to `{1,1,1}`.
- Upstream readiness: high.

## Candidate B: descriptor heap handle guard
- File: `src/microsoft/vulkan/dzn_descriptor_set.c`
- Change: guard `dzn_descriptor_heap_get_cpu_handle()` for null/base/offset bounds and return null handle safely.
- Upstream readiness: medium-high.

## Candidate C: command-buffer allocation/error propagation hardening
- File: `src/microsoft/vulkan/dzn_cmd_buffer.c`
- Changes:
  - check/propagate allocation failures in RTV/DSV/null-RTV paths,
  - improve `HRESULT -> VkResult` mapping at command list close,
  - avoid repeated allocation churn once command buffer is already in error.
- Upstream readiness: high after stripping investigation-only logging if requested.

## Candidate D: queue submit guardrails with fail-soft behavior
- File: `src/vulkan/runtime/vk_queue.c`
- Changes:
  - validate device mask, queue family, and command-buffer state,
  - return error and propagate submit-create failure,
  - avoid assert-first abort in this path for local stability diagnostics.
- Upstream readiness: medium (runtime policy/return-code discussion likely required).

## Candidate E: dynamic CBV/SRV/UAV heap growth policy
- File: `src/microsoft/vulkan/dzn_descriptor_set.c`
- Changes:
  - dynamic growth with baseline env override (`DZN_CBV_SRV_UAV_HEAP_MIN_DESC`),
  - baseline default `2048`, then bounded doubling.
- Upstream readiness: medium (needs broader perf/memory tradeoff discussion).

## Investigation-only instrumentation
- `DZN_CONTRACT_LOG`, `DZN_OODM_TRACE`, `DZN_SYNC_TRACE`
- Recommendation: keep local or submit separately if maintainers request.
