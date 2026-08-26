# Evidence

`generated/` contains disposable local plan captures and is ignored by Git.

Promote reviewed evidence into a descriptive directory such as:

```text
evidence/
└── selective-user-orders/
    ├── README.md
    ├── baseline-plan.txt
    ├── changed-plan.txt
    └── correctness.txt
```

Every promoted artifact must record the PostgreSQL version, row count, data distribution, query parameters, cache/testing caveats, and exact change being evaluated.
