#!/bin/sh
set -e

echo "🚀 Starting Plunk API"

if [ "${RUN_MIGRATIONS:-true}" = "true" ]; then
  echo "🗄️  Running database migrations..."
  if ! /app/node_modules/.bin/prisma migrate deploy --schema=/app/packages/db/prisma/schema.prisma; then
    echo ""
    echo "❌ ERROR: Database migration failed"
    echo "   Please verify DATABASE_URL connectivity/credentials and migration status."
    echo ""
    exit 1
  fi
  echo "✅ Database migrations completed successfully"
else
  echo "ℹ️  Skipping migrations (RUN_MIGRATIONS=${RUN_MIGRATIONS:-true})"
fi

echo "📋 Starting API server and worker"

node /app/apps/api/dist/app.js &
API_PID=$!

node /app/apps/api/dist/jobs/worker.js &
WORKER_PID=$!

trap 'kill -TERM "$API_PID" "$WORKER_PID" 2>/dev/null || true' INT TERM

wait "$API_PID" "$WORKER_PID"
