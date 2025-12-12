# 🚀 Production Deployment Guide

## Prerequisites
- Digital Ocean server with Ubuntu
- Domain name pointed to server IP
- Docker and Docker Compose installed on server

## Step-by-Step Deployment

### 1️⃣ On Your Server

**Clone the repository:**
```bash
cd ~
git clone https://github.com/Yash4x/Project-14-hosting-calc.git
cd Project-14-hosting-calc
```

### 2️⃣ Configure Environment Variables

**Edit `.env.production` file:**
```bash
nano .env.production
```

**Update these values:**
```bash
# Generate secure passwords and keys
DB_PASSWORD=$(openssl rand -base64 32)
JWT_SECRET_KEY=$(openssl rand -hex 32)
JWT_REFRESH_SECRET_KEY=$(openssl rand -hex 32)

# Your actual domain and email
DOMAIN=yourdomain.com
EMAIL=your-email@example.com
```

**Save the file** (Ctrl+O, Enter, Ctrl+X)

### 3️⃣ Setup DNS (GoDaddy)

In GoDaddy DNS settings, add:
- **A Record**: `@` → `165.227.70.153`
- **A Record**: `www` → `165.227.70.153`

Wait 5-10 minutes for propagation.

### 4️⃣ Configure Firewall

```bash
sudo ufw allow 22/tcp   # SSH
sudo ufw allow 80/tcp   # HTTP
sudo ufw allow 443/tcp  # HTTPS
sudo ufw enable
```

### 5️⃣ Make Scripts Executable

```bash
chmod +x deploy.sh init-ssl.sh
```

### 6️⃣ Initial Deployment

```bash
# First deployment (without SSL)
sudo docker-compose -f docker-compose.prod.yml up -d
```

Verify it's running: `http://yourdomain.com` (HTTP only at this point)

### 7️⃣ Setup SSL Certificate

```bash
sudo ./init-ssl.sh
```

This will:
- Request SSL certificate from Let's Encrypt
- Configure HTTPS
- Setup auto-renewal

### 8️⃣ Verify Everything Works

Visit: `https://yourdomain.com`

**Check logs:**
```bash
sudo docker-compose -f docker-compose.prod.yml logs -f
```

**Check status:**
```bash
sudo docker-compose -f docker-compose.prod.yml ps
```

## 📝 Future Updates

When you make changes to your code:

```bash
cd ~/Project-14-hosting-calc
sudo ./deploy.sh
```

## 🛠️ Useful Commands

**View logs:**
```bash
sudo docker-compose -f docker-compose.prod.yml logs -f web
```

**Restart services:**
```bash
sudo docker-compose -f docker-compose.prod.yml restart
```

**Stop everything:**
```bash
sudo docker-compose -f docker-compose.prod.yml down
```

**Database backup:**
```bash
sudo docker-compose -f docker-compose.prod.yml exec db pg_dump -U postgres fastapi_db > backup.sql
```

## 🔒 Security Checklist

- ✅ Strong database password
- ✅ Unique JWT secret keys
- ✅ SSL/HTTPS enabled
- ✅ Firewall configured
- ✅ No exposed development ports
- ✅ Regular security updates: `sudo apt update && sudo apt upgrade`

## 🐛 Troubleshooting

**SSL certificate issues:**
```bash
sudo docker-compose -f docker-compose.prod.yml logs certbot
```

**Application not starting:**
```bash
sudo docker-compose -f docker-compose.prod.yml logs web
```

**Database connection issues:**
```bash
sudo docker-compose -f docker-compose.prod.yml logs db
```

## 📊 Monitoring

**Check disk space:**
```bash
df -h
```

**Check memory:**
```bash
free -h
```

**Docker cleanup:**
```bash
sudo docker system prune -a
```
