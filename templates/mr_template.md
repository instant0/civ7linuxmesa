# dzn: WSL2 stability fixes for descriptor-pressure and submit-state handling

## What this MR changes
1. Correct queue-family transfer granularity advertisement.
2. Harden descriptor/cmd-buffer OOM and null-handle error propagation.
3. Add queue-submit guardrails to prevent invalid state propagation.

## Why
Observed failure pattern under load:
- descriptor allocation pressure -> OOM/failed allocation
- command buffer enters invalid state
- submit path instability follows

These changes convert fragile failure cascades into explicit, recoverable error paths.

## Validation summary
- Before: reproducible unstable runs with OOM markers and crash exits.
- After: stable runs observed with clean exit and no OOM markers in primary trace logs.

## Environment class
- WSL2 + dzn over D3D12
- Mesa base: `16e15ee20514de1684b349e809fa9632e5afbe4d`

## Notes
- Investigation-only logging knobs (`DZN_CONTRACT_LOG`, `DZN_OODM_TRACE`, `DZN_SYNC_TRACE`) are not required for core fix behavior and can be split out.
