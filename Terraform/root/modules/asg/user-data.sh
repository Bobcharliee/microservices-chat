#!/bin/bash
set -euo pipefail

# Install Docker + Compose plugin (Amazon Linux 2023)
dnf install -y docker
systemctl enable --now docker
mkdir -p /usr/local/lib/docker/cli-plugins
curl -SL https://github.com/docker/compose/releases/latest/download/docker-compose-linux-x86_64 \
  -o /usr/local/lib/docker/cli-plugins/docker-compose
chmod +x /usr/local/lib/docker/cli-plugins/docker-compose

REGION=us-east-1
ACCOUNT_ID=505265310396
APP_DIR=/opt/app
S3_COMPOSE_FILE="s3://505265310396-deployment-bucket/docker-compose.deploy.yml"

mkdir -p "$APP_DIR"
cd "$APP_DIR"

aws s3 cp "$S3_COMPOSE_FILE" docker-compose.yml

# Log in to ECR using the instance role (no keys)
aws ecr get-login-password --region "$REGION" \
  | docker login --username AWS --password-stdin "$ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com"

# Pull and start
/usr/local/lib/docker/cli-plugins/docker-compose -f docker-compose.yml pull
/usr/local/lib/docker/cli-plugins/docker-compose -f docker-compose.yml up -d