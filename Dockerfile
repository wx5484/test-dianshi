# ==========================================
# 1. 构建阶段 (Builder)
# 直接使用完整版 Node 20，安装和构建在同一步完成
# ==========================================
FROM node:20 AS builder
WORKDIR /app

# 复制所有源代码
COPY . .

# 1. 强制安装依赖 (忽略冲突)
RUN npm install --legacy-peer-deps

# 2. 立即开始构建 (因为在同一个阶段，绝对能找到 next 命令)
RUN npm run build

# ==========================================
# 2. 运行阶段 (Runner)
# 使用 Slim 版减小体积
# ==========================================
FROM node:20-slim AS runner
WORKDIR /app

ENV NODE_ENV production
ENV NEXT_TELEMETRY_DISABLED 1
ENV PORT 3000
ENV HOSTNAME "0.0.0.0"

# 创建非 root 用户
RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 nextjs

# 复制构建产物
# 注意：这里直接从 builder 阶段复制，路径不会错
COPY --from=builder /app/public ./public
COPY --from=builder --chown=nextjs:nodejs /app/.next/standalone ./
COPY --from=builder --chown=nextjs:nodejs /app/.next/static ./.next/static

USER nextjs

EXPOSE 3000

CMD ["node", "server.js"]
