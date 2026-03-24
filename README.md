<p align="center">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="https://assets.ycodeapp.com/assets/app13650/Icons/9l3kz_ycode-logo-white.svg">
    <source media="(prefers-color-scheme: light)" srcset="https://assets.ycodeapp.com/assets/app13650/Icons/arpQnWd8noiOpoMx0rFsCWN6MY0kCgpxPk3zbuzO.svg">
    <img alt="Ycode Logo" src="https://assets.ycodeapp.com/assets/app13650/Icons/arpQnWd8noiOpoMx0rFsCWN6MY0kCgpxPk3zbuzO.svg" width="200">
  </picture>
</p>

## About Ycode

Ycode is a visual website builder and CMS designed for creating and managing websites without writing code. It is available as a self-hosted Open Source project or as a fully managed [Cloud][cloud] service.

## Learning Ycode

Ycode has extensive [documentation][docs]. We actively maintain and improve it, so if something is unclear or incomplete, feel free to open an issue. We welcome any feedback that helps make the docs better.

## Setting Up Ycode Open Source

### Option A: Vercel + Supabase Cloud (Managed)

To deploy Ycode using managed services you will need:

- A [GitHub](https://github.com) account
- A [Supabase](https://supabase.com) account
- A [Vercel](https://vercel.com) account

Follow the [installation instructions][install] to get started.

### Option B: Docker Self-Hosted (No External Services)

Run the entire stack on your own server — no Vercel or Supabase Cloud accounts needed. Everything runs locally in Docker containers.

#### Prerequisites

- Docker Engine 24+ with Compose v2
- Node.js 18+ (for generating JWT keys during setup)
- 4 GB RAM minimum (8 GB recommended)
- A domain with two subdomains (e.g. `ycode.example.com` and `supa.example.com`)
- A reverse proxy (Cloudflare Tunnel, nginx, Caddy, etc.) pointing to the Docker ports

#### Quick Start

```bash
# 1. Clone the repo
git clone https://github.com/ycode/ycode.git
cd ycode/deploy

# 2. Generate all secrets (JWT keys, passwords, etc.)
bash scripts/generate-secrets.sh

# 3. Edit .env — set your domain URLs
#    SITE_URL            → your Ycode app URL (e.g. https://ycode.example.com)
#    API_EXTERNAL_URL    → your Supabase API URL (e.g. https://supa.example.com)
#    SUPABASE_PUBLIC_URL → same as API_EXTERNAL_URL
#    SELF_HOSTED_SUPABASE_HOSTNAME → the hostname only (e.g. supa.example.com)
nano .env

# 4. Build the Ycode app image
docker compose build ycode ycode-migrate

# 5. Start all services
docker compose up -d

# 6. Wait for all containers to become healthy (~2-3 minutes)
docker compose ps
```

Once all services are healthy, open `https://ycode.example.com/ycode/welcome` to create your admin account and start building.

#### Automated Setup

Alternatively, run the interactive setup script which handles steps 2-6 automatically:

```bash
cd deploy
bash scripts/setup.sh
```

#### What's Included

The Docker stack runs **14 services**:

| Service | Purpose |
|---------|---------|
| **PostgreSQL** | Primary database |
| **GoTrue** | Authentication (email, OAuth) |
| **PostgREST** | Auto-generated REST API |
| **Realtime** | WebSocket subscriptions |
| **Storage** | File/object storage |
| **Kong** | API gateway |
| **Studio** | Supabase dashboard UI |
| **Analytics** | Log ingestion (Logflare) |
| **Supavisor** | Connection pooling |
| **Edge Functions** | Serverless Deno functions |
| **Vector** | Log collection |
| **imgproxy** | Image transformations |
| **Ycode App** | The Ycode builder (Next.js) |
| **Ycode Migrate** | Database migrations (runs once) |

#### Helper Scripts

All scripts are in `deploy/scripts/`:

| Script | Purpose |
|--------|---------|
| `generate-secrets.sh` | Generate all passwords, JWT keys, and tokens |
| `setup.sh` | Interactive first-time setup (generates secrets, builds, starts) |
| `update.sh` | Pull latest images and restart services |
| `backup.sh` | Backup database and volumes |
| `rollback.sh` | Restore from a backup |

#### Supabase Studio

The Supabase Studio dashboard is accessible on the Kong port (default `3080`):

```
URL:      http://<your-server-ip>:3080
Username: supabase (default)
Password: (see DASHBOARD_PASSWORD in .env)
```

#### Reverse Proxy Setup

The stack exposes two ports that need to be routed through your reverse proxy:

| Domain | Target | Port |
|--------|--------|------|
| `ycode.example.com` | Ycode app | `3002` |
| `supa.example.com` | Kong API gateway | `3080` |

The included `docker-compose.yml` has a Cloudflare Tunnel service preconfigured. Set `CLOUDFLARE_TUNNEL_TOKEN` in `.env` to use it. For other reverse proxies (nginx, Caddy, Traefik), point them to the ports above.

## Support

We provide official support on [Ycode Cloud][cloud] projects. Community-driven support for the Open Source version is available in [Discord][discord].

## Contributing

Thank you for considering contributing to Ycode! We ask that you review the [contribution guide][contributing] before opening issues or submitting pull requests.

## Code of Conduct

To ensure the Ycode community is welcoming to all, please review and abide by our [Code of Conduct][coc].

## Important Links

- [Ycode Website][cloud]
- [Ycode Documentation][docs]
- [Ycode Discord Community][discord]

[cloud]: https://www.ycode.com
[docs]: https://docs.ycode.com/
[install]: https://docs.ycode.com/docs/getting-started/installation
[discord]: https://discord.gg/xadfw2DV4q
[contributing]: https://github.com/ycode/ycode/blob/main/CONTRIBUTING.md
[coc]: https://github.com/ycode/ycode/blob/main/CODE_OF_CONDUCT.md
