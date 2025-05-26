#!/bin/sh

# Exit immediately if a command exits with a non-zero status.
set -e

# Load backend environment variables if .env file exists
# This is a simple way to load them; for production, consider more robust methods.
if [ -f "/app/backend_run/.env" ]; then
  echo "Loading backend environment variables from .env file..."
  set -o allexport # Export all variables defined from now on
  # shellcheck source=/dev/null
  . "/app/backend_run/.env" # Source the .env file
  set +o allexport # Stop exporting all variables
else
  echo "Warning: /app/backend_run/.env file not found. Backend might not work correctly if ENV VARS are not set."
fi

# Start the backend server in the background
echo "Starting backend server on port 8080..."
cd /app/backend_run
./backend_app &
# Store the PID of the backend process
BACKEND_PID=$!
cd /app

# Start the frontend server (Nuxt 3 production server)
# The NUXT_PUBLIC_BASE_URL_API environment variable should be passed to 'docker run'
# HOST and PORT are already set as ENV in Dockerfile for Nuxt
echo "Starting frontend server on port 3000..."
echo "Frontend will use API URL: ${NUXT_PUBLIC_BASE_URL_API}"

# Use exec to replace the shell process with the Node.js process,
# so Node.js becomes PID 1 and handles signals correctly.
exec node /app/frontend_run/.output/server/index.mjs
