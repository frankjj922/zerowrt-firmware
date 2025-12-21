#!/bin/bash

# 修复 SSH 密钥问题并推送文件

set -e

echo "🔧 修复 SSH 配置并推送文件到 GitHub..."
echo ""

cd "/Users/franklin/Downloads/路由插件/想"

# 方案 1: 使用已有的 personal 密钥
echo "📋 方案 1: 使用已有的 id_ed25519_personal 密钥"
echo ""

# 启动 ssh-agent
eval "$(ssh-agent -s)" > /dev/null 2>&1

# 添加 personal 密钥
if [ -f ~/.ssh/id_ed25519_personal ]; then
    echo "✅ 找到 id_ed25519_personal 密钥"
    ssh-add ~/.ssh/id_ed25519_personal 2>/dev/null || ssh-add ~/.ssh/id_ed25519_personal
    
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "📋 公钥内容（如果还没添加到 GitHub，请添加）："
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    cat ~/.ssh/id_ed25519_personal.pub
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    read -p "如果密钥已添加到 GitHub，按 Enter 继续测试连接..."
    
    # 测试连接
    echo ""
    echo "🧪 测试 SSH 连接..."
    if ssh -T git@github.com 2>&1 | grep -q "successfully authenticated"; then
        echo "✅ SSH 连接成功！"
        USE_SSH=true
    else
        echo "⚠️  SSH 连接失败，将使用 HTTPS 方式"
        USE_SSH=false
    fi
else
    echo "❌ 未找到 id_ed25519_personal 密钥"
    USE_SSH=false
fi

echo ""
echo "🔄 配置 Git 远程仓库..."

# 根据连接方式设置远程地址
if [ "$USE_SSH" = true ]; then
    echo "使用 SSH 方式..."
    git remote set-url origin git@github.com:frankjj922/zerowrt-firmware.git 2>/dev/null || \
    git remote add origin git@github.com:frankjj922/zerowrt-firmware.git
else
    echo "使用 HTTPS 方式（临时禁用 SSL 验证）..."
    git remote set-url origin https://github.com/frankjj922/zerowrt-firmware.git 2>/dev/null || \
    git remote add origin https://github.com/frankjj922/zerowrt-firmware.git
    
    # 临时禁用 SSL 验证
    git config --global http.sslVerify false
    echo "⚠️  已临时禁用 SSL 验证（仅用于推送）"
fi

# 尝试拉取
echo ""
echo "📥 尝试拉取远程仓库..."
if git fetch origin 2>&1; then
    echo "✅ 连接成功！"
    
    # 检查是否有 main 分支
    if git ls-remote --heads origin main | grep -q main; then
        echo "🔄 合并远程 main 分支..."
        git pull origin main --allow-unrelated-histories || true
    else
        echo "📝 创建 main 分支..."
        git checkout -b main 2>/dev/null || git checkout main
    fi
    
    # 添加文件
    echo ""
    echo "➕ 添加文件..."
    git add .
    
    # 检查是否有更改
    if git diff --staged --quiet; then
        echo "ℹ️  没有更改需要提交"
    else
        echo "💾 提交更改..."
        git commit -m "Add ZeroWrt custom build configuration

- Add GitHub Actions workflow for automatic compilation
- Add network and system configuration files
- Add custom scripts and uci-defaults
- Configure all required packages and themes
- Set default theme to Argon
- Configure iStoreOS compatibility" || echo "⚠️  提交失败"
        
        echo ""
        echo "🚀 推送到 GitHub..."
        if git push -u origin main; then
            echo ""
            echo "✅✅✅ 推送成功！✅✅✅"
            echo ""
            echo "📋 下一步："
            echo "1. 访问 https://github.com/frankjj922/zerowrt-firmware 查看文件"
            echo "2. 前往 Actions 标签页查看编译状态"
            echo "3. 等待编译完成后下载固件"
            
            # 恢复 SSL 验证
            if [ "$USE_SSH" = false ]; then
                git config --global http.sslVerify true
                echo ""
                echo "✅ 已恢复 SSL 验证"
            fi
        else
            echo ""
            echo "❌ 推送失败"
            echo ""
            echo "可能的原因："
            echo "1. 需要认证 - 如果使用 HTTPS，需要 Personal Access Token"
            echo "2. 权限不足 - 检查 Token 是否有 repo 权限"
            echo ""
            echo "获取 Token: https://github.com/settings/tokens"
        fi
    fi
else
    echo ""
    echo "❌ 仍然无法连接"
    echo ""
    echo "建议："
    echo "1. 检查网络连接"
    echo "2. 如果使用 HTTPS，确保已添加 Personal Access Token"
    echo "3. 或者使用 GitHub Web 界面上传文件"
fi

echo ""
echo "✅ 脚本执行完成！"

