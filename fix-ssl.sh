#!/bin/bash

# 修复 Git SSL 连接错误的脚本

set -e

echo "🔧 开始修复 Git SSL 连接问题..."
echo ""

cd "/Users/franklin/Downloads/路由插件/想"

# 方法 1: 尝试使用 SSH
echo "📋 方法 1: 配置使用 SSH（推荐）"
echo ""

# 检查是否有 SSH 密钥
if [ ! -f ~/.ssh/id_ed25519 ] && [ ! -f ~/.ssh/id_rsa ]; then
    echo "🔑 生成 SSH 密钥..."
    ssh-keygen -t ed25519 -C "frankjj922@github" -f ~/.ssh/id_ed25519 -N ""
    eval "$(ssh-agent -s)"
    ssh-add ~/.ssh/id_ed25519 2>/dev/null || ssh-add ~/.ssh/id_ed25519
    
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "📋 请将以下公钥添加到 GitHub:"
    echo "   访问: https://github.com/settings/keys"
    echo "   点击 'New SSH key'，然后粘贴下面的内容"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    cat ~/.ssh/id_ed25519.pub
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    read -p "添加完成后，按 Enter 继续..."
else
    echo "✅ SSH 密钥已存在"
    if [ -f ~/.ssh/id_ed25519 ]; then
        eval "$(ssh-agent -s)"
        ssh-add ~/.ssh/id_ed25519 2>/dev/null || true
    fi
fi

# 更改远程地址为 SSH
echo ""
echo "🔄 更改远程仓库地址为 SSH..."
if git remote get-url origin 2>/dev/null | grep -q "https"; then
    git remote set-url origin git@github.com:frankjj922/zerowrt-firmware.git
    echo "✅ 已更改为 SSH 地址"
else
    echo "ℹ️  远程地址已经是 SSH 或不存在"
    if ! git remote | grep -q "^origin$"; then
        git remote add origin git@github.com:frankjj922/zerowrt-firmware.git
    fi
fi

# 测试 SSH 连接
echo ""
echo "🧪 测试 SSH 连接..."
if ssh -T git@github.com 2>&1 | grep -q "successfully authenticated"; then
    echo "✅ SSH 连接成功！"
else
    echo "⚠️  SSH 连接测试失败，但继续尝试..."
fi

# 尝试拉取
echo ""
echo "📥 尝试拉取远程仓库..."
if git fetch origin 2>&1; then
    echo "✅ 连接成功！"
    echo ""
    echo "现在可以继续执行推送操作："
    echo "  git add ."
    echo "  git commit -m 'Add ZeroWrt custom build configuration'"
    echo "  git push -u origin main"
else
    echo ""
    echo "❌ 仍然无法连接"
    echo ""
    echo "尝试其他方法..."
    
    # 方法 2: 配置 Git SSL
    echo ""
    echo "📋 方法 2: 配置 Git SSL 设置..."
    git config --global http.sslVerify true
    git config --global http.postBuffer 524288000
    
    # 尝试使用 HTTPS 但禁用 SSL 验证（临时）
    echo ""
    echo "📋 方法 3: 临时禁用 SSL 验证（仅用于测试）..."
    read -p "是否尝试临时禁用 SSL 验证？(y/n) " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        git config --global http.sslVerify false
        git fetch origin
        echo "⚠️  请记得稍后恢复: git config --global http.sslVerify true"
    fi
fi

echo ""
echo "✅ 修复脚本执行完成！"
