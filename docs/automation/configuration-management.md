# Configuration Management and Change Control

## Why configuration-as-code matters here

One of the goals of this project is to make infrastructure rebuildable and reviewable rather than dependent on remembering which command I ran months ago.

The desired flow is:

```text
Policy
   ↓
Desired State in Git
   ↓
Validation
   ↓
Explicit Deployment Authorization
   ↓
Scoped Automation Identity
   ↓
Target
   ↓
Post-Change Validation
```

## Configuration-as-code is not always GitOps

I distinguish between:

- **Configuration-as-code:** Git is the source of desired state, but deployment is intentionally initiated.
- **GitOps reconciliation:** a controller continuously or periodically reconciles runtime state toward Git.

Continuous reconciliation is useful in some domains, but it is not automatically the best choice for every security-sensitive component.

## Separate proposal, approval, and execution

A system that can validate a change should not automatically have the credentials to deploy it.

For higher-risk changes, I want proposal, approval, and execution to remain distinct capabilities.

## Inventory is not authorization

Adding a host to an automation inventory does not itself grant permission to modify it.

Network scope, machine identity, target authorization, and the change workflow must all agree.

## Detect drift

Manual changes should be visible and reconciled rather than silently becoming the new reality.

## What this demonstrates

This part of the project combines Ansible, infrastructure-as-code, change control, deployment governance, idempotency, and security-focused automation design.
