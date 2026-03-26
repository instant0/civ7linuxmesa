# 2) Reproduction

## Repro goal
Exercise a heavy Vulkan workload that previously triggered descriptor-pressure and submit-state instability.

## Diagnostic launch pattern (generic)
```bash
env \
  VK_ICD_FILENAMES="<patched_dzn_icd_json>" \
  VK_DRIVER_FILES="<patched_dzn_icd_json>" \
  DZN_CONTRACT_LOG=1 \
  DZN_OODM_TRACE=1 \
  DZN_SYNC_TRACE=1 \
  MESA_VK_D3D12_SYNC=legacy \
  MESA_VK_D3D12_THREAD_SUBMIT=0 \
  <vulkan_app_binary> > game_trace.log 2>&1
```

## Trigger pattern
- Run a scene with sustained camera movement, render pressure, and frequent UI transitions.
- Observe whether descriptor allocation pressure appears before failure.

## Expected artifacts
- `game_trace.log`
- `trace_summary.txt`
- `dmesg_run_raw.txt`
- `exit_code.txt`
- `run_meta.txt`
