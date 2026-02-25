# ─── Stage 1: Dependencies ───────────────────────────────────────────────────
FROM node:22-alpine AS deps
RUN apk add --no-cache libc6-compat
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci --frozen-lockfile

# ─── Stage 2: Builder ────────────────────────────────────────────────────────
# This stage can also be used as a target for running migrations
FROM node:22-alpine AS builder
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY . .

# Build-time env vars (NEXT_PUBLIC_* are baked into client bundle)
ARG NEXT_PUBLIC_TEMPLATE_API_URL=""
ARG NEXT_PUBLIC_SUPABASE_URL=""
ENV NEXT_PUBLIC_TEMPLATE_API_URL=$NEXT_PUBLIC_TEMPLATE_API_URL
ENV NEXT_PUBLIC_SUPABASE_URL=$NEXT_PUBLIC_SUPABASE_URL

RUN npm run build

# ─── Stage 3: Runner (production) ────────────────────────────────────────────
FROM node:22-alpine AS runner
WORKDIR /app

ENV NODE_ENV=production
ENV PORT=3002
ENV HOSTNAME=0.0.0.0

RUN addgroup --system --gid 1001 nodejs && \
    adduser --system --uid 1001 nextjs

# Copy standalone output
COPY --from=builder /app/public ./public
COPY --from=builder --chown=nextjs:nodejs /app/.next/standalone ./
COPY --from=builder --chown=nextjs:nodejs /app/.next/static ./.next/static

USER nextjs

EXPOSE 3002

CMD ["node", "server.js"]
