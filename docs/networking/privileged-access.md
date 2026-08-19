# Privileged Access Architecture

## Why use a bastion at all?

I wanted privileged access to be **mediated and observable**, rather than giving the administrative workstation broad direct access to every management interface.

The normal path is:

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

The intentionally unsupported shortcut is:

```text
Administrative Workstation
        ✕
Direct Management Network
```

## The bastion is not a universal trust anchor

The bastion is designed to be:

- single-purpose;
- non-routing;
- non-NAT;
- non-bridging;
- host-firewalled;
- narrowly scoped to approved destinations;
- free of routine reusable administrator private keys;
- unable to use routine SSH agent forwarding.

That means compromising the bastion should not automatically create unrestricted access to every management domain.

## Targets still make their own decisions

The network path only gets the administrator to the target.

The target still enforces its own authentication and authorization, including local privilege or application-level roles.

## Credential evolution

The bootstrap design can use a dedicated temporary administrative credential.

The mature design moves toward short-lived SSH certificates and phishing-resistant human authentication without changing the underlying network boundary.

## What this demonstrates

This part of the project combines network segmentation, SSH hardening, identity design, least privilege, and failure-containment thinking into one practical administrative workflow.
