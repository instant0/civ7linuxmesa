# 5) Evidence Index

## Core project docs
- Patch registry:
  - `/home/malware/projects/civ7linux/docs/patch_registry.md`
- Full progress log:
  - `/home/malware/projects/civ7linux/docs/wsl_vulkan_debug_progress.md`

## Failing run evidence (`20260325_222212`)
- Summary:
  - `/home/malware/projects/civ7linux/docs/trace_runs/20260325_222212/trace_summary.txt`
- Driver/app trace:
  - `/home/malware/projects/civ7linux/docs/trace_runs/20260325_222212/game_trace.log`
- Kernel slice:
  - `/home/malware/projects/civ7linux/docs/trace_runs/20260325_222212/dmesg_run_raw.txt`
- Exit code:
  - `/home/malware/projects/civ7linux/docs/trace_runs/20260325_222212/exit_code.txt`

## Successful run evidence (`20260325_222638`)
- Summary:
  - `/home/malware/projects/civ7linux/docs/trace_runs/20260325_222638/trace_summary.txt`
- Driver/app trace:
  - `/home/malware/projects/civ7linux/docs/trace_runs/20260325_222638/game_trace.log`
- Kernel slice:
  - `/home/malware/projects/civ7linux/docs/trace_runs/20260325_222638/dmesg_run_raw.txt`
- Exit code:
  - `/home/malware/projects/civ7linux/docs/trace_runs/20260325_222638/exit_code.txt`

## Additional capture artifacts
- gfxrecon capture:
  - `/home/malware/projects/civ7linux/docs/gfxrecon_runs/civ7_20260325T220748.gfxr`
- gfxrecon analysis snippets:
  - `/home/malware/projects/civ7linux/docs/gfxrecon_runs/analysis/civ7_220748_tail600.jsonl`
  - `/home/malware/projects/civ7linux/docs/gfxrecon_runs/analysis/civ7_220748_queue_tail300.jsonl`
  - `/home/malware/projects/civ7linux/docs/gfxrecon_runs/analysis/civ7_220748_index_window.jsonl`

## Local patch material
- Combined diff:
  - `/home/malware/projects/civ7linux/patch-details/patches/0000-combined.diff`
- Per-file diffs:
  - `/home/malware/projects/civ7linux/patch-details/patches/0001-dzn_device.diff`
  - `/home/malware/projects/civ7linux/patch-details/patches/0002-dzn_descriptor_set.diff`
  - `/home/malware/projects/civ7linux/patch-details/patches/0003-dzn_cmd_buffer.diff`
  - `/home/malware/projects/civ7linux/patch-details/patches/0004-vk_queue.diff`

