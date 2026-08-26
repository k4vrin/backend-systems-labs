# LinkedIn exercise-post template

Use this after completing an exercise. Replace every placeholder and keep the post concise enough that readers can attempt the problem without receiving the answer immediately.

## Post

**Backend Systems Lab #[number]: [problem, not solution]**

I tested this scenario:

> [One-sentence production-style problem]

Before running it, I predicted:

- [Expected access path or system behavior]
- [Expected expensive work]
- [Evidence that would confirm or disprove the hypothesis]

Measured on PostgreSQL [version] with [row count] synthetic rows:

| Measurement | Baseline | After one change |
| --- | ---: | ---: |
| Execution time | [value] | [value] |
| Rows visited/removed | [value] | [value] |
| Buffers or temporary I/O | [value] | [value] |

The important lesson was [causal explanation]. The trade-off is [write, storage, complexity, or correctness cost]. These measurements describe this synthetic environment, not universal production capacity.

Try the exercise before opening its reference solution:

[direct exercise URL]

What would you predict PostgreSQL does first?

## Attachments

Prefer one readable artifact:

- A cropped baseline-versus-changed plan comparison
- A compact measurement table
- A diagram showing rows visited versus rows returned

Do not post credentials, production plans containing sensitive literals, or an unexplained screenshot of a plan tree.
