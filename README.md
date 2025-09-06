# Events App – Infra Setup

This repository provides a **Docker Compose** setup for running the Events application, including:

- **Backend**
- **Frontend**
- **PostgreSQL**
- **Gateway (Nginx)**

---

## Prerequisites

- **Docker** ≥ 28
- **Docker Compose** plugin enabled
- **Free ports:**
    - `8080` → Gateway (Frontend + API)
    - `5436` → PostgreSQL (host port)

---

## 1. Build backend image
```bash
# Backend
cd ../ng-proovitoo-backend
docker build -t events/backend:1.0.0 .

# Frontend
cd ../ng-proovitoo-frontend
docker build -t events/frontend:1.0.0 .
```

---

## 2. Start Infra
```bash
cd ../ng-proovitoo-infra
docker compose up -d
```

---

After a few seconds, access:

- [Frontend UI](http://localhost:8080)
- [Swagger UI (API docs)](http://localhost:8080/api/index.html)
- [Backend health endpoint](http://localhost:8080/api/actuator/health)

---

## Default Admin User

The backend starts with a default admin user:

- **Email:** `admin@example.com`
- **Password:** `admin123`

> Password hash is preconfigured in the backend `application.yml`.

---

## Development Notes

- **Backend:** Built from [`martin-luik/ng-proovitoo-backend`](https://github.com/martin-luik/ng-proovitoo-backend)
- **Frontend:** Built from [`martin-luik/ng-proovitoo-frontend`](https://github.com/martin-luik/ng-proovitoo-frontend)
- **Backend tests:** Use Testcontainers (requires Docker running locally)
- **Frontend tests:**  
    - Unit tests: `npm run test`  
    - E2E tests: `npm run e2e` or with UI: `npm run e2e:ui`

---

## Gateway

The **Nginx gateway** service handles:

- Serving the frontend build
- Proxying `/api/*` requests to the backend container

> Everything (frontend, backend, API docs) is available at [http://localhost:8080](http://localhost:8080).

---

## Stopping

```bash
docker compose down -v
```

This stops all containers and **removes volumes** (database data is cleared).
