# Agentic DevOps Security Model

## Why experiment with agentic operations?

AI-assisted infrastructure work is interesting to me because it can improve analysis, troubleshooting, documentation, and eventually change workflows.

The dangerous version is giving an agent broad production credentials simply because it can reason about the environment.

I want to explore the useful version instead.

## Start with proposal authority

The initial agent role is:

**read → analyze → propose**

not:

**observe → become root → change production**

## Intended workflow

```text
Agent
  ↓
Proposal / Branch / PR
  ↓
CI Validation
  ↓
Independent Approval
  ↓
Separate Scoped Execution Identity
  ↓
Infrastructure
```

## Guardrails

An agent must not independently:

- approve its own high-risk privileged change;
- obtain production credentials outside the approved workflow;
- modify the policy that limits its own authority;
- expand its own network reachability;
- grant itself stronger certificate or secret-issuance rights.

## Learning progression

1. read-only analysis;
2. change proposals;
3. safe validation;
4. disposable LAB deployment;
5. carefully bounded future production authority if justified.

## What this demonstrates

This gives me a safe environment for learning agentic DevOps while applying the same least-privilege, separation-of-duties, identity, and validation concepts used elsewhere in the project.
