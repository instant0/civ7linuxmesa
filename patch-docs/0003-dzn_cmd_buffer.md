# Patch 0003: `dzn_cmd_buffer`

## Source
- `patches/0003-dzn_cmd_buffer.diff`

## Scope
- File: `src/microsoft/vulkan/dzn_cmd_buffer.c`
- Changes:
  - error propagation for RTV/DSV/null-RTV/heap allocation paths
  - improved `HRESULT -> VkResult` mapping in `dzn_EndCommandBuffer()`
  - avoid repeated allocation attempts once command buffer is in error
  - OODM diagnostics around failure sites

## Why
- Convert latent invalid-state cascades into explicit errors.
- Preserve actionable signal when allocation pressure causes failures.

## Investigation-only parts
- OODM detailed logging outputs.

## Validation notes
- OOM and downstream cmd-buffer error transitions are now visible and attributable.

## Upstream note
- Core error-propagation hardening is high confidence.
- Logging verbosity should be reviewed for upstream inclusion.
