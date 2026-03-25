# [dzn][WSL2] Civ7 instability: OODM in descriptor heap growth and downstream crash behavior

## Summary
On WSL2 (Ubuntu 24.04.4) using dzn over D3D12 with an RTX 4080, Civ7 triggers instability under heavy map/UI/combat workloads. Investigation shows OODM in shader-visible CBV/SRV/UAV heap growth paths, followed by command buffer end failure and eventual process crash.

## Environment
- Mesa base commit: `16e15ee20514de1684b349e809fa9632e5afbe4d`
- Kernel: `Linux ... 6.6.87.2-microsoft-standard-WSL2 ...`
- GPU: NVIDIA GeForce RTX 4080
- ICD: dzn (`libvulkan_dzn.so`)
- App: `Civ7_linux_Vulkan_FinalRelease`

## Repro
```bash
/home/username/projects/civ7linux/launcher_trace_contract.sh \
  --adapter NVIDIA \
  --no-validation --no-api-dump --no-d3d12-debug \
  --sync legacy --thread-submit 0 \
  --oodm-trace
```
Stress with fast map movement + UI/combat transitions.

## Observed signals
- OODM trace sample:
  - `DZN_OODM[pool_alloc]: type=CBV_SRV_UAV ... req_desc=40 offset=2022 ... target_heap_desc=2048 err=-2`
  - `DZN_OODM[vk_command_buffer_end]: err=-2`
- Crash sample:
  - `segfault at 0 ip 0000000001df9b30 ... in Civ7_linux_Vulkan_FinalRelease`

## Proposed fixes submitted
- queue transfer granularity advertisement (`{1,1,1}`)
- dzn OOM/null error-path hardening in descriptor/cmd-buffer paths
- (optional/follow-up) larger minimum shader-visible CBV/SRV/UAV heap target

## Evidence
- failing run: `docs/trace_runs/20260325_222212/*`
- successful run after patching: `docs/trace_runs/20260325_222638/*`

