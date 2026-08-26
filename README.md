# Backend Systems Labs

Reproducible backend and database experiments for concurrency, performance, messaging, and JVM interoperability. Each lab begins with a prediction, runs against isolated infrastructure, records evidence, and ends with a narrowly justified change.

This repository intentionally keeps deliberately broken examples separate from production-style portfolio applications.

## Start the public workshop

The first lab is a self-contained PostgreSQL query-optimization workshop. You do not need Java or Spring to complete it.

```bash
git clone https://github.com/k4vrin/backend-systems-labs.git
cd labs/postgres-query-optimization
./scripts/reset.sh
```

Then open [Exercise 01: Selective lookup](labs/postgres-query-optimization/exercises/01-selective-lookup/README.md). Each exercise requires a written prediction before the plan is revealed and keeps its reference solution in a separate directory.

The local default is 1,000,000 orders. For a faster smoke run:

```bash
LAB_ORDER_COUNT=10000 ./scripts/reset.sh
```

Requirements:

- Docker with Docker Compose
- Bash
- Approximately 2–4 GB of free disk space for the full local dataset

## Repository map

```text
backend-systems-labs/
├── docs/                                  # Shared evidence templates
└── labs/
    └── postgres-query-optimization/
        ├── exercises/                     # Attempt these first
        ├── solutions/                     # Open only after an attempt
        └── evidence/                      # Record measured case studies
```

Future labs remain independently runnable. Shared Java build logic will be introduced only when the first JVM-based lab requires it.

## Working agreement

1. Write down the predicted access path and expensive work.
2. Capture the baseline plan and confirm result correctness.
3. Make one query, index, statistics, or application change.
4. Capture the changed plan under the same data and conditions.
5. Record write/storage costs, rejected alternatives, and remaining uncertainty.

`EXPLAIN ANALYZE` executes the statement. The provided analyze command accepts only read-only SQL files, and every lab runs against synthetic local data.

## Public evidence

Use [the case-study template](docs/CASE_STUDY_TEMPLATE.md) for durable evidence and the [LinkedIn exercise-post template](docs/LINKEDIN_EXERCISE_POST_TEMPLATE.md) when sharing an exercise. Keep claims bounded to the measured dataset and environment; do not describe a local benchmark as production capacity.

## Workshop progress

| Lab | Concept | Exercise | Reference solution |
| --- | --- | --- | --- |
| 01 | Selective lookup and composite index ordering | [Available](labs/postgres-query-optimization/exercises/01-selective-lookup/README.md) | Attempt-gated |
| 02 | Sequential scan despite an index | Planned | — |
| 03 | Composite-index column order | Planned | — |
| 04 | Expensive sort | Planned | — |
| 05 | Bad join | Planned | — |

## License

This repository is available under the [MIT License](LICENSE).
