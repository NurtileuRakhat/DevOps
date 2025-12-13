#!/usr/bin/env bash
set -eux
apt-get update
apt-get install -y curl wget git build-essential make jq
GO_VER=1.21.8
wget -q https://go.dev/dl/go${GO_VER}.linux-amd64.tar.gz -O /tmp/go.tgz
rm -rf /usr/local/go
tar -C /usr/local -xzf /tmp/go.tgz
ln -sf /usr/local/go/bin/go /usr/local/bin/go
apt-get install -y postgresql postgresql-contrib
systemctl enable postgresql
systemctl start postgresql
sudo -u postgres psql <<SQL
CREATE USER simpleauth WITH PASSWORD 'simpleauthpass';
CREATE DATABASE simpleauth OWNER simpleauth;
GRANT ALL PRIVILEGES ON DATABASE simpleauth TO simpleauth;
SQL
cd /vagrant
/usr/local/bin/go build -o /usr/local/bin/simple-auth ./cmd/simple-auth
# Systemd unit
cp /vagrant/simple-auth.service /etc/systemd/system/simple-auth.service
systemctl daemon-reload
systemctl enable simple-auth.service
cp /vagrant/.env.example /etc/simple-auth.env
# Migrations
export PGPASSWORD="simpleauthpass"
psql -h localhost -U simpleauth -d simpleauth -f /vagrant/migrations/001_create_tables.sql
psql -h localhost -U simpleauth -d simpleauth -f /vagrant/migrations/002_seed_test_client.sql
systemctl start simple-auth.service
