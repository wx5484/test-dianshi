# ==========================================
# 1. 依赖安装阶段 (使用完整版 Node 镜像，自带编译工具)
# ==========================================
# 【关键修改】这里改用 node:20 完整版，不再用 slim
# 完整版包含 python, make, g++，能解决所有编译报错
FROM node:20 AS deps
WORKDIR /app

# 复制依赖文件
COPY package.json package-lock.json* ./

# 【关键修改】加上 --legacy-peer-deps 忽略版本冲突
# 加上 --no-audit 加快速度
# 即使有依赖打架，也能强制安装成功
RUN npm install --legacy-peer-deps --no-audit

# ==========================================
# 2. 构建阶段 (依然使用完整版)
# ==========================================
FROM node:20 AS builder
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY . .

# 禁用 Next.js 遥测
ENV NEXT_TELEMETRY_DISABLED 1

# 开始构建
RUN npm run build

# ==========================================
# 3. 运行阶段 (使用 Slim 版以减小体积)
# ==========================================
# 运行时不需要编译工具，所以这里可以用 slim
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
COPY --from=builder /app/public ./public

# 自动生成的独立运行包
COPY --from=builder --chown=nextjs:nodejs /app/.next/standalone ./
COPY --from=builder --chown=nextjs:nodejs /app/.next/static ./.next/static

USER nextjs

EXPOSE 3000

CMD ["node", "server.js"]
