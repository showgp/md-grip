---
name: tasks-to-tickets
description: Turn one approved OpenSpec change's proposal, specs, design, and tasks into reviewable, locally stored, agent-ready tickets.
disable-model-invocation: true
---

# Tasks to Tickets

Turn one active OpenSpec change into vertical implementation handoffs. OpenSpec specs remain the behavioral authority and `tasks.md` remains the sole change-progress ledger. Tickets live beside `tasks.md` under the selected change's `tickets/` directory, not under `specs/` or an issue tracker. Publish the complete ticket set for the approved tasks in one batch, then stop for overall user review; do not implement, check OpenSpec tasks, commit, sync specs, or archive.

## 1. Resolve the approved change

- Select the change named by the user. If ambiguous, list active changes and ask. Run `openspec status --change "<name>" --json` and `openspec instructions apply --change "<name>" --json`, preserving the selected root or `--store` flag. Require complete planning artifacts and a non-blocked apply state. Use the returned `changeRoot` and `contextFiles`; never assume the current repository is the change's home.
- Read every current context file: proposal, **all** affected capability specs, design, and tasks. Read any applicable repository policies (if present) and inspect the relevant project surface if it exists. Parse the actual checkbox labels in `tasks.md` (such as `2.3`), not the CLI's sequential array IDs. Compare them with apply's task count and descriptions. If CLI descriptions omit verification text because a checkbox is split across physical lines, surface the mismatch; request approval before repairing the task artifact, and do not publish tickets from an ambiguous task list.
- Read any existing `<changeRoot>/tickets/` entries before proposing more. Preserve user edits and completed tickets; never overwrite or renumber an existing ticket without separate approval. If source artifacts changed after tickets were approved, identify affected tickets for review rather than silently regenerating them.

## 2. Plan the complete ticket set

- Split by a narrow **end-to-end deliverable** that can be demonstrated or otherwise verified in one fresh implementation session, including the tests and user documentation that deliverable calls for. Reuse Matt `to-tickets`' vertical-slice and genuine-blocker reasoning, not its external-tracker setup. Setup work that genuinely gates a runnable slice may be included in that slice; a final integration/review ticket is a verification-only exception, not a fabricated product feature. Do not turn each horizontal checkbox into a ticket automatically.
- Maintain complete coverage for every OpenSpec checkbox and in-scope spec requirement/scenario across preserved existing tickets and the new batch. Reconstruct the coverage plan from current artifacts before publication. Check each narrow deliverable's genuine blockers without introducing cycles or serializing independent work; numbering and review order do not create implementation dependencies. If the approved tasks cannot cover the spec, or a task needs splitting, propose an OpenSpec artifact revision and wait for its separate approval rather than publishing an incomplete or ambiguous set.
- For each ticket, name a stable `NN-kebab-case` ID, its observable deliverable, the exact OpenSpec task labels it contributes to, affected spec paths and requirement/scenario names, relevant design decisions, concrete acceptance checks, and the other tickets that genuinely block it. Use relative context paths from `tickets/`, so archived changes remain readable. Record `Status: open` or `Status: done` only; ticket checklist boxes are acceptance details, not a second progress ledger. An open ticket stays open until its entire deliverable is verified.

## 3. Publish the complete batch, then stop for overall review

When the user requests ticket creation, write all missing tickets in the complete coverage plan directly to `<changeRoot>/tickets/<NN-kebab-case>.md` in one batch. Do not overwrite, renumber or revise existing tickets without separate approval, and do not change `tasks.md`. Show the complete published ticket set, task mappings, genuine blockers and a coverage table for **every** OpenSpec task and in-scope spec requirement/scenario, then stop for overall user review. If the user requests revisions, update only the approved ticket scope and stop for review again. Identify any existing tickets needing renewed review because their source artifacts changed. Resolve all uncovered scope before declaring publication complete. No OpenSpec task can be checked merely because tickets have been published, approved, or because only some contributors are done. Publication grants no permission to implement; implementation still proceeds one approved ticket at a time. The local ticket form is:

```markdown
# <Title>

Status: open
Blocked by: <ticket IDs, or None>
Covers OpenSpec tasks: <checkbox labels, e.g. 3.1, 3.2>
Behavior source: <relative path(s) to affected specs, or None for non-behavioral work>
Design source: ../design.md
Task source: ../tasks.md

## Deliverable
<One end-to-end outcome; do not duplicate the normative spec.>

## Acceptance
- [ ] <Observable verification of this ticket's outcome>
```

After publishing the batch, read `openspec status --change "<name>" --json`, `openspec instructions apply --change "<name>" --json`, and run `openspec validate "<name>" --strict` (using the selected `--store` if applicable). Confirm the `tickets/` directory has not altered artifact detection, task counts, descriptions or completion state; if it has, report the incompatibility and stop rather than changing the schema or location silently. Publication never grants permission to start implementation.
