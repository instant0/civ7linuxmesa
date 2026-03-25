# 2) Reproduction

## Repro goal
Trigger the late-run crash and collect enough evidence to distinguish:
- driver/internal OODM path
- app-side null dereference
- validation-only noise

## Minimal launch command (diagnostic)
```bash
/home/user/projects/civ7linux/launcher_trace_contract.sh \
  --adapter NVIDIA \
  --no-validation --no-api-dump --no-d3d12-debug \
  --sync legacy --thread-submit 0 \
  --oodm-trace
```

## Trigger pattern
- Load into gameplay map.
- Perform high-rate camera/map movement and UI-heavy actions (combat, city actions, save UI interactions).
- In unstable runs, crash often follows increased render/update pressure.

## Reference run IDs
- Failing OODM + segfault run:
  - `20260325_222212`
- Successful stress run (exit cleanly):
  - `20260325_222638`

## Expected artifacts per run
- `game_trace.log`
- `trace_summary.txt`
- `dmesg_run_raw.txt`
- `exit_code.txt`
- `run_meta.txt`

