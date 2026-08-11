# Example Security Tests

These are sanitized examples of how I translate architecture claims into testable security properties. They do **not** claim that the corresponding private implementation has already passed unless explicitly stated elsewhere.

## NET-VAL-002 — Privileged Workstation Direct Management Denial

**Expected:** DENY

**Why it matters:** The administrative workstation should not be able to bypass the bastion architecture.

**Security property demonstrated:** Management access requires bastion mediation.

---

## NET-VAL-004 — Consumer Network Management Denial

**Expected:** DENY

**Why it matters:** Compromise of a normal household endpoint should not become infrastructure administration.

**Security property demonstrated:** Consumer endpoints cannot directly access infrastructure management planes.

---

## NET-VAL-008 — Bastion Authorized Management Path

**Expected:** ALLOW

**Why it matters:** A secure design still has to support the intended administrative workflow.

**Security property demonstrated:** The approved mediated management path remains functional.

---

## NET-VAL-010 — General Bastion Tier-0 Denial

**Expected:** DENY

**Why it matters:** Compromise of the ordinary infrastructure bastion should not automatically expose the highest-trust identity domain.

**Security property demonstrated:** Bastion scope is intentionally bounded.

---

## PKI Example — Unauthorized Principal Request

**Expected:** DENY

**Security property demonstrated:** Successful identity authentication does not permit arbitrary administrative-role assertion.

---

## Backup Example — Backup Producer Destructive Authority

**Expected:** DENY

**Security property demonstrated:** A workload that can create backups cannot erase every protected recovery copy.

---

## CI Example — Validation Runner Production Execution

**Expected:** DENY

**Security property demonstrated:** CI validation authority is independent from production execution authority.

---

## Recovery Example — Normal Admin Path Unavailable

**Expected:** RECOVERY SUCCEEDS THROUGH INDEPENDENT PATH

**Security property demonstrated:** Loss of normal online administration does not remove local recovery capability.
