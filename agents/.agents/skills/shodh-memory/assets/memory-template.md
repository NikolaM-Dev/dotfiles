# Remember Template

Store: what happened, why it matters, and what to do next time.

```text
<Kind>: <specific outcome with versions/names>
Reasoning: <why this choice; alternatives rejected and why>
Next time: <gotcha or reuse note>
```

Tags: `["project:<name>", "<area>", ...]`

Good:

```text
Decision: Use PostgreSQL with pgvector for the RAG app.
Reasoning: Need vector similarity search; team has Postgres
expertise; avoids new infra. Rejected Pinecone on cost.
Next time: Enable pgvector extension first; check version >= 16.
Tags: ["project:rag", "database", "backend"]
```

Bad: `Use postgres`
