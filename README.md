# Secure Homelab Security Architecture

I built this project to go beyond simply running services in a homelab. My goal is to design and document an environment the way I would want to approach production infrastructure: with clear trust boundaries, deliberate recovery paths, repeatable configuration, and security controls that can actually be tested.

This repository is the **public, sanitized portfolio version** of that work. Operational details such as real addressing, hostnames, recovery procedures, inventories, and credentials are intentionally omitted.

## What I'm building

The homelab is designed around a simple question:

> If one system is compromised, what independent control still limits the attacker?

That question shapes the network, privileged-access path, PKI, backup design, logging strategy, configuration management, and future automation.

A typical privileged workflow looks like this:

```text
Administrative Workstation
        ↓
Encrypted Overlay
        ↓
Privileged Bastion
        ↓
Firewall-Controlled Management Path
        ↓
Approved Infrastructure Target
```

The administrative workstation is not given direct management-network access, and the bastion is not treated as universally trusted just because it is a security component.

## What this project demonstrates

This project gives me a place to practice and document skills across several areas:

- network segmentation and default-deny firewall design;
- Linux hardening and bastion architecture;
- privileged-access design and short-lived credentials;
- PKI and identity architecture;
- backup, restore, and break-glass planning;
- observability and audit design;
- Ansible and configuration-as-code;
- change control and validation;
- threat modeling and blast-radius analysis;
- bounded CI/CD and agentic automation.

The focus is not on collecting products. It is on understanding **why a control exists, what it depends on, what happens when it fails, and how to prove it is working**.

## Security model

The architecture intentionally separates several kinds of authority:

```text
Identity
   ↓
Authentication
   ↓
Network Authorization
   ↓
Host Authorization
   ↓
Application / Privilege Authorization
```

Passing one layer does not automatically grant the next.

That leads to recurring design rules such as:

- service access does not imply management access;
- overlay membership does not imply administrator authority;
- backup authority does not imply infrastructure administration;
- monitoring authority does not imply management authority;
- Git changes do not automatically imply deployment authority;
- recovery must remain available even when normal online administration is unavailable.

## How I validate the design

One of the main goals of the project is to avoid treating configuration as proof.

The validation model is:

**Threat → Security Invariant → Control → Test → Evidence → Finding → Recovery**

That means I test both sides of a security rule.

For example:

- an approved bastion-to-management path should work;
- a direct workstation-to-management path should fail.

A default-deny network is not useful if the intended workflow is broken, and a working workflow is not secure if unintended paths remain open.

See [`docs/validation/validation-framework.md`](docs/validation/validation-framework.md).

## Architecture areas

| Area | What I'm exploring |
|---|---|
| Network segmentation | Explicit trust zones and default-deny inter-zone policy |
| Privileged access | Mediated administration through constrained bastions |
| Identity & PKI | Role-scoped, short-lived credentials and offline trust |
| Recovery | Independent local recovery when normal control planes fail |
| Backup | Protected recovery tiers and tested restoration |
| Observability | Useful evidence without giving monitoring systems broad authority |
| Configuration management | Reproducible desired state with controlled deployment |
| Agentic DevOps | AI-assisted change proposals with independent approval and execution |

## Technologies explored or incorporated in the architecture

The project uses or evaluates technologies including:

- Linux
- pfSense
- managed switching
- Proxmox
- OpenMediaVault
- Ansible
- Headscale / Tailscale concepts
- Step CA
- Authentik
- OpenBao
- Prometheus / Grafana
- Security Onion
- Kubernetes

I intentionally avoid publishing exact operational versions when they add little portfolio value and unnecessary targeting detail.

## Implementation approach

Implementation proceeds in dependency order. I start with foundational network and privileged-access controls before adding higher-level identity, PKI, observability, automation, and agentic tooling.

Public documents distinguish between:

- **designed**
- **implemented**
- **tested**
- **KNOWN-GOOD**

I do not claim a control has passed validation unless supporting evidence exists in the private operational project.

## Start here

If you want the fastest overview of how I think about infrastructure security, I recommend:

1. [`Architecture Overview`](docs/architecture/overview.md)
2. [`Consolidated Threat Model`](docs/architecture/threat-model.md)
3. [`Privileged Access Architecture`](docs/networking/privileged-access.md)
4. [`Security Validation Framework`](docs/validation/validation-framework.md)
5. [`Implementation Roadmap`](docs/project/implementation-roadmap.md)

## Repository structure

```text
docs/
├── architecture/
├── networking/
├── identity/
├── resilience/
├── observability/
├── automation/
├── validation/
└── project/

examples/
├── ansible/
├── firewall-policy/
└── validation/
```

## About the public version

The operational project is maintained separately in a private authoritative repository.

This repository is intentionally a **sanitized engineering portfolio**, not a copy of the live environment. It keeps the reasoning, design decisions, tradeoffs, and validation approach while leaving out the details that would turn documentation into reconnaissance material.
