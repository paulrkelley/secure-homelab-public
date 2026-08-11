# DNS Visibility and Security

DNS is often treated as plumbing. In this project I treat it as another place where information exposure can be intentionally limited.

## Design idea

Low-trust networks should receive the names they need, but they do not need a directory of privileged infrastructure.

At the same time:

> **DNS information is not authorization.**

If a client somehow learns a privileged hostname, independent network and target controls must still prevent unauthorized access.

## Design principles

- management namespaces have restricted visibility;
- consumer and guest clients receive only necessary names;
- privileged management resolution follows the privileged path;
- fallback resolvers must not accidentally expose broader internal views;
- clients may be restricted to assigned resolvers where appropriate.

## Example validation idea

One useful negative test is:

**Privileged Workstation Management DNS Leak Prevention**

Expected result:

`No privileged-management query is sent through the ordinary client resolver path.`

The real names, addressing, and packet evidence remain in the private operational project.

## Why I included this

This gives me a way to practice split DNS, privacy-aware namespace design, resolver policy, and the difference between information visibility and network authorization.
