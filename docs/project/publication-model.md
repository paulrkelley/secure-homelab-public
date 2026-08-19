# Public Documentation Model

## Why there are two repositories

Good operational documentation and good portfolio documentation have different jobs.

My private repository is written for:

> **Future me during an outage.**

It is exact, operational, and intentionally detailed.

This repository is written for:

> **An infrastructure or security engineer evaluating how I approach problems.**

It focuses on reasoning, tradeoffs, architecture, validation, and generalized implementation patterns.

## What stays private

The public version intentionally leaves out operational details such as:

- real addressing;
- real inventories;
- management endpoints;
- physical recovery activation;
- private evidence;
- secret locations.

## What I preserve publicly

I still want the public version to have technical depth.

It keeps:

- architectural reasoning;
- threat analysis;
- engineering tradeoffs;
- generalized implementation patterns;
- validation methodology;
- lessons learned.

The goal is **high technical depth with low operational specificity**, not vague marketing language.

## Publication state

Material derived from the operational project is treated as `PUBLIC-SANITIZED` and receives human review before publication.

That publication boundary is itself part of the security design.
