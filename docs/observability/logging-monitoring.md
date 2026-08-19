# Logging, Monitoring, and Audit Architecture

## What I want observability to answer

If something important happens, I want to be able to reconstruct:

- who acted;
- from which access path;
- against which target;
- what security boundary allowed or denied the action;
- what independent evidence supports the event.

## Monitoring is not administration

A recurring rule in the project is:

> **Visibility does not imply management authority.**

Monitoring and dashboard identities should be read-only and purpose-specific wherever possible.

## Multi-layer evidence

A privileged action may leave evidence at several layers:

- access/bastion;
- firewall;
- target host;
- certificate issuer;
- identity provider;
- centralized audit platform.

That provides useful corroboration if one source is unavailable or untrustworthy.

## Protect the audit trail from the producer

A system generating an important security event should not automatically have permission to delete or rewrite the authoritative copy of that event.

## What if the logging platform is compromised?

Then its records become integrity-uncertain.

Investigation should rely on independent evidence rather than assuming the security tool itself is always trustworthy.

## Telemetry silence is a signal

For critical systems, I want to distinguish:

**nothing happened**

from:

**the system stopped reporting.**

That motivates heartbeat/dead-man monitoring.

## What this demonstrates

This design lets me work with security logging, evidence integrity, metrics, monitoring identities, failure detection, and incident reconstruction.
