#!/usr/bin/env bash

set -e
set -x

echo "Creating database.yml..."
mkdir -p config
cat <<EOF > config/database.yml
default: &default
  adapter: postgresql
  encoding: unicode
  pool: 5
  username: <%= ENV["DB_USERNAME"] || "eric" %>
  password: <%= ENV["DB_PASSWORD"] || "" %>
  host: <%= ENV["DB_HOST"] || "localhost" %>
  port: <%= ENV["DB_PORT"] || 5432 %>

development:
  <<: *default
  database: backend_development

test:
  <<: *default
  database: backend_test

production:
  <<: *default
  database: backend_production
  url: <%= ENV["DATABASE_URL"] %>
EOF

echo "Running migrations..."
bundle exec rails db:migrate
