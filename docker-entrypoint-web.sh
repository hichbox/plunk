#!/bin/sh
set -e

echo "🚀 Starting Plunk web image"

# Runtime URLs (used by replace-urls script)
: "${API_URI:=http://api:8080}"
: "${DASHBOARD_URI:=http://localhost:3000}"
: "${LANDING_URI:=}"
: "${WIKI_URI:=}"

# Replace placeholders in prebuilt standalone bundle
. /app/docker/replace-urls-optimized.sh
replace_urls_in_app "web" "/app/apps/web/.next/standalone/apps/web"

cd /app/apps/web/.next/standalone
exec node apps/web/server.js
