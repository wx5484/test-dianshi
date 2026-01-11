# ==========================================
# 1. 依赖安装阶段 (使用 Debian Slim)
# ==========================================
FROM node:20-slim AS base

FROM base AS deps
WORKDIR /app

# 复制依赖文件
COPY package.json package-lock.json* ./

# 【关键修改】这里把 npm ci 改成了 npm install
# 这样即使没有 lock 文件或者版本不对也能成功安装
RUN npm install

# ==========================================
# 2. 构建阶段
# ==========================================
FROM base AS builder
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY . .

# 禁用 Next.js 遥测
ENV NEXT_TELEMETRY_DISABLED 1

# 开始构建
RUN npm run build

# ==========================================
# 3. 运行阶段 (生产环境)
# ==========================================
FROM base AS runner
WORKDIR /app

ENV NODE_ENV production
ENV NEXT_TELEMETRY_DISABLED 1
ENV PORT 3000
ENV HOSTNAME "0.0.0.0"

# 创建非 root 用户
RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 nextjs

# 复制构建产物
COPY --from=builder /app/public ./public

# 自动生成的独立运行包
COPY --from=builder --chown=nextjs:nodejs /app/.next/standalone ./
COPY --from=builder --chown=nextjs:nodejs /app/.next/static ./.next/static

USER nextjs

EXPOSE 3000

CMD ["node", "server.js"]
