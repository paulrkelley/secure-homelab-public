# Identity and Privileged Access Model

## Design goal

I want a valid identity to mean **"this actor proved who they are"**, not **"this actor may administer anything."**

That is why privileged access is layered.

A human administrator may need:

1. device or overlay authorization;
2. bastion authentication;
3. firewall-approved destination scope;
4. target authentication;
5. local sudo or application authorization.

## Role-scoped administration

Rather than one universal root identity, the design uses purpose-oriented administrative roles.

Examples include roles for virtualization, storage, security, Tier-0 functions, and automation.

## Human and machine identities are different

An automation credential should not double as a human administrator credential.

Similarly, a human account should not become the long-lived identity for unattended automation.

## Credential context matters

A credential can be cryptographically valid and still be invalid for a particular target.

Its real authority depends on:

- identity;
- role/principal;
- issuer/profile;
- target;
- trust context;
- network path;
- local authorization.

## Recovery is intentionally separate

Emergency access uses a separate recovery model rather than weakening the normal identity controls.

## What this demonstrates

This design lets me work through practical IAM concepts such as role separation, machine identity, least privilege, short-lived credentials, and target-side authorization.
