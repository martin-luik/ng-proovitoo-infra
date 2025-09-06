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

> Note: On the first run, PostgreSQL initialization may take up to a minute. Check container status with `docker-compose ps`.

---

## 1. Project Structure Requirement

This setup expects all related repositories to be cloned into the same parent directory, like this:

```
parent-folder/
├── ng-proovitoo-backend
├── ng-proovitoo-frontend
└── ng-proovitoo-infra   ← (current repo)
```
If you already have **backend** and **frontend** cloned into the same parent folder → continue to [Start Infra](#2-start-infra).

If not, you can fetch all three repositories at once with:

```bash
curl -s https://raw.githubusercontent.com/martin-luik/ng-proovitoo-infra/main/setup.sh | bash
```

This structure ensures that the relative build contexts (`../ng-proovitoo-backend` and `../ng-proovitoo-frontend`) in the Compose configuration work as intended.

If your folder layout differs, adjust the `build.context` paths in `docker-compose.yml` accordingly.

---

## 2. Start Infra

```bash
docker-compose up -d --build
```

---

Once containers are healthy, access:

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
docker-compose down -v
```

This stops all containers and **removes volumes** (database data is cleared).

---

## Useful Commands

```bash
docker-compose ps           # show status/health of containers
docker-compose logs -f      # follow logs of all services
docker-compose down -v      # stop and remove containers + volumes
```
