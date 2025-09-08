# Events App – Infra Setup

This repository provides a **Docker Compose** setup for running the Events application, including:

- **Backend**
- **Frontend**
- **PostgreSQL**
- **Gateway (Nginx)**

---

## 🚀 Deployment Summary

**This project is designed to run on any server with Docker installed.
No manual Tomcat or Nginx setup is required — everything is provided through Docker Compose.**

- **Target OS: Linux server (recommended). Works also on Windows (with WSL2) or macOS with Docker Desktop.**
- **Required software:**
  - **Docker** ≥ 28
  - **Docker Compose** plugin enabled
- **Open ports needed:**
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

## Environment Variables

The infra uses a `.env` file in this directory to configure database, backend, JWT, and auth cookie settings for Docker Compose.
**You can edit this file to change database names, users, or backend connection details.**

Example `.env` file:

```dotenv
# --- PostgreSQL ---
POSTGRES_DB=events_db
POSTGRES_USER=admin
POSTGRES_PASSWORD=admin

# --- Backend database config ---
SPRING_DATASOURCE_URL=jdbc:postgresql://db:5432/events_db?currentSchema=event_mgmt
SPRING_DATASOURCE_USERNAME=events_adm_user
SPRING_DATASOURCE_PASSWORD=events_admin
SPRING_LIQUIBASE_DEFAULT_SCHEMA=event_mgmt
SPRING_LIQUIBASE_LIQUIBASE_SCHEMA=liquibase
SPRING_LIQUIBASE_ENABLED=true

# --- JWT ---
APP_JWT_SECRET=change-me-very-long-random-256-bit
APP_JWT_ISSUER=events-app
APP_JWT_EXPIRY_MINUTES=60

# --- Auth cookie ---
APP_COOKIES_NAME=access_token
APP_COOKIES_HTTP_ONLY=true
APP_COOKIES_SECURE=false      # set true in production/HTTPS
APP_COOKIES_SAME_SITE=Lax     # options: Lax, Strict, None
APP_COOKIES_MAX_AGE_MINUTES=60
```

- **POSTGRES_DB, POSTGRES_USER, POSTGRES_PASSWORD:** Used by the PostgreSQL container.
- **SPRING_DATASOURCE_\*** and **SPRING_LIQUIBASE_\***: Used by the backend service for DB connection and schema management.

> The default `.env` file is provided.  
> If you need to reset or change credentials, update this file before running `docker-compose up -d`.

---

Once containers are healthy, access:

- [Frontend UI](http://localhost:8080)
- [Swagger UI (API docs)](http://localhost:8080/swagger-ui/index.html)
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
- Exposing Swagger UI at `/swagger-ui/` and API docs at `/api/api-docs`

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
