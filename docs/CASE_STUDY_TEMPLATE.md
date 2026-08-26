# Case study: concise problem statement

## Interview question

State the question in one or two sentences.

## Invariant or performance target

Define what must remain correct and what measurement is being improved.

## Environment

- Database and exact version:
- Dataset size and distribution:
- Hardware/container limits:
- Warm or cold cache:
- Repetition count:

## Prediction before execution

Describe the expected plan, rows scanned versus returned, join/sort behavior, and likely bottleneck before opening the plan.

## Baseline evidence

Record the command, query, plan, result-correctness check, and measurements. Separate measured facts from interpretation.

## Smallest justified change

Describe one change and the evidence that motivated it. Include alternatives rejected before implementation.

## Verification

Compare under equivalent conditions:

- Result correctness
- Planning and execution time
- Rows, loops, buffers, and temporary I/O
- Estimate accuracy
- Index size and write/storage cost
- Behavior under a changed parameter or data distribution

## Rollback

State how to remove or reverse the change.

## Interview answer

Summarize the diagnosis and trade-off in 60–90 seconds.

## LinkedIn draft

Use a concrete hook, show one before/after artifact, and bound the claim to this synthetic workload. Link to the exact evidence or commit.
