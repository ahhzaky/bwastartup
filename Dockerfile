# ==== Backend Build Stage ====
FROM golang:1.21.6-alpine3.19 AS builder-backend
WORKDIR /app

# Copy go.mod and go.sum first to leverage Docker cache
COPY backend/go.mod backend/go.sum ./
RUN go mod download

# Copy the rest of the backend source code
COPY backend/ ./

# Build the Go application
# Statically linked binary suitable for alpine
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o /app/main main.go

# ==== Frontend Build Stage ====
FROM node:18.20.2-alpine AS builder-frontend
WORKDIR /app

# Copy package.json and lock file
COPY frontend/package.json frontend/package-lock.json* ./
# Use npm ci for cleaner installs if package-lock.json is present
RUN npm ci

# Copy the rest of the frontend source code
COPY frontend/ ./

# Argument for the backend API URL, can be passed during docker build
ARG NUXT_PUBLIC_BASE_URL_API
ENV NUXT_PUBLIC_BASE_URL_API=${NUXT_PUBLIC_BASE_URL_API}

# Build the Nuxt 3 application
RUN npm run build

# ==== Final Production Stage ====
FROM node:18.20.2-alpine

WORKDIR /app

# --- Setup Backend ---
# Copy the compiled Go binary from the backend builder stage
COPY --from=builder-backend /app/main /app/backend_run/backend_app

# Copy backend assets and templates
# The Go app serves these relative to its execution path
COPY backend/web/templates /app/backend_run/web/templates/
COPY backend/web/assets /app/backend_run/web/assets/

# Copy the images directory (for uploads)
# For production, this should ideally be a mounted volume
COPY backend/images /app/backend_run/images/

# Copy an example .env file for the backend.
# The actual .env file with secrets should be mounted or variables provided at runtime.
COPY backend/.env.example /app/backend_run/.env

# --- Setup Frontend ---
# Copy the built Nuxt 3 application from the frontend builder stage
COPY --from=builder-frontend /app/.output /app/frontend_run/.output

# Set environment variables for Nuxt 3 server (Nitro)
# These ensure Nuxt listens on all interfaces inside the container
ENV HOST=0.0.0.0
ENV PORT=3000
# NUXT_PUBLIC_BASE_URL_API needs to be set at runtime for the Nuxt server
# It will be passed when running the container, e.g., docker run -e NUXT_PUBLIC_BASE_URL_API=...
ENV NUXT_PUBLIC_BASE_URL_API=""


# Expose ports
# Backend Go API
EXPOSE 8080 
# Frontend Nuxt 3 Server
EXPOSE 3000 

# Copy the startup script
COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh

# Command to run the startup script
CMD ["/app/start.sh"]
