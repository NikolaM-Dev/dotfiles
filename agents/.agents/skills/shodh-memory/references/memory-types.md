# Memory Types and Retrieval

## Types

| Type | Store when | Example |
| --- | --- | --- |
| `Decision` | User chose X over Y | "Chose PostgreSQL + pgvector for RAG; has Postgres expertise, avoids new infra; rejected Pinecone on cost." |
| `Learning` | New durable knowledge | "API requires OAuth2 with PKCE flow." |
| `Error` | Bug found plus fix | "TypeError in auth.js: missing null check on session; fixed with guard." |
| `Discovery` | Insight or root cause | "Perf issue was N+1 queries in order loader." |
| `Pattern` | Recurring preference | "Prefers functional components over classes." |
| `Context` | Background for later | "Building e-commerce platform for client X." |
| `Task` | Work in progress | "Refactoring payment module; auth done, webhooks next." |
| `Observation` | General note | "Typically works mornings, short replies." |

`Decision` and `Error` decay slowest; `Context` and `Observation`
fastest. Pick the type accurately — it controls retention.

## Tags

Tag consistently: `project-<name>` plus area (`auth`, `api`,
`backend`, `security`). Put tags in `remember(tags: [...])` and reuse
the same spellings so `recall` queries hit them.

## Recall Modes

| Mode | Use when |
| --- | --- |
| `hybrid` | Default; meaning plus learned connections |
| `semantic` | Pure meaning match ("database optimization") |
| `associative` | Follow connections ("what else relates to X") |

## Lineage Relations

`Caused`, `ResolvedBy`, `InformedBy`, `SupersededBy`, `TriggeredBy`,
`BranchedFrom`, `RelatedTo`. Confirm good inferences with
`lineage_confirm`, reject bad ones with `lineage_reject`.
