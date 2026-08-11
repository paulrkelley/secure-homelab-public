# Security Principles

These principles are the design rules I use when making implementation decisions. They are intentionally product-independent so the architecture does not depend on one vendor or tool behaving perfectly.

## Default deny

Inter-zone traffic is denied unless a specific infrastructure or service requirement justifies an explicit ALLOW path.

## Separate service access from management access

A client may need DNS, storage, application, or infrastructure services without needing administrative access to the system providing them.

That distinction is one of the most important controls in the project.

## Treat authentication and authorization separately

Authentication answers **who are you?**

Authorization answers **what are you allowed to do here?**

The design keeps network, host, sudo, and application authorization as separate decisions.

## Constrain bastions

A bastion is useful because it narrows privileged access. It should not become a universal management router.

Its reachable destinations are intentionally limited so compromise of the bastion does not automatically expose unrelated management domains.

## Keep recovery independent

The normal privileged path is designed for security and convenience. Break-glass is designed for failure.

Recovery remains deliberately separate from normal cloud, identity, DNS, time, and bastion dependencies.

## Give automation only the authority it needs

Monitoring, backup, configuration management, CI/CD, and future AI agents receive purpose-specific permissions rather than universal administrator credentials.

## Test important security claims

A control is not considered meaningful simply because the configuration appears correct.

If I say a direct management path is blocked, I want a repeatable test that demonstrates the denial.

## Assume defensive systems can be compromised

The threat model includes compromise of the systems that are supposed to protect the environment:

- administrative endpoints;
- bastions;
- overlay coordination;
- online certificate authorities;
- identity providers;
- firewalls;
- backup systems;
- logging platforms;
- CI/CD;
- automation agents.

The goal is to understand which **independent control still matters when the primary one fails**.
