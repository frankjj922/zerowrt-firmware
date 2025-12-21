#!/bin/bash

# ZeroWrt 配置文件推送到 GitHub 脚本

set -e

echo "🚀 开始推送文件到 GitHub..."

# 进入项目目录
cd "$(dirname "$0")"

# 检查是否已经是 git 仓库
if [ ! -d ".git" ]; then
    echo "📦 初始化 Git 仓库..."
    git init
fi

# 检查远程仓库是否已添加
if ! git remote | grep -q "^origin$"; then
    echo "🔗 添加远程仓库..."
    git remote add origin https://github.com/frankjj922/zerowrt-firmware.git
else
    echo "✅ 远程仓库已存在"
    git remote set-url origin https://github.com/frankjj922/zerowrt-firmware.git
fi

# 拉取远程内容（如果存在）
echo "📥 拉取远程仓库内容..."
git fetch origin || echo "⚠️  远程仓库可能为空，继续..."

# 检查远程是否有 main 分支
if git ls-remote --heads origin main | grep -q main; then
    echo "🔄 合并远程分支（保留原项目内容）..."
    git pull origin main --allow-unrelated-histories || {
        echo "⚠️  自动合并失败，尝试手动合并..."
        git merge origin/main --no-edit || {
            echo "⚠️  合并冲突，但会保留双方文件"
            echo "ℹ️  如果有冲突，请手动解决后继续"
        }
    }
else
    echo "📝 创建 main 分支..."
    git checkout -b main 2>/dev/null || git checkout main
fi

# 添加上游仓库（原项目）用于未来同步
if ! git remote | grep -q "^upstream$"; then
    echo "🔗 添加上游仓库引用（用于未来同步）..."
    git remote add upstream https://github.com/zero-dream/zerowrt-firmware.git || echo "⚠️  上游仓库已存在"
fi

echo ""
echo "✅ 重要提示："
echo "   - 您的更改只会推送到您的 Fork (frankjj922/zerowrt-firmware)"
echo "   - 不会影响原项目 (zero-dream/zerowrt-firmware)"
echo "   - Fork 是完全独立的副本"
echo ""

# 添加所有文件
echo "➕ 添加文件..."
git add .

# 检查是否有更改
if git diff --staged --quiet; then
    echo "ℹ️  没有更改需要提交"
else
    # 提交更改
    echo "💾 提交更改..."
    git commit -m "Add ZeroWrt custom build configuration

- Add GitHub Actions workflow for automatic compilation
- Add network and system configuration files
- Add custom scripts and uci-defaults
- Configure all required packages and themes
- Set default theme to Argon
- Configure iStoreOS compatibility" || echo "⚠️  提交失败，可能没有更改"

    # 推送到 GitHub
    echo "🚀 推送到 GitHub..."
    git push -u origin main || {
        echo "❌ 推送失败！"
        echo ""
        echo "可能的原因："
        echo "1. 需要认证 - 请使用 Personal Access Token 作为密码"
        echo "2. 权限不足 - 检查 Token 是否有 repo 权限"
        echo ""
        echo "获取 Token: https://github.com/settings/tokens"
        exit 1
    }
fi

echo ""
echo "✅ 完成！"
echo ""
echo "📋 下一步："
echo "1. 访问 https://github.com/frankjj922/zerowrt-firmware 查看文件"
echo "2. 前往 Actions 标签页查看编译状态"
echo "3. 等待编译完成后下载固件"
echo ""

