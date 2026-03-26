# 5) Evidence Index

## Run IDs used in analysis
- `20260325_222212`: failing reference run (OOM/signature path).
- `20260325_222638`: first stable reference run.
- `20260326_213955`: stable follow-up run using patched ICD and safe sync settings.

## Evidence categories
- Driver/application stderr (`game_trace.log`)
- Summary extraction (`trace_summary.txt`)
- Kernel delta (`dmesg_run_raw.txt`)
- Run metadata (`run_meta.txt`)
- Exit status (`exit_code.txt`)

## Key marker patterns
- OOM: `DZN_OODM[...]`, `VK_ERROR_OUT_OF_DEVICE_MEMORY`, `VK_ERROR_OUT_OF_POOL_MEMORY`
- Submit/state: queue-submit VUIDs, command-buffer state errors
- Kernel-side: `segfault`, `DEVICE_REMOVED`, `dxgkio_*`
