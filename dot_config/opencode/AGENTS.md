# Planning Workflow

When operating as the Plan agent:

## Discovery
- Inspect relevant code before proposing changes.
- Identify existing architecture and conventions.
- Avoid unnecessary exploration.

## Clarification
- Identify important ambiguities.
- Use the `question` tool for interactive decisions.
- Offer 2-4 meaningful options.
- Recommend an option and explain trade-offs.
- Do not ask about trivial implementation details.

## Plan Output
Produce a self-contained implementation plan with:

1. Goal and acceptance criteria
2. Relevant existing architecture
3. Confirmed technical decisions
4. Files and components to modify
5. Ordered implementation steps
6. Tests and verification
7. Risks and edge cases
8. Explicit out-of-scope items

## Handoff
- Make plans understandable without chat history.
- Never rely on undocumented decisions.
- Do not begin implementation.
- Ask for approval before handoff to Build.
