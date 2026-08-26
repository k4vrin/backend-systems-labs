# Exercise 01 worksheet — Selective lookup

## Environment

- PostgreSQL version:
- Order count:
- Hardware/container limits:
- Cache conditions and repetition count:

## Prediction before execution

- Expected access path:
- Estimated rows inspected versus returned:
- Expected filtering and sorting work:
- Candidate change and why:
- Evidence that would support or falsify the hypothesis:

## Baseline facts

- Plan capture:
- Actual rows and loops:
- Rows removed by filter:
- Sort method and memory/disk use:
- Shared-buffer hits/reads:
- Planning and execution time:

## Interpretation

Separate what the plan reports from what you infer caused the behavior.

## One justified change

- Change:
- Why each column or query rewrite is needed:
- Alternatives rejected:
- Expected storage/write cost:
- Rollback:

## Verification

- Result invariants:
- Changed plan capture:
- Equivalent-condition comparison:
- Changed-parameter result:
- Remaining uncertainty:

## Interview answer

Explain the diagnosis, change, evidence, and trade-off in 60–90 seconds.

## LinkedIn draft

- Concrete problem hook:
- Prediction that was confirmed or disproved:
- One bounded before/after result:
- Trade-off:
- Exercise link and invitation to attempt it first:
