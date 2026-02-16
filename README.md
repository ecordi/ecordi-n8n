# n8n Deployment on Railway

This repository contains the necessary configuration files to deploy n8n (workflow automation tool) on Railway.

## 🚀 Quick Deploy to Railway

### Option 1: One-Click Deploy

1. Fork this repository
2. Go to [Railway](https://railway.app/)
3. Click "New Project" → "Deploy from GitHub repo"
4. Select this repository
5. Railway will automatically detect the configuration

### Option 2: Railway CLI

```bash
# Install Railway CLI
npm i -g @railway/cli

# Login to Railway
railway login

# Initialize project
railway init

# Add PostgreSQL database
railway add --database postgres

# Deploy
railway up
```

## 📋 Configuration Steps

### 1. Add PostgreSQL Database

In your Railway project:
- Click "New" → "Database" → "Add PostgreSQL"
- Railway will automatically create and link the database

### 2. Configure Environment Variables

Go to your n8n service settings and add these variables:

**Required:**
```
N8N_PORT=5678
N8N_PROTOCOL=https
N8N_HOST=${{RAILWAY_PUBLIC_DOMAIN}}
WEBHOOK_URL=https://${{RAILWAY_PUBLIC_DOMAIN}}/

DB_TYPE=postgresdb
DB_POSTGRESDB_HOST=${{PGHOST}}
DB_POSTGRESDB_PORT=${{PGPORT}}
DB_POSTGRESDB_DATABASE=${{PGDATABASE}}
DB_POSTGRESDB_USER=${{PGUSER}}
DB_POSTGRESDB_PASSWORD=${{PGPASSWORD}}
DB_POSTGRESDB_SCHEMA=public

GENERIC_TIMEZONE=America/Argentina/Buenos_Aires
TZ=America/Argentina/Buenos_Aires
```

**Security (IMPORTANT - Change these!):**
```
N8N_BASIC_AUTH_ACTIVE=true
N8N_BASIC_AUTH_USER=your_username
N8N_BASIC_AUTH_PASSWORD=your_secure_password
```

**Optional but Recommended:**
```
N8N_ENCRYPTION_KEY=your_random_32_char_string
N8N_EDITOR_BASE_URL=https://${{RAILWAY_PUBLIC_DOMAIN}}/
N8N_LOG_LEVEL=info
EXECUTIONS_MODE=regular
EXECUTIONS_PROCESS=main
```

### 3. Generate Encryption Key

Generate a secure encryption key:
```bash
node -e "console.log(require('crypto').randomBytes(32).toString('hex'))"
```

### 4. Enable Public Domain

- Go to your n8n service settings
- Click "Settings" → "Networking"
- Click "Generate Domain" to get a public URL

## 🧪 Local Development

### Using Docker Compose

```bash
# Start n8n with PostgreSQL
docker-compose up -d

# View logs
docker-compose logs -f n8n

# Stop services
docker-compose down

# Stop and remove volumes (WARNING: deletes data)
docker-compose down -v
```

Access n8n at: http://localhost:5678

**Default credentials:**
- Username: `admin`
- Password: `changeme123`

⚠️ **Change these credentials immediately!**

### Using Docker directly

```bash
# Create volume
docker volume create n8n_data

# Run n8n
docker run -it --rm \
  --name n8n \
  -p 5678:5678 \
  -v n8n_data:/home/node/.n8n \
  docker.n8n.io/n8nio/n8n
```

## 📁 Project Structure

```
ecordi-n8n/
├── Dockerfile.n8n          # n8n Docker configuration for Railway
├── railway.json            # Railway deployment configuration
├── docker-compose.yml      # Local development setup
├── .env.example           # Environment variables template
└── README.md              # This file
```

## 🔧 Environment Variables Reference

| Variable | Description | Required |
|----------|-------------|----------|
| `N8N_PORT` | Port n8n runs on | Yes |
| `N8N_PROTOCOL` | http or https | Yes |
| `N8N_HOST` | Your Railway domain | Yes |
| `WEBHOOK_URL` | Webhook base URL | Yes |
| `DB_TYPE` | Database type (postgresdb) | Yes |
| `DB_POSTGRESDB_*` | PostgreSQL connection details | Yes |
| `GENERIC_TIMEZONE` | Timezone for scheduling | No |
| `N8N_BASIC_AUTH_ACTIVE` | Enable basic auth | Recommended |
| `N8N_BASIC_AUTH_USER` | Basic auth username | Recommended |
| `N8N_BASIC_AUTH_PASSWORD` | Basic auth password | Recommended |
| `N8N_ENCRYPTION_KEY` | Credentials encryption key | Recommended |

## 🔐 Security Best Practices

1. **Always enable authentication** in production
2. **Use strong passwords** for basic auth
3. **Generate a unique encryption key** and store it securely
4. **Use PostgreSQL** instead of SQLite for production
5. **Keep n8n updated** to the latest version
6. **Backup your data** regularly (especially `/home/node/.n8n`)

## 📊 Monitoring

Railway provides built-in monitoring:
- Go to your service → "Metrics"
- View CPU, Memory, and Network usage
- Check deployment logs in "Deployments" tab

## 🔄 Updating n8n

Railway automatically redeploys when you push to your repository. To update n8n:

1. Update the image tag in `Dockerfile.n8n` if needed
2. Push changes to GitHub
3. Railway will automatically rebuild and deploy

Or trigger a manual redeploy in Railway dashboard.

## 🐛 Troubleshooting

### n8n won't start
- Check logs in Railway dashboard
- Verify all environment variables are set correctly
- Ensure PostgreSQL database is running and connected

### Webhooks not working
- Verify `WEBHOOK_URL` is set to your Railway domain
- Check that the domain is publicly accessible
- Ensure `N8N_PROTOCOL` is set to `https`

### Database connection errors
- Verify PostgreSQL service is running
- Check database environment variables match Railway's PostgreSQL
- Ensure `DB_POSTGRESDB_SCHEMA` is set to `public`

### Lost credentials after restart
- Ensure `/home/node/.n8n` volume is persisted
- Check that `N8N_ENCRYPTION_KEY` hasn't changed
- Verify database contains your data

## 📚 Resources

- [n8n Documentation](https://docs.n8n.io/)
- [n8n Community Forum](https://community.n8n.io/)
- [Railway Documentation](https://docs.railway.app/)
- [n8n Docker Hub](https://hub.docker.com/r/n8nio/n8n)

## 📝 License

n8n is licensed under the [Sustainable Use License](https://github.com/n8n-io/n8n/blob/master/LICENSE.md) and the [n8n Enterprise License](https://github.com/n8n-io/n8n/blob/master/LICENSE_EE.md).

## 🆘 Support

- n8n Community: https://community.n8n.io/
- Railway Discord: https://discord.gg/railway
- n8n GitHub Issues: https://github.com/n8n-io/n8n/issues
