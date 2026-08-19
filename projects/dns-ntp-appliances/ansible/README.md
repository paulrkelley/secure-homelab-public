# Ansible Scaffolding

This directory contains a **sanitized starter structure** for converting the validated DNS/NTP appliance state into reproducible configuration management.

It is intentionally not presented as production-complete automation.

## Goals

The eventual automation should:

- install required packages;
- deploy validated Unbound configuration;
- deploy validated Chrony configuration;
- enforce service ownership and permissions;
- validate configuration before restart/reload;
- avoid exposing services before network policy is approved;
- keep management and service authorization separate;
- support deterministic rebuilds.

## Safety Model

The example defaults keep network service exposure conservative.

Production values such as addresses, source CIDRs, internal records, firewall aliases, and upstream selections belong in private inventory or protected variable sources, not in this public repository.

## Example Use

Copy the example variables before adapting them:

```bash
cp group_vars/all.example.yml group_vars/all.yml
```

Then review every variable before running:

```bash
ansible-playbook -i inventory.example.yml site.yml --check --diff
```

A real deployment should use a private inventory and should pass validation in check mode before applying changes.
