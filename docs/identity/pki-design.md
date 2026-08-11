# PKI Design

## Why PKI is part of the project

I wanted privileged access to eventually move away from long-lived reusable administrator keys and toward credentials that are short-lived, attributable, and role-scoped.

## Trust architecture

The design separates offline root trust from online issuance:

```text
Offline Root Trust
        │
        ├────► X.509 Issuing Authority
        │
        └────► Online SSH Signing Authority
```

SSH signing and X.509 issuance are treated as distinct trust functions, even when related tooling manages both.

## Short-lived privileged access

Routine human SSH administration is intended to use short-lived certificates rather than persistent reusable private-key authorization.

## Identity integration

The mature flow is designed around:

```text
Administrator
    ↓
Phishing-Resistant Authentication
    ↓
Identity Provider
    ↓
Scoped Identity Claim
    ↓
Certificate-Issuance Policy
    ↓
Permitted SSH Principal
```

A successful login to the identity provider must not allow arbitrary administrative-role selection.

## Offline trust stays offline

The public repository intentionally explains the trust model while omitting operational key locations, media locations, and activation procedures.

## A useful PKI distinction

The trust anchor is verification information and is meant to be distributed.

The private signing key is the sensitive asset.

## What this demonstrates

This area gives me hands-on exposure to certificate trust, SSH certificates, X.509, offline roots, identity-provider integration, principal mapping, and recovery planning.
