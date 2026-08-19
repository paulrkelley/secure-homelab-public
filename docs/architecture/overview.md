# Architecture Overview

## Why I designed it this way

A flat homelab is easy to build, but it also makes every compromised device more dangerous. I wanted this environment to force me to think in terms of explicit trust relationships rather than a single "trusted LAN."

The central rule is:

> **Service-plane membership and management-plane membership are separate security decisions.**

A device can legitimately use a service without being allowed to administer the system providing it.

## High-level design

```text
                        Internet
                           │
                           ▼
                    Perimeter Firewall
                           │
          ┌────────────────┼────────────────┐
          │                │                │
          ▼                ▼                ▼
    User / Home        Workloads        Management
                                             ▲
                                             │
                                  Privileged Bastion
                                             ▲
                                             │
                                    Encrypted Overlay
                                             ▲
                                             │
                                  Admin Workstation
```

The broader design also separates infrastructure services, backup, observability, automation, security tooling, experimental workloads, and constrained devices.

## What I want compromise to look like

The architecture assumes that defensive systems can fail too.

For privileged administration:

```text
Administrative Endpoint
        ↓
Overlay Identity
        ↓
Bastion Authentication
        ↓
Firewall Authorization
        ↓
Target Authentication
        ↓
Local / Application Authorization
```

If one layer is compromised, another independently enforced boundary should still limit the blast radius.

## Recovery is a separate design problem

Normal administration may depend on online services. Recovery should not.

The project therefore includes an independent local recovery model intended to remain usable if normal overlay, identity, DNS, time, bastion, or Internet dependencies are unavailable.

Operational activation details are intentionally excluded from this public repository.

## Engineering takeaway

This design gives me a practical environment for working through the same questions that appear in real infrastructure work: trust boundaries, failure domains, privileged access, recovery dependencies, and the difference between a control that exists on paper and one that has been validated.
