# Dual DNS/NTP Appliances

## Overview

This project documents the design and staged implementation of two dedicated DNS/NTP appliances built for separate trust domains in a secure homelab.

The goal is not simply to run DNS and NTP. The project treats name resolution and time synchronization as foundational infrastructure that should be deliberately isolated, minimally exposed, reproducible, and independently validated.

The design uses:

- Debian Linux
- Unbound for validating recursive DNS
- Chrony for time synchronization
- nftables for host-level filtering
- separate management and service paths
- split-view DNS for information minimization
- default-deny network policy
- local-console recovery
- planned Ansible-based configuration management

## Engineering Problem

DNS and NTP are widely trusted by other systems. A compromised or overly exposed foundational service can therefore have effects far beyond the appliance itself.

This project addresses several design questions:

1. How can household/consumer infrastructure be isolated from privileged homelab infrastructure?
2. How can clients consume DNS or NTP without receiving administrative access?
3. How can internal DNS reveal only the names appropriate for a client's trust level?
4. How can configuration be validated before a service is exposed to production networks?
5. How can the appliances remain recoverable if DNS, NTP, remote access, or other infrastructure is unavailable?

## Architecture Summary

Two physically separate appliances are used:

| Appliance role | Purpose | Trust boundary |
|---|---|---|
| Secured-homelab DNS/NTP | Foundational DNS/NTP for approved infrastructure, management, security, and lab clients | Higher-trust homelab |
| Consumer DNS/NTP | Foundational DNS/NTP for household/consumer clients | Lower-trust consumer environment |

The appliances do not provide cross-domain failover and do not administer one another.

A client being permitted to use DNS or NTP does **not** grant that client SSH or management access.

```text
Approved clients
      |
      | DNS / NTP only
      v
+-----------------------+
| DNS/NTP service plane |
+-----------------------+
          ^
          |
          | separate authorization boundary
          |
+-----------------------+
| Management plane      |
+-----------------------+
          ^
          |
   Privileged admin path
```

See [architecture.md](architecture.md) for the complete trust model.

## Security Principles

The project follows these invariants:

- **Least privilege:** only required services and flows are enabled.
- **Default deny:** inter-zone access and appliance ingress are denied unless explicitly justified.
- **Service access != management access:** DNS/NTP consumption and administration are separate authorization decisions.
- **Management/service separation:** administrative access uses a dedicated privileged path rather than the same trust relationship used by ordinary clients.
- **Information minimization:** DNS views expose only records appropriate to the querying trust zone.
- **Defense in depth:** network firewall policy and host firewall policy both constrain exposure.
- **Staged activation:** configuration is tested while listeners remain local before network exposure is enabled.
- **Recovery independence:** local-console recovery does not depend on DNS, NTP, remote-access infrastructure, or the companion appliance.
- **Reproducibility:** final configuration is intended to be managed through version-controlled automation.

## DNS Design

Unbound provides validating recursive DNS and internal records.

The public examples use documentation-only namespaces such as:

- `mgmt.internal.example`
- `infra.internal.example`
- `lab.internal.example`

Internal records are grouped into views representing trust levels rather than publishing one universal internal namespace.

Example behavior:

| Query | Privileged view | Infrastructure view | Lab view |
|---|---:|---:|---:|
| `host.mgmt.internal.example` | Resolve | NXDOMAIN | NXDOMAIN |
| `service.infra.internal.example` | Resolve | Resolve | NXDOMAIN |
| `dependency.lab.internal.example` | Not published | Not published | Resolve |
| Public Internet DNS | Resolve | Resolve | Resolve |

DNS visibility is an information-disclosure control. It does not replace firewall authorization.

## NTP Design

Chrony is configured first as an NTP **client** and its upstream synchronization is validated before UDP/123 is exposed to internal clients.

The intended production model is:

```text
Approved internal client
        |
        | UDP/123
        v
 Local Chrony appliance
        |
        | controlled upstream synchronization
        v
  Internet time sources
```

The two appliances synchronize independently. Neither depends on the other for time.

## Staged Implementation Model

This repository distinguishes four states:

- **Planned** — accepted architecture but not yet configured.
- **Staged** — configuration exists but is intentionally not exposed to production clients.
- **Implemented** — configuration is active on the appliance.
- **Validated** — runtime behavior has been tested and produced the expected result.

At the captured milestone:

- the secured-homelab appliance base OS and security baseline were implemented;
- Unbound configuration and DNS view behavior were validated locally;
- Unbound remained bound only to loopback during policy validation;
- Chrony was synchronized successfully as an NTP client;
- no UDP/123 listener was active for client service;
- production network exposure remained intentionally pending.

See [status.md](status.md) for the current public project state.

## Validation Philosophy

A configuration change is not treated as complete merely because a file parses or a service starts.

Validation includes:

- configuration syntax checks;
- service state;
- listener inspection;
- positive DNS resolution tests;
- negative DNS visibility tests;
- DNSSEC behavior;
- Chrony source and synchronization state;
- confirmation that NTP server exposure is absent before authorization;
- later, positive and negative tests from real trust zones;
- reboot and recovery testing.

See [validation.md](validation.md).

## Automation

The `ansible/` directory contains **sanitized starter automation**, not a claim that the production appliance has already been fully automated.

The automation intentionally uses variables and documentation-only examples rather than publishing live addresses, hostnames, firewall rules, or topology.

## Repository Layout

```text
projects/dns-ntp-appliances/
├── README.md
├── architecture.md
├── status.md
├── validation.md
├── ansible/
│   ├── README.md
│   ├── inventory.example.yml
│   ├── site.yml
│   ├── group_vars/
│   │   └── all.example.yml
│   └── roles/
│       └── dns_ntp_appliance/
│           ├── tasks/
│           │   └── main.yml
│           └── templates/
│               ├── unbound-appliance.conf.j2
│               └── chrony-appliance.conf.j2
└── scripts/
    ├── README.md
    └── validate-local.sh
```

## Sanitization Notes

This public project intentionally omits or generalizes:

- real VLAN IDs and CIDRs;
- internal production IP addresses;
- exact management and service hostnames;
- live firewall and router rules;
- interface identifiers and MAC addresses;
- administrator usernames;
- remote-access implementation details;
- exact upstream service selections where they add no portfolio value.

Documentation-only examples use reserved or obviously non-production values.

## What This Project Demonstrates

From an infrastructure-engineering perspective, this project demonstrates:

- trust-boundary design;
- Linux service hardening;
- recursive DNS and DNSSEC;
- DNS visibility controls;
- NTP architecture;
- layered firewall policy;
- staged rollout;
- negative testing;
- recovery planning;
- configuration management design;
- documentation that distinguishes intent from proven runtime state.
