#!/bin/bash

# Kutt 权限修复脚本
# 彻底解决 Docker 容器权限问题

set -e

echo "🔧 Kutt 权限修复脚本"
echo "===================="

# 获取当前用户信息
CURRENT_UID=$(id -u)
CURRENT_GID=$(id -g)
CURRENT_USER=$(whoami)

echo "📋 当前用户信息："
echo "   用户: $CURRENT_USER"
echo "   UID: $CURRENT_UID"
echo "   GID: $CURRENT_GID"

# 检查是否在正确的目录
if [ ! -f "docker-compose.postgres.yml" ]; then
    echo "❌ 错误：请在 Kutt 项目根目录中运行此脚本"
    exit 1
fi

echo ""
echo "🛑 停止所有容器..."
docker compose -f docker-compose.postgres.yml down 2>/dev/null || true

echo ""
echo "🧹 清理旧的数据目录..."
sudo rm -rf data/

echo ""
echo "📁 创建新的数据目录结构..."
mkdir -p data/{postgres,redis,custom}

echo ""
echo "🔐 设置正确的权限..."
# 设置目录权限
chmod 755 data/
chmod 755 data/postgres
chmod 755 data/redis
chmod 755 data/custom

# 设置所有者
chown -R $CURRENT_UID:$CURRENT_GID data/

echo ""
echo "📝 更新 .env 文件中的 UID/GID..."
# 更新 .env 文件中的 UID 和 GID
if grep -q "^UID=" .env; then
    sed -i "s/^UID=.*/UID=$CURRENT_UID/" .env
else
    echo "UID=$CURRENT_UID" >> .env
fi

if grep -q "^GID=" .env; then
    sed -i "s/^GID=.*/GID=$CURRENT_GID/" .env
else
    echo "GID=$CURRENT_GID" >> .env
fi

echo ""
echo "🚀 重新启动服务..."
docker compose -f docker-compose.postgres.yml up -d

echo ""
echo "⏳ 等待服务启动..."
sleep 10

echo ""
echo "🔍 检查权限状态..."
echo "数据目录权限："
ls -la data/

echo ""
echo "容器状态："
docker compose -f docker-compose.postgres.yml ps

echo ""
echo "✅ 权限修复完成！"
echo ""
echo "📋 如果还有权限问题，可以尝试："
echo "   1. 运行: sudo chown -R \$(whoami):\$(whoami) data/"
echo "   2. 或者: sudo chmod -R 755 data/"
echo "   3. 重新启动: docker compose -f docker-compose.postgres.yml restart"
echo ""
