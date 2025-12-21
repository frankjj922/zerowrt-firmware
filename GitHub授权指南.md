# Cursor AI 授权 GitHub 仓库指南

## 方法一：通过 Cursor GitHub App 授权（推荐）

### 步骤 1: 访问 Cursor 集成页面
1. 打开浏览器，访问：https://docs.cursor.com/en/github
2. 或者直接在 Cursor 中：
   - 点击左下角的设置图标
   - 选择 "Settings" → "Integrations" → "GitHub"

### 步骤 2: 连接 GitHub
1. 点击 "Connect" 或 "Connect to GitHub" 按钮
2. 会跳转到 GitHub 授权页面
3. 选择授权范围：
   - **所有仓库**（推荐，方便管理）
   - **仅特定仓库**（选择 `zerowrt-firmware` 仓库）

### 步骤 3: 确认授权
1. 点击 "Authorize Cursor" 或 "授权 Cursor"
2. 授权完成后，Cursor 就可以访问您的 GitHub 仓库了

---

## 方法二：使用 GitHub Personal Access Token (PAT)

### 步骤 1: 创建 Personal Access Token
1. 登录 GitHub，访问：https://github.com/settings/tokens
2. 点击 "Generate new token" → "Generate new token (classic)"
3. 填写 Token 信息：
   - **Note**: `Cursor AI Access`
   - **Expiration**: 选择过期时间（建议 90 天或 No expiration）
   - **Scopes**: 勾选以下权限：
     - ✅ `repo` (完整仓库访问权限)
     - ✅ `workflow` (GitHub Actions 工作流权限)
     - ✅ `write:packages` (如果需要发布包)
     - ✅ `read:org` (如果需要访问组织仓库)

4. 点击 "Generate token"
5. **重要**: 立即复制 Token（只显示一次！）

### 步骤 2: 在 Cursor 中配置 Token
1. 打开 Cursor
2. 按 `Cmd + ,` (Mac) 或 `Ctrl + ,` (Windows) 打开设置
3. 搜索 "GitHub" 或 "Git"
4. 找到 "GitHub: Personal Access Token" 设置项
5. 粘贴刚才复制的 Token
6. 保存设置

---

## 方法三：通过 Git 命令行配置（本地仓库）

如果您已经在本地克隆了仓库，可以通过 Git 配置：

### 步骤 1: 配置 Git 凭据
```bash
# 设置 GitHub 用户名
git config --global user.name "frankjj922"

# 设置 GitHub 邮箱
git config --global user.email "your-email@example.com"

# 配置凭据存储（Mac）
git config --global credential.helper osxkeychain

# 配置凭据存储（Linux）
git config --global credential.helper store
```

### 步骤 2: 使用 Token 克隆/推送
```bash
# 使用 Token 作为密码
git clone https://github.com/frankjj922/zerowrt-firmware.git
# 用户名: frankjj922
# 密码: 粘贴您的 Personal Access Token
```

---

## 方法四：在 GitHub Actions 中使用 Cursor（可选）

如果您想在 GitHub Actions 工作流中使用 Cursor AI：

### 步骤 1: 添加 Cursor API Key 到 GitHub Secrets
1. 访问：https://github.com/frankjj922/zerowrt-firmware/settings/secrets/actions
2. 点击 "New repository secret"
3. 名称：`CURSOR_API_KEY`
4. 值：您的 Cursor API Key（从 Cursor Dashboard 获取）
5. 点击 "Add secret"

### 步骤 2: 在工作流中使用
在 `.github/workflows/build.yml` 中添加：

```yaml
env:
  CURSOR_API_KEY: ${{ secrets.CURSOR_API_KEY }}
```

---

## 验证授权是否成功

### 在 Cursor 中验证：
1. 打开 Cursor
2. 使用 `Cmd + Shift + P` (Mac) 或 `Ctrl + Shift + P` (Windows)
3. 输入 "Git: Clone"
4. 尝试克隆您的仓库：`https://github.com/frankjj922/zerowrt-firmware.git`
5. 如果成功，说明授权成功

### 通过命令行验证：
```bash
# 测试 GitHub 连接
git ls-remote https://github.com/frankjj922/zerowrt-firmware.git

# 如果返回分支列表，说明连接成功
```

---

## 推荐配置

对于您的使用场景，推荐：

1. **主要方式**: 使用方法一（Cursor GitHub App），最简单直接
2. **备用方式**: 使用方法二（Personal Access Token），更灵活
3. **本地开发**: 使用方法三（Git 配置），适合命令行操作

---

## 常见问题

### Q: Cursor 中找不到 GitHub 集成选项？
A: 确保您使用的是最新版本的 Cursor。更新方法：
- Mac: `Cursor` → `Check for Updates`
- Windows: `Help` → `Check for Updates`

### Q: 授权后仍然无法访问仓库？
A: 检查以下几点：
1. 确认仓库是公开的，或者您的 Token 有访问权限
2. 检查 Token 是否过期
3. 重新授权 GitHub App

### Q: 如何撤销授权？
A: 
- GitHub App: https://github.com/settings/installations
- Personal Access Token: https://github.com/settings/tokens

---

## 安全建议

1. ✅ 使用最小权限原则（只授予必要的权限）
2. ✅ 定期轮换 Token（建议每 90 天）
3. ✅ 不要在代码中硬编码 Token
4. ✅ 使用 GitHub Secrets 存储敏感信息
5. ✅ 启用双因素认证（2FA）

---

## 下一步

授权完成后，您可以：

1. ✅ 在 Cursor 中直接查看和编辑 GitHub 仓库文件
2. ✅ 使用 Cursor AI 生成代码并自动提交到 GitHub
3. ✅ 触发 GitHub Actions 自动编译固件
4. ✅ 管理 Issues 和 Pull Requests

现在您可以开始使用 Cursor AI 来管理您的 ZeroWrt 固件编译项目了！

