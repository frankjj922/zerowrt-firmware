#!/bin/bash

# ZeroWrt 自定义配置应用脚本
# 此脚本在编译时应用所有自定义配置

set -e

echo "开始应用自定义配置..."

# 确保在正确的目录
cd "$(dirname "$0")/.." || exit 1

# 创建必要的目录结构
mkdir -p files/etc/config
mkdir -p files/etc/uci-defaults
mkdir -p files/etc/nginx/conf.d
mkdir -p files/usr/lib/opkg/info

# 复制配置文件
if [ -d "config" ]; then
    echo "复制配置文件..."
    cp -r config/* files/ 2>/dev/null || true
fi

# 确保 uci-defaults 脚本可执行
chmod +x files/etc/uci-defaults/*.sh 2>/dev/null || true

# 创建 iStoreOS 伪装文件
echo "创建 iStoreOS 伪装..."
mkdir -p files/usr/lib/opkg/info
cat > files/usr/lib/opkg/info/istoreos.control << 'EOF'
Package: istoreos
Version: 1.0
Description: iStoreOS compatibility layer
EOF

# 配置 Nginx（如果使用）
if [ -f "files/etc/config/nginx" ]; then
    echo "配置 Nginx..."
    # Nginx 配置已在 config 目录中
fi

# 设置默认主题
if [ -f "files/etc/config/luci" ]; then
    echo "配置默认主题为 Argon..."
    # LuCI 配置已在 config 目录中
fi

echo "配置应用完成！"

