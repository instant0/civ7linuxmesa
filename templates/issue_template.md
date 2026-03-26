# [dzn][WSL2] Descriptor-pressure instability and submit-state fallout

## Summary
Under a heavy Vulkan workload on WSL2+dzn, descriptor-pressure can trigger OOM-related failures in descriptor/cmd-buffer paths, followed by submit-state instability.

## Environment
- Mesa base commit: `16e15ee20514de1684b349e809fa9632e5afbe4d`
- Platform class: WSL2 Linux guest on Windows host
- GPU class: discrete NVIDIA (dzn over D3D12)

## Repro
Use patched ICD and run a high-pressure scene with:
- `MESA_VK_D3D12_SYNC=legacy`
- `MESA_VK_D3D12_THREAD_SUBMIT=0`
- optional diagnostics: `DZN_OODM_TRACE=1`, `DZN_SYNC_TRACE=1`

## Observed signals
- OODM traces in CBV/SRV/UAV heap growth/allocation paths.
- downstream command buffer end/submit-state failures in unstable runs.

## Proposed fixes
- queue-family granularity correction
- descriptor/cmd-buffer OOM/null propagation hardening
- optional follow-up: dynamic descriptor heap growth policy tuning

## Evidence
- failing run reference: `20260325_222212`
- improved run references: `20260325_222638`, `20260326_213955`
