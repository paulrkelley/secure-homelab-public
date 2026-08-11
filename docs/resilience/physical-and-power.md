# Physical Infrastructure and Power Design

## Why include this in a security project?

Logical segmentation can be undermined by a bad cable move, a single shared power failure, or a recovery path that exists only on paper.

I therefore treat physical infrastructure as part of the architecture rather than a separate housekeeping problem.

## Key principles

- physical connectivity does not grant logical authorization;
- critical recovery remains locally possible;
- redundant systems are evaluated for shared physical dependencies;
- network/control infrastructure receives higher power priority than convenience workloads;
- logical redundancy is not physical redundancy when every material failure domain is shared;
- multiple UPS units on one branch circuit do not create independent utility-power domains;
- network-accessible console infrastructure is privileged management infrastructure;
- consumer automation must not control power to recovery-critical infrastructure.

## Failure-domain thinking

For a redundant service, I want to know whether both instances still share the same:

- power source;
- UPS;
- branch circuit;
- switch;
- storage;
- adapter;
- cooling/location dependency.

That does not mean every service needs expensive full redundancy. It means the limitation is documented rather than assumed away.

## Public boundary

Exact electrical circuits, switch ports, rack placement, protected-media locations, and recovery-port details remain private.

## What this demonstrates

This part of the project connects infrastructure security with availability engineering, power planning, hardware lifecycle management, and practical recovery design.
