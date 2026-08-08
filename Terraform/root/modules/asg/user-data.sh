#!/bin/bash
set -e

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
mkdir -p $APP_DIR
cd $APP_DIR


# Log in to ECR using the instance role (no keys)
aws ecr get-login-password --region $REGION \
  | docker login --username AWS --password-stdin $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com

# Pull and start
docker compose pull
docker compose up -d