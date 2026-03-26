# 6) Submission Checklist (Mesa)

## A. Split and clean
- [ ] Start from `16e15ee20514de1684b349e809fa9632e5afbe4d`.
- [ ] Keep commits small and scoped by subsystem.
- [ ] Exclude instrumentation-only logging unless requested.

## B. Validate
- [ ] Build succeeds.
- [ ] `vulkaninfo --summary` succeeds with patched ICD.
- [ ] Repro scenario tested before/after.
- [ ] Include at least one failing baseline and one improved run.

## C. Commit quality
- [ ] Explain symptom, root cause, fix rationale, and test evidence.
- [ ] Include `Signed-off-by` on each commit.

## D. Issue/MR package
- [ ] Include sanitized environment and repro steps.
- [ ] Include evidence markers and exit codes.
- [ ] List residual risks and follow-up items.

## E. Suggested first-MR scope
1. queue granularity correction
2. OOM/null propagation hardening in descriptor/cmd-buffer paths

Then follow with policy/performance changes as separate discussion.
