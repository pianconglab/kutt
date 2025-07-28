<p align="center"><a href="https://kutt.it" title="kutt.it"><img src="https://raw.githubusercontent.com/thedevs-network/kutt/9d1c873897c3f5b9a1bd0c74dc5d23f2ed01f2ec/static/images/logo-github.png" alt="Kutt.it"></a></p>

# Kutt.it - 现代化短链接服务

**Kutt** 是一个支持自定义域名的现代化 URL 短链接服务。支持创建和编辑链接、查看统计信息、管理用户等功能。

🌐 **官方网站**: [https://kutt.it](https://kutt.it)

[![docker-build-release](https://github.com/thedevs-network/kutt/actions/workflows/docker-build-release.yaml/badge.svg)](https://github.com/thedevs-network/kutt/actions/workflows/docker-build-release.yaml)
[![Uptime Status](https://uptime.betterstack.com/status-badges/v2/monitor/1ogaa.svg)](https://status.kutt.it)
[![Contributions](https://img.shields.io/badge/contributions-welcome-brightgreen.svg)](https://github.com/thedevs-network/kutt/#contributing)
[![GitHub license](https://img.shields.io/github/license/thedevs-network/kutt.svg)](https://github.com/thedevs-network/kutt/blob/develop/LICENSE)

## 📋 目录

- [🌟 核心特性](#-核心特性)
- [💝 捐赠与赞助](#-捐赠与赞助)
- [⚡ 快速开始](#-快速开始)
- [🐳 Docker 部署](#-docker-部署)
- [🚀 完整部署指南](#-完整部署指南)
- [🔌 API 接口](#-api-接口)
- [⚙️ 配置说明](#️-配置说明)
- [🎨 主题与自定义](#-主题与自定义)
- [🔗 浏览器扩展](#-浏览器扩展)
- [📺 相关视频](#-相关视频)
- [🔧 第三方集成](#-第三方集成)
- [🤝 贡献指南](#-贡献指南)

## 🌟 核心特性

- **🏠 专为自托管设计**：
  - 零配置即可运行
  - 简单部署，无需构建步骤
  - 支持多种数据库（SQLite、PostgreSQL、MySQL）
  - 可禁用注册和匿名链接创建
- **🌐 自定义域名支持**：完全支持使用自己的域名
- **🔧 灵活的链接管理**：
  - 自定义短链接地址
  - 设置密码保护
  - 添加描述信息
  - 设置过期时间
- **📊 链接管理功能**：
  - 查看、编辑、删除和管理所有链接
  - 私有的访问统计信息
  - 管理员页面管理用户和链接
- **🎨 可定制性**：支持主题和自定义样式
- **🔌 RESTful API**：完整的 API 接口支持

## 💝 捐赠与赞助

通过捐赠或成为赞助商来支持 Kutt 的开发。

[💰 捐赠或赞助 →](https://btcpay.kutt.it/apps/L9Gc7PrnLykeRHkhsH2jHivBeEh/crowdfund)

## ⚡ 快速开始

唯一的前置要求是 [Node.js](https://nodejs.org/)（版本 20 或以上）。默认数据库是 SQLite。你可以选择安装 PostgreSQL 或 MySQL/MariaDB 作为数据库，或者 Redis 作为缓存。

首次启动应用时，系统会提示你创建管理员账户。

1. 克隆此仓库或[下载最新版本](https://github.com/thedevs-network/kutt/releases)
2. 安装依赖：`npm install`
3. 初始化数据库：`npm run migrate`
4. 启动应用：开发环境 `npm run dev` 或生产环境 `npm start`

## 🐳 Docker 部署

确保已安装 Docker，然后可以从根目录启动应用：

```sh
docker compose up
```

提供了多种 docker-compose 配置。使用 `docker compose -f <文件名> up` 启动你需要的配置：

- [`docker-compose.yml`](./docker-compose.yml)：默认 Kutt 配置，使用 SQLite 数据库
- [`docker-compose.sqlite-redis.yml`](./docker-compose.sqlite-redis.yml)：使用 SQLite 和 Redis 启动 Kutt
  - 必需环境变量：`REDIS_ENABLED`
- [`docker-compose.postgres.yml`](./docker-compose.postgres.yml)：使用 PostgreSQL 和 Redis 启动 Kutt（**推荐，使用官方镜像**）
  - 必需环境变量：`REDIS_ENABLED`、`DB_PASSWORD`、`DB_NAME`、`DB_USER`
  - 使用官方 Docker 镜像 `kutt/kutt:latest`，无需本地构建
- [`docker-compose.mariadb.yml`](./docker-compose.mariadb.yml)：使用 MariaDB 和 Redis 启动 Kutt
  - 必需环境变量：`REDIS_ENABLED`、`DB_PASSWORD`、`DB_NAME`、`DB_USER`、`DB_PORT`

官方 Kutt Docker 镜像可在 [Docker Hub](https://hub.docker.com/r/kutt/kutt) 获取。

## 🚀 完整部署指南

本指南基于实际部署经验，提供在局域网主机上通过 Docker + frp 内网穿透的完整部署方案。

> **💡 部署方式说明**：本指南使用官方 Docker 镜像 `kutt/kutt:latest` 进行部署，无需本地构建，部署更加简单快速。

### 🏗️ 部署架构

```text
用户 → https://your-domain.com → 云服务器反向代理 → frps → frpc → 本地主机:10086 → Docker容器:3000
```

### 📋 前置要求

1. **本地主机**：
   - 安装 Docker（版本 20.10 或以上）
   - 安装 Docker Compose（版本 2.0 或以上）
   - 至少 2GB 可用磁盘空间（用于数据持久化）
   - 无需安装 Node.js、PostgreSQL、Redis 等依赖

2. **云服务器**：运行 frps 服务

3. **域名**：已解析到云服务器 IP

4. **frp 客户端**：本地主机运行 frpc

> **✨ 优势**：使用官方 Docker 镜像部署，环境隔离，依赖管理简单，一键启动。

### 💾 数据持久化说明

本部署方案会在项目目录下创建 `data/` 文件夹来持久化所有重要数据：

```text
kutt-deploy/
├── docker-compose.postgres.yml    # Docker 编排文件
├── .env                           # 环境变量配置
└── data/                          # 数据持久化目录
    ├── postgres/                  # PostgreSQL 数据库文件
    │   ├── base/                  # 数据库表空间
    │   ├── global/                # 全局数据
    │   ├── pg_wal/                # 事务日志
    │   └── ...                    # 其他数据库文件
    ├── redis/                     # Redis 缓存数据文件
    │   ├── appendonly.aof         # AOF 持久化文件
    │   └── dump.rdb               # RDB 快照文件
    └── custom/                    # 自定义文件（主题、样式等）
        ├── css/                   # 自定义 CSS 文件
        ├── images/                # 自定义图片文件
        └── views/                 # 自定义模板文件
```

> **⚠️ 重要提醒**：
>
> - `data/postgres/` 包含所有短链接数据，删除将导致数据永久丢失
> - `data/redis/` 包含缓存数据，删除会影响性能但不会丢失核心数据
> - 建议定期备份 `data/` 目录

### 🚀 部署步骤

#### 1. 准备部署文件

**方式一：快速部署（推荐）**

创建项目目录并下载必要的配置文件：

```bash
# 创建项目目录
mkdir kutt-deploy
cd kutt-deploy

# 下载 docker-compose 配置文件
wget https://raw.githubusercontent.com/thedevs-network/kutt/main/docker-compose.postgres.yml

# 下载环境变量示例文件
wget https://raw.githubusercontent.com/thedevs-network/kutt/main/.example.env -O .env

# 创建数据持久化目录
mkdir -p data/{postgres,redis,custom}

# 查看目录结构
tree . || ls -la
```

**方式二：完整克隆（用于自定义开发）**

如果你需要自定义代码或主题：

```bash
git clone https://github.com/thedevs-network/kutt.git
cd kutt

# 创建数据持久化目录（如果不存在）
mkdir -p data/{postgres,redis,custom}
```

#### 2. 配置环境变量

编辑 `.env` 文件，配置必要的环境变量：

```bash
# 使用你喜欢的编辑器打开 .env 文件
nano .env
# 或者
vim .env
```

**完整的 `.env` 配置示例：**

> **💡 提示**：现在所有配置参数都在 `.env` 文件中，包括 Docker 镜像版本、容器名称、健康检查参数等，使配置更加灵活和可维护。

```bash
# ===== 核心配置（必须修改） =====
# JWT 签名密钥 - 用于用户认证，必须设置为长随机字符串
JWT_SECRET=your-very-long-random-secret-string-at-least-32-characters

# ===== 数据库配置 =====
# PostgreSQL 数据库配置
DB_CLIENT=pg                          # 数据库客户端类型：PostgreSQL
DB_HOST=postgres                      # 数据库主机名（容器名）
DB_PORT=5432                          # 数据库端口
DB_NAME=kutt                          # 数据库名称
DB_USER=kutt_user                     # 数据库用户名
DB_PASSWORD=your-secure-password-123  # 数据库密码（请修改为强密码）

# PostgreSQL 初始化参数
POSTGRES_INITDB_ARGS=--encoding=UTF-8 --lc-collate=C --lc-ctype=C

# ===== 缓存配置 =====
# Redis 缓存配置
REDIS_ENABLED=true                    # 启用 Redis 缓存
REDIS_HOST=redis                      # Redis 主机名（容器名）
REDIS_PORT=6379                       # Redis 端口

# Redis 启动参数
REDIS_COMMAND=redis-server --appendonly yes --maxmemory 256mb --maxmemory-policy allkeys-lru

# ===== 应用配置 =====
# 网站基本信息
SITE_NAME=Kutt                        # 网站名称，显示在页面标题
DEFAULT_DOMAIN=short.your-domain.com  # 🔴 重要：修改为你的实际域名
PORT=3000                             # 应用内部端口（通常不需要修改）

# ===== 功能控制 =====
# 用户注册和链接创建控制
DISALLOW_REGISTRATION=false           # 是否禁用新用户注册（true=禁用，false=允许）
DISALLOW_ANONYMOUS_LINKS=false        # 是否禁用匿名创建链接（true=禁用，false=允许）

# ===== 网络和安全配置 =====
# 代理和 HTTPS 配置
TRUST_PROXY=true                      # 信任代理服务器（frp 环境必须为 true）
CUSTOM_DOMAIN_USE_HTTPS=true          # 自定义域名使用 HTTPS（推荐为 true）

# ===== Docker 配置 =====
# 容器配置
KUTT_IMAGE=kutt/kutt:latest           # Kutt 应用镜像
POSTGRES_IMAGE=postgres:17-alpine     # PostgreSQL 镜像
REDIS_IMAGE=redis:7-alpine            # Redis 镜像

# 容器名称
KUTT_CONTAINER_NAME=kutt-server       # Kutt 应用容器名
POSTGRES_CONTAINER_NAME=kutt-postgres # PostgreSQL 容器名
REDIS_CONTAINER_NAME=kutt-redis       # Redis 容器名

# 端口映射
HOST_PORT=10086                       # 主机端口（外部访问端口）
CONTAINER_PORT=3000                   # 容器内部端口

# 重启策略
RESTART_POLICY=always                 # 容器重启策略

# ===== 网络配置 =====
# Docker 网络
NETWORK_NAME=kutt_network             # Docker 网络名称
NETWORK_DRIVER=bridge                 # 网络驱动类型

# ===== 健康检查配置 =====
# PostgreSQL 健康检查
POSTGRES_HEALTH_INTERVAL=10s          # 健康检查间隔
POSTGRES_HEALTH_TIMEOUT=5s            # 健康检查超时
POSTGRES_HEALTH_RETRIES=5             # 健康检查重试次数
POSTGRES_HEALTH_START_PERIOD=30s      # 启动等待时间

# Redis 健康检查
REDIS_HEALTH_INTERVAL=10s             # 健康检查间隔
REDIS_HEALTH_TIMEOUT=3s               # 健康检查超时
REDIS_HEALTH_RETRIES=3                # 健康检查重试次数
REDIS_HEALTH_START_PERIOD=10s         # 启动等待时间

# ===== 可选配置 =====
# 短链接自定义
LINK_LENGTH=6                         # 短链接长度（默认 6 位）
# LINK_CUSTOM_ALPHABET=abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789

# 邮件配置（如果需要邮件功能）
# MAIL_ENABLED=false
# MAIL_HOST=smtp.gmail.com
# MAIL_PORT=587
# MAIL_USER=your-email@gmail.com
# MAIL_PASSWORD=your-app-password
# MAIL_FROM=your-email@gmail.com
# MAIL_SECURE=false
```

**🔧 配置说明：**

1. **必须修改的配置**：
   - `JWT_SECRET`: 生成一个至少 32 位的随机字符串
   - `DB_PASSWORD`: 设置一个强密码
   - `DEFAULT_DOMAIN`: 改为你的实际域名（如 `short.nanye.site`）

2. **JWT_SECRET 生成方法**：

   ```bash
   # 方法一：使用 openssl
   openssl rand -base64 32

   # 方法二：使用 uuidgen
   uuidgen | tr -d '-' | head -c 32 && echo

   # 方法三：在线生成
   # 访问 https://www.random.org/strings/ 生成随机字符串
   ```

3. **安全建议**：
   - 数据库密码至少 12 位，包含大小写字母、数字和特殊字符
   - 生产环境建议设置 `DISALLOW_REGISTRATION=true`
   - 定期更换 JWT_SECRET（需要重新登录所有用户）

4. **配置灵活性**：
   - **镜像版本控制**：可通过 `KUTT_IMAGE`、`POSTGRES_IMAGE`、`REDIS_IMAGE` 指定具体版本
   - **端口自定义**：通过 `HOST_PORT` 和 `CONTAINER_PORT` 自定义端口映射
   - **容器名称**：通过 `*_CONTAINER_NAME` 变量自定义容器名称
   - **健康检查调优**：可调整健康检查的间隔、超时和重试次数
   - **Redis 参数**：通过 `REDIS_COMMAND` 自定义 Redis 启动参数

5. **高级配置示例**：

   ```bash
   # 使用特定版本的镜像
   KUTT_IMAGE=kutt/kutt:2.7.4
   POSTGRES_IMAGE=postgres:15-alpine
   REDIS_IMAGE=redis:6-alpine

   # 自定义端口（避免冲突）
   HOST_PORT=8080

   # 调整健康检查（适应慢速环境）
   POSTGRES_HEALTH_START_PERIOD=60s
   POSTGRES_HEALTH_INTERVAL=30s

   # Redis 内存优化（适应小内存环境）
   REDIS_COMMAND=redis-server --appendonly yes --maxmemory 128mb --maxmemory-policy allkeys-lru
   ```

#### 3. 配置 frpc（内网穿透）

在 `/opt/frp_0.63.0_linux_amd64/frpc.toml` 中添加：

```toml
[[proxies]]
name = "kutt-tcp"
type = "tcp"
localIP = "127.0.0.1"
localPort = 10086
remotePort = 10086
```

#### 4. 启动服务

**步骤详解：**

```bash
# 1. 确保在正确的目录中
pwd  # 应该显示你的项目目录路径

# 2. 检查配置文件是否存在
ls -la docker-compose.postgres.yml .env

# 3. 拉取最新的官方镜像（推荐）
docker compose -f docker-compose.postgres.yml pull

# 4. 启动所有服务（后台运行）
docker compose -f docker-compose.postgres.yml up -d

# 5. 查看启动日志（可选）
docker compose -f docker-compose.postgres.yml logs -f
```

**启动过程说明：**

1. **镜像下载**：首次运行会下载以下镜像
   - `kutt/kutt:latest` (~200MB) - Kutt 主应用
   - `postgres:17-alpine` (~100MB) - PostgreSQL 数据库
   - `redis:7-alpine` (~30MB) - Redis 缓存

2. **容器启动顺序**：
   - PostgreSQL 数据库先启动并进行健康检查
   - Redis 缓存启动
   - Kutt 应用最后启动（等待数据库就绪）

3. **数据初始化**：
   - 首次启动会自动创建数据库表结构
   - 数据持久化到 `./data/` 目录

#### 5. 验证部署

**全面的部署验证步骤：**

```bash
# 1. 检查所有容器状态
docker compose -f docker-compose.postgres.yml ps
# 期望输出：所有容器状态为 "Up" 或 "Up (healthy)"

# 2. 检查各个服务的健康状态
echo "=== 检查 Kutt 应用 ==="
curl -I http://localhost:10086
# 期望输出：HTTP/1.1 200 OK

echo "=== 检查 API 健康端点 ==="
curl http://localhost:10086/api/v2/health
# 期望输出：OK

echo "=== 检查 PostgreSQL ==="
docker compose -f docker-compose.postgres.yml exec postgres pg_isready -U kutt_user -d kutt
# 期望输出：accepting connections

echo "=== 检查 Redis ==="
docker compose -f docker-compose.postgres.yml exec redis redis-cli ping
# 期望输出：PONG

# 3. 检查端口监听
netstat -tlnp | grep 10086
# 期望输出：显示 10086 端口被监听

# 4. 查看实时日志（可选）
docker compose -f docker-compose.postgres.yml logs -f --tail=50
```

**验证结果判断：**

✅ **部署成功的标志**：

- 所有容器状态为 "Up" 且 PostgreSQL 显示 "healthy"
- `curl http://localhost:10086` 返回 HTTP 200
- API 健康检查返回 "OK"
- 数据库和 Redis 连接正常

❌ **常见问题排查**：

- 如果容器启动失败，检查 `.env` 文件配置
- 如果端口冲突，修改 docker-compose.yml 中的端口映射
- 如果数据库连接失败，检查 `DB_PASSWORD` 等数据库配置

**首次访问设置：**

1. 打开浏览器访问 `http://localhost:10086`
2. 首次访问会提示创建管理员账户
3. 填写邮箱和密码创建账户
4. 登录后即可开始使用短链接服务

### 🔧 云服务器配置

#### Nginx 反向代理配置

在云服务器上配置 Nginx：

```nginx
server {
    listen 80;
    server_name short.your-domain.com;
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl http2;
    server_name short.your-domain.com;

    ssl_certificate /path/to/your/cert.pem;
    ssl_certificate_key /path/to/your/key.pem;

    location / {
        proxy_pass http://127.0.0.1:10086;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

### 🎯 首次使用

1. **访问管理界面**：`https://short.your-domain.com`
2. **创建管理员账户**：首次访问时会提示创建
3. **生成 API 密钥**：在设置页面生成 API 密钥用于程序化访问
4. **测试短链接**：创建一个测试链接验证功能

### 📊 运维管理

#### 常用命令

```bash
# 查看运行状态
docker compose -f docker-compose.postgres.yml ps

# 查看日志
docker compose -f docker-compose.postgres.yml logs -f server

# 重启服务
docker compose -f docker-compose.postgres.yml restart

# 停止服务
docker compose -f docker-compose.postgres.yml down

# 更新服务（拉取最新官方镜像）
docker compose -f docker-compose.postgres.yml pull
docker compose -f docker-compose.postgres.yml up -d
```

#### 数据备份与恢复

**📦 完整备份方案**

```bash
# 1. 创建备份目录
mkdir -p backups/$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="backups/$(date +%Y%m%d_%H%M%S)"

# 2. 备份数据库（SQL 格式）
echo "正在备份数据库..."
docker compose -f docker-compose.postgres.yml exec postgres pg_dump -U kutt_user kutt > $BACKUP_DIR/database.sql

# 3. 备份数据库（自定义格式，支持并行恢复）
docker compose -f docker-compose.postgres.yml exec postgres pg_dump -U kutt_user -Fc kutt > $BACKUP_DIR/database.dump

# 4. 备份整个数据目录
echo "正在备份数据目录..."
tar -czf $BACKUP_DIR/data-full-backup.tar.gz data/

# 5. 备份配置文件
cp .env $BACKUP_DIR/
cp docker-compose.postgres.yml $BACKUP_DIR/

# 6. 创建备份信息文件
echo "备份时间: $(date)" > $BACKUP_DIR/backup-info.txt
echo "Kutt 版本: $(docker compose -f docker-compose.postgres.yml exec server cat /kutt/package.json | grep version)" >> $BACKUP_DIR/backup-info.txt
echo "数据库大小: $(du -sh data/postgres)" >> $BACKUP_DIR/backup-info.txt

echo "备份完成，保存在: $BACKUP_DIR"
```

**🔄 数据恢复方案**

```bash
# 1. 停止服务
docker compose -f docker-compose.postgres.yml down

# 2. 恢复数据目录（完整恢复）
rm -rf data/  # ⚠️ 危险操作，确保有备份
tar -xzf backups/20240101_120000/data-full-backup.tar.gz

# 3. 或者仅恢复数据库
# 启动数据库服务
docker compose -f docker-compose.postgres.yml up -d postgres

# 等待数据库启动
sleep 30

# 恢复数据库（从 SQL 文件）
docker compose -f docker-compose.postgres.yml exec -T postgres psql -U kutt_user -d kutt < backups/20240101_120000/database.sql

# 或者恢复数据库（从 dump 文件）
docker compose -f docker-compose.postgres.yml exec postgres pg_restore -U kutt_user -d kutt -c /tmp/database.dump

# 4. 启动所有服务
docker compose -f docker-compose.postgres.yml up -d
```

**⏰ 自动备份脚本**

创建自动备份脚本 `backup.sh`：

```bash
#!/bin/bash
# Kutt 自动备份脚本

# 配置
KUTT_DIR="/path/to/your/kutt-deploy"  # 修改为你的实际路径
BACKUP_ROOT="/path/to/backups"        # 修改为你的备份目录
KEEP_DAYS=30                          # 保留备份天数

cd $KUTT_DIR

# 创建备份目录
BACKUP_DIR="$BACKUP_ROOT/$(date +%Y%m%d_%H%M%S)"
mkdir -p $BACKUP_DIR

# 备份数据库
docker compose -f docker-compose.postgres.yml exec postgres pg_dump -U kutt_user -Fc kutt > $BACKUP_DIR/database.dump

# 备份配置文件
cp .env docker-compose.postgres.yml $BACKUP_DIR/

# 压缩备份
tar -czf $BACKUP_DIR.tar.gz -C $BACKUP_ROOT $(basename $BACKUP_DIR)
rm -rf $BACKUP_DIR

# 清理旧备份
find $BACKUP_ROOT -name "*.tar.gz" -mtime +$KEEP_DAYS -delete

echo "备份完成: $BACKUP_DIR.tar.gz"
```

**设置定时备份（crontab）**：

```bash
# 编辑 crontab
crontab -e

# 添加以下行（每天凌晨 2 点备份）
0 2 * * * /path/to/backup.sh >> /var/log/kutt-backup.log 2>&1
```

### 🔧 高级配置

#### 支持 IP 域名（内网环境）

**问题描述**：
默认情况下，Kutt 不支持 IP 地址作为目标 URL（如 `http://192.168.5.3:12345`），这是出于安全考虑，防止 SSRF 攻击和内网扫描。

**解决方案**：

如果你在内网环境中使用 Kutt，需要支持 IP 地址，可以通过以下方式解决：

**方法一：修改源代码（推荐）**

1. **修改 URL 验证正则表达式**：

   编辑 `server/utils/utils.js` 文件，找到第 25 行左右的 `urlRegex`：

   ```javascript
   // 原始代码（排除私有 IP）
   const urlRegex = /^(?:(?:(?:https?|ftp):)?\/\/)(?:\S+(?::\S*)?@)?(?:(?!(?:10|127)(?:\.\d{1,3}){3})(?!(?:169\.254|192\.168)(?:\.\d{1,3}){2})(?!172\.(?:1[6-9]|2\d|3[0-1])(?:\.\d{1,3}){2})(?:[1-9]\d?|1\d\d|2[01]\d|22[0-3])(?:\.(?:1?\d{1,2}|2[0-4]\d|25[0-5])){2}(?:\.(?:[1-9]\d?|1\d\d|2[0-4]\d|25[0-4]))|(?:(?:[a-z0-9\u00a1-\uffff][a-z0-9\u00a1-\uffff_-]{0,62})?[a-z0-9\u00a1-\uffff]\.)+(?:[a-z\u00a1-\uffff]{2,}\.?))(?::\d{2,5})?(?:[/?#]\S*)?$/i;

   // 修改为（允许所有 IP）
   const urlRegex = /^(?:(?:(?:https?|ftp):)?\/\/)(?:\S+(?::\S*)?@)?(?:(?:(?:25[0-5]|2[0-4]\d|[01]?\d\d?)\.){3}(?:25[0-5]|2[0-4]\d|[01]?\d\d?)|(?:(?:[a-z0-9\u00a1-\uffff][a-z0-9\u00a1-\uffff_-]{0,62})?[a-z0-9\u00a1-\uffff]\.)+(?:[a-z\u00a1-\uffff]{2,}\.?))(?::\d{2,5})?(?:[/?#]\S*)?$/i;
   ```

2. **重新构建镜像**：

   ```bash
   # 修改 docker-compose.postgres.yml，使用本地构建
   # 将 image: kutt/kutt:latest 改为：
   build:
     context: .
     dockerfile: Dockerfile

   # 重新构建并启动
   docker compose -f docker-compose.postgres.yml up -d --build
   ```

**方法二：使用自定义镜像（简单）**

如果不想修改源代码，可以使用已经修改过的镜像：

```bash
# 在 .env 文件中修改镜像
KUTT_IMAGE=your-custom-kutt-image:latest
```

**方法三：环境变量控制（推荐用于生产）**

在 `.env` 文件中添加：

```bash
# 允许私有 IP 地址（仅内网环境使用）
ALLOW_PRIVATE_IPS=true
```

然后修改 `server/utils/utils.js`：

```javascript
// 根据环境变量选择正则表达式
const urlRegexWithPrivateIPs = /^(?:(?:(?:https?|ftp):)?\/\/)(?:\S+(?::\S*)?@)?(?:(?:(?:25[0-5]|2[0-4]\d|[01]?\d\d?)\.){3}(?:25[0-5]|2[0-4]\d|[01]?\d\d?)|(?:(?:[a-z0-9\u00a1-\uffff][a-z0-9\u00a1-\uffff_-]{0,62})?[a-z0-9\u00a1-\uffff]\.)+(?:[a-z\u00a1-\uffff]{2,}\.?))(?::\d{2,5})?(?:[/?#]\S*)?$/i;
const urlRegexWithoutPrivateIPs = /^(?:(?:(?:https?|ftp):)?\/\/)(?:\S+(?::\S*)?@)?(?:(?!(?:10|127)(?:\.\d{1,3}){3})(?!(?:169\.254|192\.168)(?:\.\d{1,3}){2})(?!172\.(?:1[6-9]|2\d|3[0-1])(?:\.\d{1,3}){2})(?:[1-9]\d?|1\d\d|2[01]\d|22[0-3])(?:\.(?:1?\d{1,2}|2[0-4]\d|25[0-5])){2}(?:\.(?:[1-9]\d?|1\d\d|2[0-4]\d|25[0-4]))|(?:(?:[a-z0-9\u00a1-\uffff][a-z0-9\u00a1-\uffff_-]{0,62})?[a-z0-9\u00a1-\uffff]\.)+(?:[a-z\u00a1-\uffff]{2,}\.?))(?::\d{2,5})?(?:[/?#]\S*)?$/i;

const urlRegex = process.env.ALLOW_PRIVATE_IPS === "true" ? urlRegexWithPrivateIPs : urlRegexWithoutPrivateIPs;
```

**⚠️ 安全警告**：

- 仅在内网环境中启用 IP 地址支持
- 公网部署时不建议允许私有 IP，可能导致安全风险
- 确保防火墙和网络安全策略已正确配置

**测试验证**：

修改后，你应该能够创建指向 IP 地址的短链接：

```bash
# 测试 API
curl -X POST http://localhost:10086/api/v2/links \
  -H "Content-Type: application/json" \
  -d '{"target": "http://192.168.5.3:12345/#/send"}'
```

### 🔍 故障排除

#### 常见问题

1. **容器无法启动**

   ```bash
   # 检查日志
   docker compose -f docker-compose.postgres.yml logs
   ```

2. **数据库连接失败**

   ```bash
   # 检查数据库状态
   docker compose -f docker-compose.postgres.yml exec postgres pg_isready -U kutt_user -d kutt
   ```

3. **Redis 连接失败**

   ```bash
   # 检查 Redis 状态
   docker compose -f docker-compose.postgres.yml exec redis redis-cli ping
   ```

4. **外网无法访问**
   - 检查 frpc 服务是否运行
   - 检查云服务器防火墙设置
   - 检查域名解析是否正确

### 🔒 安全建议

1. **定期更新密码**：定期更改数据库密码和管理员密码
2. **启用 HTTPS**：确保使用 SSL 证书
3. **限制注册**：生产环境建议设置 `DISALLOW_REGISTRATION=true`
4. **备份数据**：定期备份数据库和配置文件
5. **监控日志**：定期检查应用日志

### 📈 性能优化

1. **Redis 缓存**：确保 Redis 正常运行以提高性能
2. **数据库优化**：根据使用量调整数据库连接池设置
3. **反向代理缓存**：在 Nginx 中配置适当的缓存策略

### 🎉 部署成功验证

部署完成后，你应该能够：

1. **访问 Web 界面**：`https://short.your-domain.com`
2. **创建短链接**：在首页输入长 URL 生成短链接
3. **管理链接**：查看、编辑、删除已创建的链接
4. **查看统计**：查看链接的访问统计信息
5. **API 访问**：使用 API 密钥进行程序化操作

如果以上功能都正常，恭喜你成功部署了 Kutt 短链接服务！

## 🔌 API 接口

[📖 查看 API 文档 →](https://docs.kutt.it)

## ⚙️ 配置说明

应用通过环境变量进行配置。你可以直接传递环境变量或创建 `.env` 文件。查看 [`.example.env`](./.example.env) 文件了解配置列表。

除了生产环境必需的 `JWT_SECRET` 外，所有变量都是可选的。

你可以通过在变量名后添加 `_FILE` 来使用文件形式的变量。例如：`JWT_SECRET_FILE=/path/to/secret_file`。

| 变量名 | 描述 | 默认值 | 示例 |
| -------- | ----------- | ------- | ------- |
| `JWT_SECRET` | 用于签名认证令牌。请使用**长**且**随机**的字符串。 | - | - |
| `PORT` | 应用启动端口 | `3000` | `8888` |
| `SITE_NAME` | 网站名称 | `Kutt` | `Your Site` |
| `DEFAULT_DOMAIN` | 应用运行的域名地址 | `localhost:3000` | `yoursite.com` |
| `LINK_LENGTH` | 短链接地址长度 | `6` | `5` |
| `LINK_CUSTOM_ALPHABET` | 生成自定义地址的字母表。默认值省略了 o、O、0、i、I、l、1 和 j 以避免阅读 URL 时的混淆。 | (abcd..789) | `abcABC^&*()@` |
| `DISALLOW_REGISTRATION` | 禁用注册。注意如果 `MAIL_ENABLED` 设为 false，注册仍会被禁用，因为它依赖邮件来注册用户。 | `true` | `false` |
| `DISALLOW_ANONYMOUS_LINKS` | 禁用匿名链接创建 | `true` | `false` |
| `TRUST_PROXY` | 如果应用运行在 NGINX 或 Cloudflare 等代理服务器后面，应该从代理服务器获取 IP 地址。如果不使用代理服务器则设为 false，否则用户可以覆盖其 IP 地址。 | `true` | `false` |
| `DB_CLIENT` | 使用的数据库客户端。支持的客户端：PostgreSQL 使用 `pg` 或 `pg-native`，MySQL 或 MariaDB 使用 `mysql2`，SQLite 使用 `sqlite3` 和 `better-sqlite3`。注意：`pg-native` 和 `sqlite3` 默认未安装，使用前需要用 `npm` 安装。 | `better-sqlite3` | `pg` |
| `DB_FILENAME` | SQLite 数据库文件路径。仅在使用 SQLite 时需要。 | `db/data` | `/var/lib/data` |
| `DB_HOST` | 数据库连接主机。仅在使用 PostgreSQL 或 MySQL 时需要。 | `localhost` | `your-db-host.com` |
| `DB_PORT` | 数据库端口。仅在使用 PostgreSQL 或 MySQL 时需要。 | `5432` (PostgreSQL) | `3306` (MySQL) |
| `DB_NAME` | 数据库名称。仅在使用 PostgreSQL 或 MySQL 时需要。 | `kutt` | `mydb` |
| `DB_USER` | 数据库用户。仅在使用 PostgreSQL 或 MySQL 时需要。 | `postgres` | `myuser` |
| `DB_PASSWORD` | 数据库密码。仅在使用 PostgreSQL 或 MySQL 时需要。 | - | `mypassword` |
| `DB_SSL` | 是否为数据库连接使用 SSL。仅在使用 PostgreSQL 或 MySQL 时需要。 | `false` | `true` |
| `DB_POOL_MIN` | 数据库连接池最小数量。仅在使用 PostgreSQL 或 MySQL 时需要。 | `0` | `2` |
| `DB_POOL_MAX` | 数据库连接池最大数量。仅在使用 PostgreSQL 或 MySQL 时需要。 | `10` | `5` |
| `REDIS_ENABLED` | 是否使用 Redis 作为缓存 | `false` | `true` |
| `REDIS_HOST` | Redis 连接主机 | `127.0.0.1` | `your-redis-host.com` |
| `REDIS_PORT` | Redis 端口 | `6379` | `6379` |
| `REDIS_PASSWORD` | Redis 密码 | - | `mypassword` |
| `REDIS_DB` | Redis 数据库编号，范围 0-15 | `0` | `1` |
| `SERVER_IP_ADDRESS` | 在设置页面向用户显示的 IP 地址。仅用于显示目的，无其他用途。 | - | `1.2.3.4` |
| `SERVER_CNAME_ADDRESS` | 在设置页面向用户显示的子域名。仅用于显示目的，无其他用途。 | - | `custom.yoursite.com` |
| `CUSTOM_DOMAIN_USE_HTTPS` | 为自定义域名链接使用 HTTPS。你需要手动为这些域名生成 SSL 证书——至少在当前版本中是这样。 | `false` | `true` |
| `ENABLE_RATE_LIMIT` | 为某些 API 路由启用速率限制。如果启用了 Redis 则使用 Redis，否则使用内存。 | `false` | `true` |
| `MAIL_ENABLED` | 启用邮件功能，用于注册、验证或更改邮箱地址、重置密码和发送报告。如果禁用，所有这些功能也会被禁用。 | `false` | `true` |
| `MAIL_HOST` | 邮件服务器主机 | - | `your-mail-server.com` |
| `MAIL_PORT` | 邮件服务器端口 | `587` | `465` (SSL) |
| `MAIL_USER` | 邮件服务器用户 | - | `myuser` |
| `MAIL_PASSWORD` | 邮件服务器用户密码 | - | `mypassword` |
| `MAIL_FROM` | 发送邮件的邮箱地址 | - | `example@yoursite.com` |
| `MAIL_SECURE` | 是否为邮件服务器连接使用 SSL | `false` | `true` |
| `REPORT_EMAIL` | 接收提交报告的邮箱地址 | - | `example@yoursite.com` |
| `CONTACT_EMAIL` | 在应用中显示的支持邮箱地址 | - | `example@yoursite.com` |

## 🎨 主题与自定义

你可以添加样式、更改图片或渲染自定义 HTML。根据以下说明将内容放置在 [`/custom`](./custom) 文件夹中。

### 工作原理

自定义文件夹的结构如下：

```text
custom/
├─ css/
│  ├─ custom1.css
│  ├─ custom2.css
│  ├─ ...
├─ images/
│  ├─ logo.png
│  ├─ favicon.ico
│  ├─ ...
├─ views/
│  ├─ partials/
│  │  ├─ footer.hbs
│  ├─ 404.hbs
│  ├─ ...
```

- **css**：将你的 CSS 样式文件放在这里。（[查看示例 →](https://github.com/thedevs-network/kutt-customizations/tree/main/themes/crimson/css)）
  - 你可以放置任意数量的样式文件：`custom1.css`、`custom2.css` 等。
  - 如果你将样式文件命名为 `styles.css`，它将替换 Kutt 的原始 `styles.css` 文件。
  - 每个文件都可以通过 `<your-site.com>/css/<file>.css` 访问
- **images**：将你的图片放在这里。（[查看示例 →](https://github.com/thedevs-network/kutt-customizations/tree/main/themes/crimson/images)）
  - 使用与 [`/static/images/`](./static/images) 文件夹中相同的文件名来替换 Kutt 的原始图片。
  - 每个图片都可以通过 `<your-site.com>/images/<image>.<image-format>` 访问
- **views**：要渲染的自定义 HTML 模板。（[查看示例 →](https://github.com/thedevs-network/kutt-customizations/tree/main/themes/crimson/views)）
  - 应遵循与 [`/server/views`](./server/views) 相同的文件命名和文件夹结构
  - 虽然我们尽量保持原始文件名不变，但请注意 Kutt 的新更改可能会破坏你的自定义视图。

### 示例主题：Crimson

这是一个示例和官方主题。Crimson 包含自定义样式、图片和视图。

[获取 Crimson 主题 →](https://github.com/thedevs-network/kutt-customizations/tree/main/themes/crimson)

[查看主题和自定义列表 →](https://github.com/thedevs-network/kutt-customizations)

| 首页 | 管理页面 | 登录/注册 |
| -------- | ---------- | ------------ |
| ![crimson-homepage](https://github.com/user-attachments/assets/b74fab78-5e80-4f57-8425-f0cc73e9c68d) | ![crimson-admin](https://github.com/user-attachments/assets/a75d2430-8074-4ce4-93ec-d8bdfd75d917) | ![crimson-login-signup ](https://github.com/user-attachments/assets/b915eb77-3d66-4407-8e5d-b556f80ff453) |

### Docker 使用方法

如果你在本地构建镜像，那么 `/custom` 文件夹应该已经包含在你的应用中。

如果你拉取官方镜像，请确保挂载了 `/kutt/custom` 卷或你有权访问它。[查看 Docker compose 示例 →](https://github.com/thedevs-network/kutt/blob/main/docker-compose.yml#L7)

然后，将你的文件移动到该卷。你可以使用以下 Docker 命令：

```sh
docker cp <自定义文件夹路径> <kutt容器名称>:/kutt
```

例如：

```sh
docker cp custom kutt-server-1:/kutt
```

复制文件或进行更改后，请确保重启 kutt 服务器容器。

## 🔗 浏览器扩展

通过以下链接下载 Kutt 的浏览器扩展。

- [Chrome](https://chrome.google.com/webstore/detail/kutt/pklakpjfiegjacoppcodencchehlfnpd)
- [Firefox](https://addons.mozilla.org/en-US/firefox/addon/kutt/)

## 📺 相关视频

### 官方视频

- [Next.js to htmx – A Real World Example](https://www.youtube.com/watch?v=8RL4NvYZDT4)

## 🔧 第三方集成

- **ShareX** – 你可以在 [ShareX](https://getsharex.com/) 中使用 Kutt 作为默认的 URL 短链接服务。如果你托管自己的 Kutt 实例，请参考 [ShareX wiki](https://github.com/thedevs-network/kutt/wiki/ShareX) 了解如何设置。
- **Alfred workflow** – 从 [alfred-kutt](https://github.com/thedevs-network/alfred-kutt) 仓库下载 Kutt 的官方 [Alfred](https://www.alfredapp.com/) 应用工作流。
- **iOS 快捷指令** – 适用于你的苹果设备的 [Kutt 快捷指令](https://www.icloud.com/shortcuts/a829856aea2c420e97c53437e68b752b)，可从 iOS 分享上下文菜单或独立模式工作。由 [@caneeeeee](https://github.com/caneeeeee) 提供。

### 第三方包

| 编程语言        | 链接                                                                              | 描述                                          |
| --------------- | --------------------------------------------------------------------------------- | ---------------------------------------------------- |
| C# (.NET)       | [KuttSharp](https://github.com/0xaryan/KuttSharp)                                 | Kutt.it 短链接服务的 .NET 包               |
| C# (.NET)       | [Kutt.NET](https://github.com/AlphaNecron/Kutt.NET)                               | Kutt 的 C# API 包装器                              |
| Python          | [kutt-cli](https://github.com/RealAmirali/kutt-cli)                               | 用 Python 编写的 Kutt 命令行客户端       |
| Ruby            | [kutt.rb](https://github.com/RealAmirali/kutt.rb)                                 | 用 Ruby 编写的 Kutt 库                         |
| Rust            | [urlshortener](https://github.com/vityafx/urlshortener-rs)                        | 用 Rust 编写的 URL 短链接库                |
| Rust            | [kutt-rs](https://github.com/robatipoor/kutt-rs)                                  | 用 Rust 编写的命令行工具                    |
| Node.js         | [node-kutt](https://github.com/ardalanamini/node-kutt)                            | Kutt.it 短链接服务的 Node.js 客户端             |
| JavaScript      | [kutt-vscode](https://github.com/mehrad77/kutt-vscode)                            | Kutt 的 Visual Studio Code 扩展                |
| Java            | [kutt-desktop](https://github.com/cipher812/kutt-desktop)                         | Kutt 的跨平台 Java 桌面应用程序   |
| Go              | [kutt-go](https://github.com/raahii/kutt-go)                                      | Kutt.it 短链接服务的 Go 客户端                  |
| BASH            | [GitHub Gist](https://gist.github.com/hashworks/6d6e4eae8984a5018f7692a796d570b4) | 访问 API 的简单 BASH 函数               |
| BASH            | [url-shortener](https://git.tim-peters.org/Tim/url-shortener)                     | 带 GUI 的简单 BASH 脚本                          |
| Kubernetes/Helm | [ArtifactHub](https://artifacthub.io/packages/helm/christianhuth/kutt)            | 在 Kubernetes 集群上安装 Kutt 的 Helm Chart |

## 🤝 贡献指南

欢迎提交 Pull Request。可以开启讨论来获取反馈、请求功能或讨论想法。

特别感谢 [Thomas](https://github.com/trgwii) 和 [Muthu](https://github.com/MKRhere)。Logo 设计由 [Muthu](https://github.com/MKRhere) 完成。
