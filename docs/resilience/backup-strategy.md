# Backup and Recovery Strategy

## The problem I'm trying to avoid

A backup system is not very useful if the same compromised production identity can erase both production and every recovery copy.

That leads to a simple invariant:

> **Backup authority does not imply management authority.**

## Recovery tiers

```text
Production
    ↓
Primary Operational Backup
    ↑
Protected Secondary Pull Replica

Critical Data
    ↓
Offline / Detached Recovery Copy
```

## Controls I care about

- scoped backup identities;
- namespace separation;
- restricted delete/prune authority;
- secondary replication that does not expose destructive secondary credentials to the primary;
- integrity verification;
- real restore tests;
- isolated restoration of suspicious data;
- independent recovery of encryption keys when encryption is used.

## A backup is not automatically known-good

The newest recovery point can still contain bad configuration, corrupted data, or attacker persistence.

Known-good state is tied to validated environment/configuration state rather than simply chronology.

## Compromise-aware restore process

```text
Contain
   ↓
Isolated Restore
   ↓
Inspect / Patch
   ↓
Rotate Credentials
   ↓
Validate
   ↓
Return to Service
```

## What this demonstrates

This design focuses on restore testing, ransomware resilience, identity separation, recovery tiers, and the difference between data availability and trustworthy recovery.
