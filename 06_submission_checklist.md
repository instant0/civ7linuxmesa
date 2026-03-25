# 6) Submission Checklist (Mesa)

## A. Split and clean patches
- [ ] Create a fresh branch from `16e15ee20514de1684b349e809fa9632e5afbe4d`.
- [ ] Split into small logical commits:
  - `dzn`: queue transfer granularity fix
  - `dzn`: OOM/error-path hardening in descriptor/cmd buffer paths
  - optional: heap sizing policy change
  - optional: runtime queue guardrails (if accepted)
- [ ] Remove or isolate instrumentation-only logging unless requested by maintainers.

## B. Validate locally
- [ ] Build succeeds (`meson` + `ninja`) on your configuration.
- [ ] `vulkaninfo --summary` succeeds with patched ICD.
- [ ] Repro scenario tested before and after patch set.
- [ ] Capture at least:
  - one failing baseline run
  - one improved/stable run

## C. Quality requirements
- [ ] Commit messages explain:
  - symptom
  - root cause
  - why fix is correct
  - test evidence
- [ ] Add `Signed-off-by: <name> <email>` to each commit (DCO).
- [ ] Run formatting/check steps used by Mesa maintainers where applicable.

## D. Issue + MR contents
- [ ] Include exact environment, GPU, WSL kernel, Mesa base commit.
- [ ] Include minimized repro recipe.
- [ ] Link evidence files and key lines.
- [ ] State residual risks / known limitations.

## E. Recommended scope for first MR
- Prefer starting with high-confidence correctness fixes:
1. queue granularity
2. OOM/NULL propagation in dzn descriptor/cmd-buffer paths

Then send policy/perf tuning changes (heap sizing) as follow-up with separate discussion.

