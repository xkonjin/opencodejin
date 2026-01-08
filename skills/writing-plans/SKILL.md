---
name: writing-plans
description: Use when you have a spec or requirements for a multi-step task, before touching code
---

# Writing Plans

## When to Use

Before implementing any multi-step task:
- New feature implementation
- Refactoring existing code
- Migration or upgrade
- Complex bugfix
- System integration

## The Planning Process

### Step 1: Understand the Goal

Answer these questions:
- What does "done" look like?
- What are the acceptance criteria?
- What constraints exist?
- What's out of scope?

### Step 2: Break Down into Steps

Each step should be:
- **Atomic**: Can be completed independently
- **Testable**: Has clear success criteria
- **Ordered**: Dependencies are explicit

### Step 3: Identify Risks

For each step:
- What could go wrong?
- What unknowns exist?
- What dependencies are fragile?

### Step 4: Write the Plan

Use this format:

```markdown
## Goal
[One sentence describing the end state]

## Steps

### 1. [Step Name]
- **What**: [Specific action]
- **Why**: [Reason this step is needed]
- **Done when**: [Success criteria]
- **Risks**: [What could go wrong]

### 2. [Step Name]
...

## Out of Scope
- [Thing we're explicitly NOT doing]

## Open Questions
- [Unknowns that need resolution]
```

## Example Plan

```markdown
## Goal
Add user authentication to the API

## Steps

### 1. Add auth database tables
- **What**: Create users, sessions tables with migrations
- **Why**: Need persistent storage for credentials and sessions
- **Done when**: Migrations run, tables exist with correct schema
- **Risks**: None - additive change

### 2. Create auth service module
- **What**: Build AuthService with login/logout/verify methods
- **Why**: Centralize auth logic, make it testable
- **Done when**: Unit tests pass for all auth flows
- **Risks**: Password hashing library choice

### 3. Add auth middleware
- **What**: Create middleware that validates session tokens
- **Why**: Protect routes without duplicating logic
- **Done when**: Protected routes reject unauthenticated requests
- **Risks**: Performance impact of DB lookup per request

### 4. Update API routes
- **What**: Add login/logout endpoints, protect existing routes
- **Why**: Expose auth functionality to clients
- **Done when**: E2E tests pass for auth flow
- **Risks**: Breaking existing API clients

## Out of Scope
- OAuth/social login (phase 2)
- Password reset flow (phase 2)
- Rate limiting (separate task)

## Open Questions
- Session duration: 24h or 7d?
- Should we use JWT or opaque tokens?
```

## Plan Validation Checklist

Before implementing, verify:

- [ ] Each step has clear success criteria
- [ ] Steps are in correct dependency order
- [ ] Risks are acknowledged with mitigation
- [ ] Out of scope is explicit
- [ ] Open questions are flagged (not assumed)

## Common Mistakes

### Too Vague

```
WRONG: "Set up database"
RIGHT: "Create users table with id, email, password_hash, created_at columns"
```

### Missing Dependencies

```
WRONG: Steps can be done in any order
RIGHT: "Step 3 requires Step 2 because..."
```

### Ignoring Risks

```
WRONG: Assume everything will work
RIGHT: "Risk: This migration locks the table. Mitigation: Run during low traffic."
```

### Scope Creep Prevention

If during implementation you think "I should also...":
1. STOP
2. Add to "Out of Scope" or new task
3. Continue with current plan

## When to Re-Plan

- Major assumption proven wrong
- New critical requirement discovered
- Approach fundamentally blocked

Don't re-plan for minor adjustments. Document and adapt.
