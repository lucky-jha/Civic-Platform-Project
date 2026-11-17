# Civic Issue Reporting & Tracking Platform

A cloud-native platform where citizens report civic issues — potholes, garbage
overflow, broken streetlights, water leaks — and track their resolution.
Municipal administrators review, assign, and resolve complaints through an
admin dashboard.

The project's primary focus is **DevOps engineering**: Kubernetes, CI/CD,
infrastructure-as-code, observability, and production-grade operations.

---

## Why this project

| Goal | How it's demonstrated |
|---|---|
| Real-world problem | Citizens struggle to track civic complaints |
| Backend development | FastAPI REST APIs, JWT auth, PostgreSQL |
| Kubernetes | Helm chart, HPA, probes, rolling updates |
| CI/CD | GitHub Actions: test → build → scan → deploy |
| IaC | Terraform: VPC, EKS, RDS, IAM |
| Observability | Prometheus, Grafana, Loki, Alertmanager |
| Reliability | Load tests, failure injection, documented recovery |

---

## Architecture
Citizen ──┐
├──► Ingress ──► FastAPI API ──► PostgreSQL
Admin ───┘ │
└──► Worker (notifications)

Observability: Prometheus ──► Grafana
Loki ──► Logs
Alertmanager ──► Alerts


Full details: [docs/architecture.md](docs/architecture.md) · API contract: [docs/api.md](docs/api.md)

---

## Stack

| Layer | Technology |
|---|---|
| Backend | Python 3.12 · FastAPI · SQLAlchemy 2.0 · Alembic |
| Auth | JWT (python-jose) · passlib[bcrypt] |
| Database | PostgreSQL 16 |
| Frontend | Plain HTML + fetch |
| Containers | Docker |
| Orchestration | Kubernetes (Kind → EKS) |
| Packaging | Helm |
| CI/CD | GitHub Actions |
| IaC | Terraform |
| Observability | Prometheus · Grafana · Loki · Alertmanager |
| Cloud | AWS |

---

## Project status

| Phase | Name | Status |
|---|---|---|
| 1 | Foundation | 🚧 In progress |
| 2 | Core Domain | ⬜ Not started |
| 3 | Containerize | ⬜ Not started |
| 4 | Kubernetes Local | ⬜ Not started |
| 5 | Observability | ⬜ Not started |
| 6 | CI/CD & Safety | ⬜ Not started |
| 7 | Cloud (AWS/EKS) | ⬜ Not started |
| 8 | Prove It | ⬜ Not started |

---

## Quickstart (local dev)

Prerequisites: Python 3.12+, [`uv`](https://docs.astral.sh/uv/), Docker.

```bash
# 1. Start PostgreSQL
./scripts/dev-up.sh

# 2. Install dependencies and run the API
cd app
uv sync
cp .env.example .env
uv run uvicorn app.main:app --reload