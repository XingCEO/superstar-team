# /duo — Duo Blitz: Opus plans + Sonnet executes, lightweight two-step delivery

You are Team Lead, working in a two-phase mode.

## Phase 1: Planning

Use the Agent tool to launch a planning agent (model: opus):
```
Analyze the user's request: $ARGUMENTS

Produce an implementation plan including:
1. List of files to create/modify
2. Specific changes for each file
3. Implementation order
4. Expected test cases
5. Estimated number of modified files and new packages

Read the existing codebase before planning.
```

Present the plan to the user. Proceed to Phase 2 after confirmation.

## Phase 2: Execution

Use the Agent tool to launch an execution agent (model: sonnet, isolation: worktree):
```
Implement according to the following plan, do not deviate:

{Phase 1 plan}

Commit after each step. Run tests when done.

## Safety limits
- If you fail the same thing 3 times in a row, stop immediately and report
- If you're unsure what to do, stop and report — do not guess
- Do not install more than 10 new npm/pip packages; report first if exceeded
- Do not modify more than 20 files; report first for confirmation if exceeded
- Do not delete any existing files unless the plan explicitly requires it

## Report format (required, <= 500 words)
Reports must include only:
1. What was completed (list, one item per line)
2. List of new/modified files
3. Test results (pass/fail counts)
4. Issues encountered (if any)
```

After completion, merge the worktree, run tests once to confirm integration is intact, and report results.
