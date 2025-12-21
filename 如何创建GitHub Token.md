# 🔑 如何创建和使用 GitHub Personal Access Token

## 为什么需要 Token？

从 2021 年 8 月开始，GitHub 不再允许使用密码进行 Git 操作，必须使用 **Personal Access Token (PAT)**。

---

## 📋 创建 Token 的步骤

### 步骤 1: 访问 Token 设置页面

1. 打开浏览器，访问：https://github.com/settings/tokens
2. 或者：
   - 点击 GitHub 右上角头像
   - 选择 "Settings"
   - 左侧菜单选择 "Developer settings"
   - 选择 "Personal access tokens" → "Tokens (classic)"

### 步骤 2: 创建新 Token

1. 点击 "Generate new token" → "Generate new token (classic)"
2. 填写信息：
   - **Note（备注）**: `Cursor AI - ZeroWrt Project`（任意名称，方便识别）
   - **Expiration（过期时间）**: 
     - 选择 "90 days"（推荐）
     - 或 "No expiration"（永不过期，但不太安全）

### 步骤 3: 选择权限（Scopes）

**必须勾选的权限：**
- ✅ **`repo`** - 完整仓库访问权限
  - 包括所有子权限：
    - repo:status
    - repo_deployment
    - public_repo
    - repo:invite
    - security_events

**可选但推荐的权限：**
- ✅ **`workflow`** - GitHub Actions 工作流权限（如果需要触发 Actions）

### 步骤 4: 生成并复制 Token

1. 滚动到页面底部
2. 点击绿色的 "Generate token" 按钮
3. **重要**：立即复制 Token（只显示一次！）
   - Token 格式类似：`ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx`
   - 如果关闭页面，Token 就看不到了，需要重新生成

---

## 🔐 使用 Token

### 方法一：在 Git 命令中使用

当 Git 提示输入密码时：
- **Username**: `frankjj922`
- **Password**: 粘贴您的 Token（不是 GitHub 密码）

```bash
git push -u origin main
# Username: frankjj922
# Password: ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx  ← 粘贴 Token
```

### 方法二：在 URL 中使用（不推荐，不安全）

```bash
git remote set-url origin https://frankjj922:YOUR_TOKEN@github.com/frankjj922/zerowrt-firmware.git
```

⚠️ **注意**：这种方法会将 Token 保存在 Git 配置中，不太安全。

### 方法三：使用 Git Credential Helper（推荐）

```bash
# Mac 使用 Keychain
git config --global credential.helper osxkeychain

# 然后正常推送，输入一次 Token 后会自动保存
git push -u origin main
```

---

## 🔄 如果 Token 丢失了

如果忘记复制 Token：
1. 访问：https://github.com/settings/tokens
2. 找到对应的 Token
3. 点击 "Regenerate token" 重新生成
4. 复制新 Token

---

## ⚠️ 安全提示

1. **不要分享 Token**：Token 就像密码，不要分享给他人
2. **不要在代码中硬编码 Token**：不要将 Token 写入代码或配置文件
3. **定期轮换**：建议每 90 天更换一次 Token
4. **使用最小权限**：只授予必要的权限
5. **如果泄露立即撤销**：
   - 访问：https://github.com/settings/tokens
   - 找到对应的 Token
   - 点击 "Revoke" 撤销

---

## 📝 快速创建链接

**直接访问创建页面：**
https://github.com/settings/tokens/new

**设置页面：**
https://github.com/settings/tokens

---

## 🎯 现在就开始创建

1. 点击链接：https://github.com/settings/tokens/new
2. Note: `ZeroWrt Project`
3. 勾选 `repo` 和 `workflow`
4. 点击 "Generate token"
5. 复制 Token
6. 在终端中使用 Token 作为密码

---

## ✅ 创建完成后

创建好 Token 后，在终端执行：

```bash
cd "/Users/franklin/Downloads/路由插件/想"
git push -u origin main
```

当提示输入密码时，粘贴您的 Token 即可！

---

需要我帮您创建吗？或者您已经创建好了？
