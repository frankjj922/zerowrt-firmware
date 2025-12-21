#!/bin/bash

# 检查 SSH 密钥的脚本

echo "🔍 检查 SSH 密钥..."
echo ""

# 检查 .ssh 目录
if [ ! -d ~/.ssh ]; then
    echo "❌ ~/.ssh 目录不存在，创建中..."
    mkdir -p ~/.ssh
    chmod 700 ~/.ssh
fi

echo "📁 ~/.ssh 目录中的文件："
ls -la ~/.ssh
echo ""

# 检查常见的密钥文件
if [ -f ~/.ssh/id_ed25519 ]; then
    echo "✅ 找到 id_ed25519 密钥"
    echo "公钥内容："
    cat ~/.ssh/id_ed25519.pub
elif [ -f ~/.ssh/id_rsa ]; then
    echo "✅ 找到 id_rsa 密钥"
    echo "公钥内容："
    cat ~/.ssh/id_rsa.pub
elif [ -f ~/.ssh/id_ecdsa ]; then
    echo "✅ 找到 id_ecdsa 密钥"
    echo "公钥内容："
    cat ~/.ssh/id_ecdsa.pub
else
    echo "❌ 没有找到 SSH 密钥"
    echo ""
    echo "🔑 生成新的 SSH 密钥..."
    ssh-keygen -t ed25519 -C "frankjj922@github" -f ~/.ssh/id_ed25519 -N ""
    echo ""
    echo "✅ 密钥生成完成！"
    echo "公钥内容："
    cat ~/.ssh/id_ed25519.pub
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📋 下一步："
echo "1. 复制上面的公钥（ssh-ed25519 开头的那一行）"
echo "2. 访问 https://github.com/settings/keys"
echo "3. 点击 'New SSH key'，粘贴公钥"
echo "4. 然后执行：ssh-add ~/.ssh/id_ed25519"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
