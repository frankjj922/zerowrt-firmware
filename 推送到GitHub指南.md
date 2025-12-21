# 将文件推送到 GitHub 仓库指南

## 方法一：在 Cursor 中直接操作（最简单）

### 步骤 1: 在 Cursor 中打开终端
1. 在 Cursor 中按 `` Ctrl + ` `` (反引号) 打开终端
2. 或者点击菜单：`Terminal` → `New Terminal`

### 步骤 2: 执行以下命令

```bash
# 进入项目目录
cd "/Users/franklin/Downloads/路由插件/想"

# 初始化 Git 仓库
git init

# 添加远程仓库
git remote add origin https://github.com/frankjj922/zerowrt-firmware.git

# 拉取远程仓库内容（避免冲突）
git pull origin main --allow-unrelated-histories

# 添加所有文件
git add .

# 提交更改
git commit -m "Add ZeroWrt custom build configuration and workflows"

# 推送到 GitHub
git push -u origin main
```

如果遇到认证问题，GitHub 会提示您输入用户名和密码：
- **用户名**: `frankjj922`
- **密码**: 使用您的 **Personal Access Token**（不是 GitHub 密码）

---

## 方法二：使用 GitHub CLI（如果已安装）

```bash
cd "/Users/franklin/Downloads/路由插件/想"

# 初始化并推送
gh repo clone frankjj922/zerowrt-firmware temp-repo
cp -r .github config script README.md GitHub授权指南.md temp-repo/
cd temp-repo
git add .
git commit -m "Add ZeroWrt custom build configuration"
git push origin main
cd ..
rm -rf temp-repo
```

---

## 方法三：在 Cursor 中使用 Git 图形界面

### 步骤 1: 初始化仓库
1. 在 Cursor 左侧点击 "Source Control" 图标（或按 `Ctrl + Shift + G`）
2. 点击 "Initialize Repository" 按钮

### 步骤 2: 添加远程仓库
1. 点击 "..." 菜单
2. 选择 "Remote" → "Add Remote"
3. 名称：`origin`
4. URL：`https://github.com/frankjj922/zerowrt-firmware.git`

### 步骤 3: 提交和推送
1. 在 "Source Control" 面板中，点击 "+" 添加所有文件
2. 输入提交信息：`Add ZeroWrt custom build configuration`
3. 点击 "✓" 提交
4. 点击 "..." → "Push" → 选择 `origin` → `main`

---

## 如果遇到问题

### 问题 1: 认证失败
**解决方案**: 使用 Personal Access Token
1. 访问：https://github.com/settings/tokens
2. 创建新 Token（勾选 `repo` 权限）
3. 使用 Token 作为密码

### 问题 2: 分支不存在
**解决方案**: 先创建分支
```bash
git checkout -b main
git push -u origin main
```

### 问题 3: 远程仓库已有内容
**解决方案**: 合并历史
```bash
git pull origin main --allow-unrelated-histories
# 解决冲突后
git push origin main
```

---

## 验证推送成功

访问 https://github.com/frankjj922/zerowrt-firmware 查看：
- ✅ `.github/workflows/build.yml` 文件存在
- ✅ `config/` 目录存在
- ✅ `script/` 目录存在
- ✅ `README.md` 文件存在

---

## 推送后的下一步

1. ✅ 检查 GitHub Actions 是否自动触发编译
2. ✅ 在 GitHub 仓库的 "Actions" 标签页查看编译进度
3. ✅ 编译完成后下载固件

