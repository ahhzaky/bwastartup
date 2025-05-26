# 🧰 Fullstack Monorepo: Golang (Gin) + Nuxt.js

This monorepo contains a fullstack web application built with:

- **Backend:** Golang with Gin framework, GORM ORM, PostgreSQL, and integration with a third-party payment API (MODTRAN).
- **Frontend:** Nuxt.js (Vue 3) with Tailwind CSS.
- **Tooling:** Docker, GitHub Actions CI/CD, Dependabot, and `.env`-based configuration.

---

## 📂 Project Structure

```

my-monorepo/
├── backend/ # Golang API using Gin, GORM, PostgreSQL
├── frontend/ # Nuxt.js app with Tailwind CSS
└── .github/ # Shared GitHub Actions workflows and Dependabot config

```

---

## ⚙️ Backend: Golang API

- Built using [Gin](https://github.com/gin-gonic/gin) — fast HTTP web framework
- ORM powered by [GORM](https://gorm.io/)
- Database: PostgreSQL
- Payment Integration: [MODTRAN third-party API]
- Configurable via `.env` file
- Containerized with Docker

### ➤ Run Backend Locally

```bash
cd backend
cp .env.example .env
go run main.go
```

### ➤ Run Backend with Docker

```bash
docker compose up --build
```

---

## 🖼️ Frontend: Nuxt.js

- Framework: [Nuxt 3](https://nuxt.com/)
- UI: [Tailwind CSS](https://tailwindcss.com/)
- SSR-ready, optimized for performance

### ➤ Run Frontend Locally

```bash
cd frontend
cp .env.example .env
npm install
npm run dev
```

---

## 🐳 Docker Support

Both backend and frontend are dockerized. You can run the entire stack using:

```bash
docker-compose up --build
```

(Separate `docker-compose.yml` files may exist in `backend/` and `frontend/` as needed.)

---

## 🔐 Environment Variables

Each service has its own `.env` file. Examples provided:

- `backend/.env.example`
- `frontend/.env.example`

Make sure to set required keys for database, API credentials, etc.

---

## 🔄 CI/CD & Dependabot

- GitHub Actions configured for both backend and frontend (`.github/workflows`)
- Dependabot configured to keep dependencies up-to-date:

  - Go modules (`/backend`)
  - NPM packages (`/frontend`)

---

## 📦 Tech Stack Summary

| Layer    | Technology                                                     |
| -------- | -------------------------------------------------------------- |
| Backend  | Go, Gin, GORM, PostgreSQL                                      |
| API      | [Midtrans](https://docs.midtrans.com/) third-party payment API |
| Frontend | Nuxt.js, Tailwind CSS, Node.js                                 |
| DevOps   | Docker, GitHub Actions, Dependabot                             |

---

## Reference

[BWA Starup](https://buildwithangga.com/kelas/full-stack-golang-vue-nuxtjs-website-crowdfunding?main_leads=searchsuggestion)
[Gin Gonic](https://gin-gonic.com/en/)
[PostgreSQL](https://www.postgresql.org/)
[NuxtJS](https://nuxt.com/)
[Midtrans](https://midtrans.com/id)

## 📝 License

This project is licensed under the MIT License. See [LICENSE](LICENSE) for details.

---
