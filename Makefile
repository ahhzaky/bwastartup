# Makefile for BWAStartup Project

DB_USER ?= postgres
DB_NAME ?= bwastartup
DB_HOST ?= localhost
DB_PORT ?= 5432
# For DB_PASSWORD, it's recommended to use a .pgpass file so psql doesn't prompt for a password interactively.
# Alternatively, psql will prompt for it when the command is run if needed.

# Default target (optional, can be 'all' or 'help')
.PHONY: all
all: help

# Target to run the backend server
.PHONY: run-backend
run-backend:
	@echo ""
	@echo "====================================================================="
	@echo "IMPORTANT NOTICE BEFORE RUNNING THE BACKEND:"
	@echo "1. Ensure the PostgreSQL database service IS INSTALLED and CURRENTLY RUNNING."
	@echo "2. Ensure you have created a database with the appropriate name (default: bwastartup)."
	@echo "3. Ensure the .env file in the 'backend' directory is configured"
	@echo "   with the correct database connection details (DB_USER, DB_PASSWORD, DB_HOST, DB_PORT, DB_NAME)."
	@echo "Failure to meet these requirements will cause the backend to FAIL to run."
	@echo "====================================================================="
	@echo "Running Go backend server..."
	@cd backend && go run main.go

# Target to run the frontend development server
.PHONY: run-frontend
run-frontend:
	@echo "Running Nuxt frontend development server..."
	@echo "Make sure you have run 'npm install' in the 'frontend' directory beforehand."
	@cd frontend && npm run dev

# Target to display instructions for running the full development environment
.PHONY: dev
dev:
	@echo "To run the full development environment:"
	@echo "1. Ensure PostgreSQL is running and the database has been created."
	@echo "2. If this is the first time or there are schema changes, run: make migrate-db"
	@echo "3. Open a new terminal, navigate to the project root directory, and run: make run-backend"
	@echo "4. Open another terminal, navigate to the project root directory, and run: make run-frontend"

# Target to perform database migration
# This command assumes 'psql' is installed and in your system's PATH.
# A .pgpass file is recommended for automatic password handling.
.PHONY: migrate-db
migrate-db:
	@echo ""
	@echo "====================================================================="
	@echo "IMPORTANT NOTICE BEFORE PERFORMING DATABASE MIGRATION:"
	@echo "1. Ensure the PostgreSQL database service IS INSTALLED and CURRENTLY RUNNING."
	@echo "2. Ensure 'psql' (PostgreSQL command-line tool) IS INSTALLED and"
	@echo "   accessible from your terminal (in your system's PATH)."
	@echo "3. This command will attempt to apply the schema from 'backend/database/postgress.sql'."
	@echo "4. You may be prompted for the database password if it's not configured"
	@echo "   via a .pgpass file or the PGPASSWORD environment variable (not recommended)."
	@echo "   Using DB_USER: $(DB_USER), DB_NAME: $(DB_NAME), DB_HOST: $(DB_HOST), DB_PORT: $(DB_PORT)"
	@echo "====================================================================="
	@echo "Applying database migration..."
	@psql -h $(DB_HOST) -p $(DB_PORT) -U $(DB_USER) -d $(DB_NAME) -f backend/database/postgress.sql
	@echo "Database migration process completed."

# Help target to display available commands
.PHONY: help
help:
	@echo "Available commands in Makefile:"
	@echo "  make run-backend          - Runs the Go backend server (requires PostgreSQL)."
	@echo "  make run-frontend         - Runs the Nuxt frontend development server."
	@echo "  make dev                  - Displays instructions for running backend and frontend."
	@echo "  make migrate-db           - Applies database schema migration using psql."
	@echo "                            (requires PostgreSQL and psql installed)."
	@echo "  make help                 - Displays this help message."
	@echo ""
	@echo "Configuration for 'migrate-db':"
	@echo "  You can override default database connection parameters when running the command, e.g.:"
	@echo "  make migrate-db DB_USER=my_user DB_NAME=my_db DB_HOST=other_host"
	@echo "  Alternatively, set them as environment variables before running 'make'."

