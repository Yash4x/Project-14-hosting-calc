#!/bin/bash

# Production Deployment Script
set -e

echo "🚀 Starting deployment..."

# Pull latest code
echo "📥 Pulling latest code from GitHub..."
git pull origin main

# Load environment variables
if [ -f .env.production ]; then
    export $(cat .env.production | grep -v '^#' | xargs)
else
    echo "❌ Error: .env.production file not found!"
    exit 1
fi

# Replace domain placeholder in nginx config
echo "🔧 Configuring Nginx for domain: $DOMAIN"
sed -i "s/DOMAIN_PLACEHOLDER/$DOMAIN/g" nginx/conf.d/app.conf

# Stop existing containers
echo "🛑 Stopping existing containers..."
docker-compose -f docker-compose.prod.yml down

# Build and start containers
echo "🏗️  Building and starting containers..."
docker-compose -f docker-compose.prod.yml up -d --build

echo "✅ Deployment complete!"
echo "📊 Check status with: docker-compose -f docker-compose.prod.yml ps"
echo "📝 View logs with: docker-compose -f docker-compose.prod.yml logs -f"
