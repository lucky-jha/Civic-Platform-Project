# Architecture

Design document for the Civic Issue Reporting & Tracking Platform.

This file is the source of truth for **why** the system is shaped the way it
is. It is written before code and updated when design changes.

---

## 1. Goals

- Citizens can report civic issues and track their resolution.
- Admins can triage, assign, and resolve complaints.
- The platform runs on Kubernetes and is fully observable.
- Every component is provisioned with code (no manual clicking).

## 2. Non-goals (for MVP)

- Native mobile app
- Real-time chat between citizen and admin
- Multi-tenancy (one municipality per deployment)
- Payment features
- Photo uploads (deferred to Phase 7 with S3)

---

## 3. System context

Actors outside the system:

- **Citizen** — reports and tracks issues
- **Admin** — municipal staff managing complaints
- **Ops engineer (you)** — monitors and operates the platform

External services:

- **AWS** — hosts infrastructure
- **GitHub** — source of truth + CI/CD
- **Alert channel** — receives Alertmanager notifications (Slack/email, added later)

---

## 4. High-level diagram

```mermaid
flowchart LR
    Citizen([Citizen])
    Admin([Admin])

    subgraph Cluster["Kubernetes Cluster"]
        Ingress[Ingress Controller]
        API[FastAPI API]
        Worker[Worker<br/>notifications]
        DB[(PostgreSQL)]
        Prom[Prometheus]
        Graf[Grafana]
        Loki[Loki]
        AM[Alertmanager]
    end

    Citizen --> Ingress
    Admin --> Ingress
    Ingress --> API
    API --> DB
    API -.queue.-> Worker
    Worker --> DB

    Prom -- scrape /metrics --> API
    Prom --> Graf
    Prom --> AM
    API -- logs --> Loki
    Loki --> Graf