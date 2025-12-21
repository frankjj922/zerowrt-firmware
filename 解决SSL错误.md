# 解决 Git SSL 连接错误

## 错误信息
```
fatal: unable to access 'https://github.com/frankjj922/zerowrt-firmware.git/': 
LibreSSL SSL_connect: SSL_ERROR_SYSCALL in connection to github.com:443
```

## 解决方案

### 方法一：使用 SSH 代替 HTTPS（推荐）

#### 步骤 1: 检查是否有 SSH 密钥
```bash
ls -la ~/.ssh
```

如果没有 `id_rsa` 或 `id_ed25519`，需要生成：

#### 步骤 2: 生成 SSH 密钥
```bash
ssh-keygen -t ed25519 -C "your_email@example.com"
# 按 Enter 使用默认路径
# 可以设置密码或直接按 Enter
```

#### 步骤 3: 添加 SSH 密钥到 ssh-agent
```bash
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
```

#### 步骤 4: 复制公钥
```bash
cat ~/.ssh/id_ed25519.pub
# 复制输出的内容
```

#### 步骤 5: 添加到 GitHub
1. 访问：https://github.com/settings/keys
2. 点击 "New SSH key"
3. 粘贴刚才复制的公钥
4. 点击 "Add SSH key"

#### 步骤 6: 更改远程仓库地址为 SSH
```bash
cd "/Users/franklin/Downloads/路由插件/想"
git remote remove origin
git remote add origin git@github.com:frankjj922/zerowrt-firmware.git
git fetch origin
```

---

### 方法二：配置 Git 使用系统证书（Mac）

```bash
# 更新 Git 配置
git config --global http.sslBackend openssl
git config --global http.sslCAInfo /usr/local/etc/openssl/cert.pem

# 或者使用系统证书
git config --global http.sslCAInfo /etc/ssl/cert.pem
```

---

### 方法三：临时禁用 SSL 验证（仅用于测试，不推荐）

```bash
git config --global http.sslVerify false
git fetch origin
# 完成后记得恢复
git config --global http.sslVerify true
```

---

### 方法四：检查代理设置

如果您使用代理：

```bash
# 设置代理（如果需要）
git config --global http.proxy http://proxy.example.com:8080
git config --global https.proxy https://proxy.example.com:8080

# 查看当前代理设置
git config --global --get http.proxy
git config --global --get https.proxy

# 取消代理（如果不需要）
git config --global --unset http.proxy
git config --global --unset https.proxy
```

---

### 方法五：使用 GitHub CLI（如果已安装）

```bash
# 安装 GitHub CLI（如果还没有）
brew install gh

# 登录 GitHub
gh auth login

# 然后使用 gh 命令克隆和推送
gh repo clone frankjj922/zerowrt-firmware
```

---

### 方法六：直接通过 GitHub Web 界面上传

如果以上方法都不行，可以直接在网页上上传：

1. 访问：https://github.com/frankjj922/zerowrt-firmware
2. 点击 "Add file" → "Upload files"
3. 拖拽文件上传

---

## 快速修复命令（推荐使用 SSH）

```bash
cd "/Users/franklin/Downloads/路由插件/想"

# 1. 检查是否有 SSH 密钥
if [ ! -f ~/.ssh/id_ed25519 ]; then
    echo "生成 SSH 密钥..."
    ssh-keygen -t ed25519 -C "frankjj922@github" -f ~/.ssh/id_ed25519 -N ""
    eval "$(ssh-agent -s)"
    ssh-add ~/.ssh/id_ed25519
    echo ""
    echo "请将以下公钥添加到 GitHub:"
    echo "https://github.com/settings/keys"
    echo ""
    cat ~/.ssh/id_ed25519.pub
    echo ""
    read -p "按 Enter 继续..."
fi

# 2. 测试 SSH 连接
ssh -T git@github.com

# 3. 更改远程地址为 SSH
git remote set-url origin git@github.com:frankjj922/zerowrt-firmware.git

# 4. 测试连接
git fetch origin
```

---

## 验证修复

执行以下命令验证：

```bash
# 测试 HTTPS 连接
git ls-remote https://github.com/frankjj922/zerowrt-firmware.git

# 或测试 SSH 连接
git ls-remote git@github.com:frankjj922/zerowrt-firmware.git
```

如果成功，会显示分支列表。

---

## 推荐方案

**最推荐使用方法一（SSH）**，因为：
- ✅ 更安全
- ✅ 不需要每次输入密码
- ✅ 不受 SSL 证书问题影响
- ✅ 速度更快

