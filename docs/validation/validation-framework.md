# Security Acceptance and Validation Framework

## Why validation is central to the project

It is easy to write "default deny" in a design document or run an automation tool that reports success.

Neither proves the security property actually holds.

The validation framework connects:

```text
Threat
   ↓
Security Invariant
   ↓
Implementing Control
   ↓
Test Definition
   ↓
Test Execution
   ↓
Evidence
   ↓
Finding / Recovery
```

## Stable tests, evolving procedures

A stable test ID represents a security property.

The procedure can improve over time using `definition_version`.

Example:

```yaml
test_id: NET-VAL-002
definition_version: "1.0"
title: Privileged Workstation Direct Management Denial
expected: DENY
cadence:
  - POSTDEPLOY
  - PERIODIC
safety_class: SAFE
```

An execution is a specific run:

```yaml
execution_id: VALRUN-EXAMPLE-0001
test_id: NET-VAL-002
definition_version: "1.0"
status: NOT-EXECUTED
```

This public example intentionally does not claim a real production result.

## Test both success and failure

A useful security test suite includes:

- **negative tests:** prohibited paths must fail;
- **positive tests:** intended workflows must succeed.

Otherwise a broken environment could appear secure simply because nothing is reachable.

## Passing results can become stale

A test that passed months ago is still a historical PASS.

That does not mean the current configuration is compliant forever.

Freshness is tracked separately so required tests can become `STALE` when their validation interval expires.

## Safety classes

Tests are classified as:

- SAFE
- DISRUPTIVE
- DESTRUCTIVE

Disruptive or destructive validation belongs in an appropriate maintenance window, simulation, or isolated LAB environment.

## Failure does not always mean rollback

A failed test creates a finding and triggers the predefined response.

Depending on the situation that may mean:

- rollback;
- containment;
- rebuild;
- hold-for-review;
- another documented recovery action.

In a security incident, restoring the old state is not automatically the safest answer.

## Known-good means something specific

A KNOWN-GOOD designation applies to a validated configuration/environment combination at a point in time.

It is not a permanent property of a commit.

## What this demonstrates

This framework is one of the parts of the project I value most because it turns security architecture into repeatable engineering evidence instead of relying on assumptions.
