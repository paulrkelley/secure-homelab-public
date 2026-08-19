# Project Status

## Status Convention

This project uses four implementation states.

| State | Meaning |
|---|---|
| **Planned** | Architecture or control has been accepted but not configured. |
| **Staged** | Configuration exists but is intentionally not exposed to production clients. |
| **Implemented** | Configuration is active on the appliance. |
| **Validated** | Runtime behavior has been tested and matched the expected result. |

## Current Public Milestone

**Milestone:** DNS view isolation and NTP client synchronization have been validated on the first secured-homelab appliance while production DNS/NTP exposure remains intentionally deferred.

This is an important distinction: the project has validated core policy behavior, but it does **not** claim full production rollout.

## Secured-Homelab Appliance

| Area | State | Public evidence / note |
|---|---|---|
| Minimal Debian installation | Validated | Headless appliance baseline boots and operates normally |
| Secure Boot | Validated | Boot-chain validation completed |
| Reduced service footprint | Implemented | Unnecessary appliance roles are excluded |
| SSH hardening | Validated | Key-based administration baseline tested |
| Host default-deny firewall | Validated | Inbound/forward policy constrained during commissioning |
| Forwarding disabled | Validated | Appliance is not acting as a router |
| AppArmor | Validated | Mandatory-access-control framework active |
| Unbound installed | Validated | Service active and configuration parses |
| DNSSEC-capable recursive DNS | Validated | Public recursive resolution validated |
| Split-view DNS configuration | Validated | Source-dependent visibility tested locally |
| Privileged-name concealment | Validated | Lower-trust test views received negative responses |
| Production DNS listeners | Staged | Intentionally kept off production interfaces during policy validation |
| Chrony installed | Validated | Effective configuration parses and service runs |
| Upstream NTP synchronization | Validated | Healthy synchronization and source selection observed |
| Internal NTP service | Staged | No UDP/123 client listener exposed at captured milestone |
| Production service addressing | Planned | Public repository intentionally omits live addressing |
| Final service firewall policy | Planned | To be enabled only with matching host/network authorization |
| Real-zone positive/negative DNS tests | Planned | Requires production service exposure |
| Real-zone positive/negative NTP tests | Planned | Requires production UDP/123 exposure |
| Final bastion-only management path | Planned | Separate privileged management path to be validated |
| Full Ansible deployment | Planned | Starter public scaffolding included; production automation not yet claimed |
| Final known-good backup/rebuild test | Planned | Acceptance gate for completed deployment |

## Consumer Appliance

The consumer-side appliance is a separate trust-domain implementation and is intentionally not represented as a failover target for the secured-homelab appliance.

| Area | State |
|---|---|
| Independent trust-domain architecture | Planned / accepted |
| Dedicated hardware appliance | Planned |
| Minimal Debian baseline | Planned |
| Unbound | Planned |
| Chrony | Planned |
| Consumer DNS filtering integration | Planned |
| No administrative access from ordinary consumer clients | Architectural requirement |
| Cross-domain failover to secured-homelab appliance | Prohibited by design |

## Validated DNS Behavior

The local split-view test used synthetic, documentation-only records.

| Record class | Privileged view | Infrastructure view | Lab view |
|---|---:|---:|---:|
| Privileged management record | Resolve | NXDOMAIN | NXDOMAIN |
| Restricted infrastructure record | Resolve | Resolve | NXDOMAIN |
| Lab-only dependency | Not published | Not published | Resolve |
| Public Internet DNS | Resolve | Resolve | Resolve |

This demonstrates that DNS information exposure can be adjusted by source trust level.

It does **not** imply that DNS visibility grants network access to the returned destination.

## Validated NTP Behavior

At the captured milestone:

- Chrony configuration parsed successfully;
- the service restarted successfully;
- multiple upstream sources were reachable;
- the appliance reached a synchronized state;
- the selected upstream source produced a normal downstream stratum;
- UDP/123 was not exposed as an internal NTP server.

That sequence deliberately proves the client side before enabling the server side.

## Remaining Acceptance Gates

Before the first appliance can be described as fully deployed, the following should be completed:

1. finalize production service and management interface placement;
2. replace synthetic test records with the minimum approved real records;
3. expose Unbound only on intended service interfaces;
4. permit TCP/UDP 53 only from approved source zones;
5. enable Chrony server authorization only for approved NTP consumers;
6. permit UDP/123 only from those consumers;
7. confirm consumer networks cannot use the secured-homelab appliance;
8. validate DNS views from real source zones;
9. validate allowed and denied NTP clients;
10. validate the final privileged management path;
11. validate reboot behavior after production exposure;
12. capture a known-good configuration backup;
13. convert the final known-good state into tested automation.

## Public-Repository Boundary

Exact production details are intentionally not included here.

The public project focuses on:

- architecture;
- security reasoning;
- implementation method;
- validation methodology;
- sanitized configuration patterns;
- engineering lessons.

The private operational repository remains authoritative for live addresses, network policy, hostnames, and recovery details.
