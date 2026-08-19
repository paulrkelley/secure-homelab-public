# Validation

## Purpose

The project distinguishes **configuration** from **proof**.

A service is not considered validated merely because:

- a package installed;
- a configuration file was written;
- systemd reports `active`;
- a port appears open.

Validation combines syntax checks, runtime inspection, positive testing, negative testing, and recovery-oriented checks.

This file contains sanitized examples. It intentionally excludes production addresses, hostnames, interface names, and raw operational logs.

## 1. Validation Stages

```text
Configuration
    ↓
Syntax / parser check
    ↓
Service state
    ↓
Listener inspection
    ↓
Positive behavior
    ↓
Negative behavior
    ↓
Network exposure
    ↓
Cross-zone validation
    ↓
Reboot / recovery
```

## 2. Unbound Configuration Validation

### Objective

Confirm that the effective Unbound configuration is syntactically valid before exposing DNS.

### Command

```bash
sudo unbound-checkconf
```

### Expected

A successful parser result with no configuration error.

### Captured result

**PASS**

## 3. Unbound Service State

### Objective

Confirm the resolver is actually running after the validated configuration is loaded.

```bash
systemctl is-active unbound
systemctl --no-pager --full status unbound
```

### Expected

`active`

### Captured result

**PASS**

## 4. DNS Listener Validation

### Objective

During policy development, prove DNS is restricted to loopback rather than accidentally exposed to a commissioning or production network.

```bash
sudo ss -lntup | grep ':53'
```

### Expected during staged validation

Listeners only on:

```text
127.0.0.1:53
[::1]:53
```

### Captured result

**PASS**

This negative exposure test was important because the view policy could be validated without making an unfinished resolver reachable from other networks.

## 5. Public Recursive DNS

### Objective

Verify ordinary Internet recursion still works through the configured resolver.

```bash
dig @127.0.0.1 example.com A
```

### Expected

- DNS response succeeds;
- an address is returned;
- DNSSEC validation operates normally for signed data.

### Captured result

**PASS**

## 6. DNSSEC Validation

### Objective

Verify that DNSSEC validation is not merely configured but affects resolver behavior.

Representative tests may include a known-valid signed domain and a deliberately broken DNSSEC test domain.

Example:

```bash
dig @127.0.0.1 example.com A +dnssec
```

Expected behavior:

| Test | Expected |
|---|---|
| Valid signed data | Successful validated response |
| Intentionally broken DNSSEC data | Validation failure / SERVFAIL |

Production validation should use a currently maintained DNSSEC test source rather than hard-coding an external test domain into long-lived automation.

## 7. Split-View DNS Testing

### Objective

Verify that clients at different trust levels receive different internal DNS visibility.

Synthetic records were used so policy could be tested without publishing production infrastructure details.

Example documentation-only records:

```text
host.mgmt.internal.example        192.0.2.10
service.infra.internal.example    192.0.2.20
dependency.lab.internal.example   192.0.2.30
```

`192.0.2.0/24` is reserved for documentation and examples.

### Expected matrix

| Query | Privileged | Infrastructure | Lab |
|---|---:|---:|---:|
| management record | Resolve | NXDOMAIN | NXDOMAIN |
| infrastructure record | Resolve | Resolve | NXDOMAIN |
| lab dependency | Not published | Not published | Resolve |
| public DNS | Resolve | Resolve | Resolve |

### Captured result

**PASS**

The test demonstrated source-dependent DNS information exposure.

## 8. Negative DNS Testing

Negative tests are first-class validation.

Examples include:

- a lower-trust view cannot resolve privileged names;
- an internal name that is not intentionally published does not leak;
- an unapproved source does not gain resolver access after production exposure;
- a service-only client cannot use DNS visibility as a substitute for firewall authorization.

A negative DNS result should be interpreted carefully:

> NXDOMAIN demonstrates name concealment. It does not prove the destination network is unreachable.

Network policy must be validated separately.

## 9. Chrony Configuration Validation

### Objective

Validate the effective Chrony configuration before allowing the appliance to serve NTP clients.

```bash
sudo chronyd -p
```

### Expected

Configuration prints/parses successfully with no fatal error.

### Captured result

**PASS**

## 10. Chrony Service and Synchronization

Useful commands:

```bash
systemctl is-active chrony
chronyc tracking
chronyc sources -v
```

### Expected

- Chrony service active;
- normal leap status;
- a selected source;
- multiple reachable sources where configured;
- system clock converging to network time.

### Captured result

**PASS**

The appliance reached a synchronized client state before NTP server exposure was enabled.

## 11. NTP Listener Negative Test

### Objective

Prove that the appliance is *not yet serving NTP* during the client-validation stage.

```bash
sudo ss -lunp | grep ':123'
```

### Expected during staged validation

No listening UDP/123 socket for internal client service.

### Captured result

**PASS**

This check prevents an incomplete server policy from being accidentally exposed simply because Chrony is installed and running.

## 12. Host Routing Validation

### Objective

Confirm the appliance is not acting as an unintended router.

Representative checks:

```bash
sysctl net.ipv4.ip_forward
sysctl net.ipv6.conf.all.forwarding
```

### Expected

```text
net.ipv4.ip_forward = 0
net.ipv6.conf.all.forwarding = 0
```

The host firewall should also use a default-drop forwarding policy.

## 13. Production DNS Acceptance Tests

These remain pending until production exposure is intentionally enabled.

| Test | Expected |
|---|---|
| Approved client -> TCP/UDP 53 | Allow |
| Unapproved client -> TCP/UDP 53 | Deny |
| Approved privileged source -> privileged record | Resolve |
| Lower-trust source -> privileged record | NXDOMAIN / non-disclosing result |
| Approved lower-trust source -> public recursion | Resolve if policy allows |
| Consumer domain -> secured-homelab resolver | Deny |
| Internet -> resolver | Deny / not exposed |

## 14. Production NTP Acceptance Tests

These remain pending until UDP/123 service authorization is enabled.

| Test | Expected |
|---|---|
| Approved NTP client -> appliance UDP/123 | Allow |
| Unapproved client -> appliance UDP/123 | Deny |
| Consumer client -> secured-homelab NTP appliance | Deny |
| Internet -> appliance UDP/123 | Deny / not exposed |
| Appliance -> approved upstream time sources | Allow |
| Appliance -> companion appliance for time | Deny by design |

## 15. Management-Plane Acceptance Tests

The final production administration path should prove:

| Test | Expected |
|---|---|
| Approved privileged admin path -> appliance SSH | Allow narrowly |
| Ordinary service client -> appliance SSH | Deny |
| Consumer client -> appliance SSH | Deny |
| Direct unapproved management path | Deny |
| Local console with network dependencies unavailable | Still usable |

## 16. Reboot Validation

After production configuration is complete, reboot testing should confirm:

- Secure Boot remains active;
- host firewall rules persist;
- forwarding remains disabled;
- Unbound starts successfully;
- Chrony starts successfully;
- service listeners are limited to intended interfaces;
- unauthorized listeners do not appear;
- synchronization recovers normally;
- no failed systemd units indicate an appliance regression.

## 17. Automation Validation

The public `scripts/validate-local.sh` script automates several non-sensitive local checks.

It is intentionally conservative:

- it does not open ports;
- it does not modify configuration;
- it does not contain production addresses;
- it does not claim to replace cross-zone acceptance testing.

Automation should make validation easier to repeat, not reduce the breadth of testing.
