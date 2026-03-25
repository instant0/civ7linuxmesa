# dzn: WSL2 Civ7 stability fixes (OOM/error-path hardening + granularity correction)

## What this MR does
This MR contains correctness/stability fixes observed while debugging Civ7 on WSL2+dzn:

1. Fix queue family transfer granularity advertisement (`minImageTransferGranularity={1,1,1}`).
2. Harden dzn descriptor/cmd-buffer error paths for allocation/OOM/null-handle cases.

Optional follow-up (if included):
3. Tune shader-visible CBV/SRV/UAV heap minimum size to reduce heap churn under descriptor pressure.

## Why
Observed failure path under load:
- descriptor heap growth can fail with `VK_ERROR_OUT_OF_DEVICE_MEMORY`
- command buffer end fails afterwards
- downstream app crash behavior follows

This patch set focuses on preventing invalid state propagation and reducing avoidable heap churn.

## Test environment
- WSL2 Ubuntu 24.04.4, kernel `6.6.87.2-microsoft-standard-WSL2`
- NVIDIA RTX 4080, dzn (D3D12 backend)
- Mesa base: `16e15ee20514de1684b349e809fa9632e5afbe4d`

## Validation summary
- Before: frequent OODM markers and reproducible crash runs (`exit_code=139`).
- After: successful stress run observed (`exit_code=0`) with no OODM markers in run trace.

## Evidence references
- failing run: `/home/malware/projects/civ7linux/docs/trace_runs/20260325_222212`
- successful run: `/home/malware/projects/civ7linux/docs/trace_runs/20260325_222638`
- detailed timeline: `/home/malware/projects/civ7linux/docs/wsl_vulkan_debug_progress.md`

## Notes
- Some local instrumentation used for diagnosis (`DZN_CONTRACT_LOG`, `DZN_OODM_TRACE`) is intentionally kept out of this MR unless requested.

