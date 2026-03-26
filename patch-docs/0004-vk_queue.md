# Patch 0004: `vk_queue` submit guardrails + fail-soft ordering

## Source
- `patches/0004-vk_queue.diff`

## Scope
- File: `src/vulkan/runtime/vk_queue.c`
- Changes:
  - `vk_queue_submit_add_command_buffer()` returns `VkResult`
  - validates device mask, queue family, and command-buffer state
  - propagates failures through `vk_queue_submit_create()`
  - replaces assert-first behavior in this path with fail-soft return checks

## Why
- Prevent invalid command buffer lifecycle state from crashing immediately in assert-enabled builds.
- Ensure submit assembly can terminate with explicit error instead of abort.

## Validation notes
- Removes known assert-first crash path observed after OOM/state cascades.

## Upstream note
- Behavior is practical for local stability testing.
- Return-code and runtime-policy semantics may require maintainer discussion.
