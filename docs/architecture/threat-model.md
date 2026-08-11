# Consolidated Threat Model

## Why this matters

I did not want the threat model to be a generic list of attacks. I wanted it to explain what the architecture is expected to do **after something important has already gone wrong**.

The recurring question is:

> **If this component is compromised, which independent control still limits the attacker?**

## What I'm protecting

The model groups important assets into several broad classes:

- offline root trust;
- online identity and PKI;
- network control infrastructure;
- privileged-access systems;
- backup and recovery;
- security and observability;
- infrastructure and workloads;
- consumer and constrained endpoints.

## Representative scenarios

| Scenario | Primary containment | Independent containment | Expected boundary |
|---|---|---|---|
| Compromised consumer endpoint | network segmentation | target authentication | consumer-accessible services |
| Compromised IoT endpoint | constrained network | service-side authorization | constrained device domain |
| Compromised Internet-facing workload | DMZ isolation | backend authentication | approved backend relationships |
| Compromised admin endpoint | credential/device revocation | bastion + firewall + target authorization | current authorized admin scope |
| Compromised bastion | firewall scope | target authentication/authorization | approved management domain |
| Compromised overlay coordinator | bastion authentication | firewall + target authorization | overlay control plane |
| Compromised online CA | issuer isolation | network + target authorization + offline root recovery | online issuance authority |
| Compromised backup primary | protected secondary | offline/detached recovery | online backup tier |
| Compromised CI runner | no deployment authority | independent executor/approval | validation environment |
| Compromised monitoring system | read-only telemetry role | network/target authorization | observability platform |
| Malicious automation proposal | proposal-only authority | independent approval/execution | change proposal |
| Control-plane outage | fail-closed behavior | independent recovery | normal access unavailable, recovery preserved |

## Reachability is not the same as authority

For each scenario I try to distinguish:

- **Reachability gained**
- **Authentication authority gained**
- **Local/application privilege gained**
- **Data exposed**

A compromised system might be able to reach an interface without having valid credentials or privileged authorization on the target.

That distinction helps prevent me from overstating either the risk or the protection.

## Where defense in depth stops

The architecture is primarily designed to contain individual or limited-domain compromise.

If an attacker simultaneously controls multiple independent enforcement layers, the intended containment boundary may no longer hold. Documenting that limit is important because defense in depth should not be presented as magic.

## Evidence is not proof of innocence

A system reporting healthy telemetry may still be compromised.

Monitoring provides evidence that can support an investigation; it does not prove the reporting system remains trustworthy.

## Recovery can require rebuilding trust, not just rebuilding the OS

If firmware or a management controller is reasonably suspected of compromise, reinstalling the operating system alone may not be enough to restore confidence.

That is an example of a residual risk I want the documentation to acknowledge rather than hide.
