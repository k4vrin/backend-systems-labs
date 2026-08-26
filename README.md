# Backend Systems Labs

Reproducible backend and database experiments for concurrency, performance, messaging, and JVM interoperability. Each lab begins with a prediction, runs against isolated infrastructure, records evidence, and ends with a narrowly justified change.

This repository intentionally keeps deliberately broken examples separate from production-style portfolio applications.

## First lab: PostgreSQL query optimization

The first lab builds a deterministic, skewed orders workload and teaches query-plan reasoning before adding Spring or JPA.

```bash
cd labs/postgres-query-optimization
./scripts/reset.sh
./scripts/run-query.sh plan sql/exercises/01-recent-orders-for-user.sql
./scripts/run-query.sh analyze sql/exercises/01-recent-orders-for-user.sql
```

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
    └── postgres-query-optimization/       # PostgreSQL 18 plan lab
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

Use [the case-study template](docs/CASE_STUDY_TEMPLATE.md) for GitHub and LinkedIn material. Keep claims bounded to the measured dataset and environment; do not describe a local benchmark as production capacity.

## License

This repository is available under the [MIT License](LICENSE).
