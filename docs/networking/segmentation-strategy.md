# Network Segmentation Strategy

## The problem I'm solving

In a typical home network, a compromised laptop, phone, media device, or IoT endpoint may sit surprisingly close to infrastructure management.

I wanted the lab to make those trust relationships explicit.

## Segmentation model

The architecture separates functional domains such as:

- privileged access;
- management networks;
- core infrastructure services;
- backup;
- monitoring;
- automation;
- storage/data services;
- compute/workloads;
- trusted clients;
- consumer/home clients;
- constrained devices;
- DMZ;
- guest;
- experimental LAB.

Exact operational VLAN identifiers and addressing are intentionally omitted.

## Default policy

```text
ANY ZONE
   │
   ├── explicitly approved flow ──► ALLOW
   │
   └── everything else ───────────► DENY
```

A "higher-trust" network is not automatically allowed to reach everything below it. Every relationship is intentional.

## Service access without management access

For example:

```text
Consumer Client
      │
      ├────► DNS service          ALLOW
      │
      └────► DNS management       DENY
```

I apply the same pattern to storage, hypervisors, security tooling, and other infrastructure.

## What this demonstrates

The project gives me a concrete environment for working with firewall policy, VLAN design, trust boundaries, least privilege, and validation of both allowed and denied traffic.
