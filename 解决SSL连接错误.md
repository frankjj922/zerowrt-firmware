# 🔧 解决 SSL 连接错误

## 错误信息
```
fatal: unable to access 'https://github.com/frankjj922/zerowrt-firmware.git/': 
LibreSSL SSL_connect: SSL_ERROR_SYSCALL in connection to github.com:443
```

---

## ✅ 解决方案（按优先级）

### 方案一：临时禁用 SSL 验证（最快）

```bash
cd "/Users/franklin/Downloads/路由插件/想"

# 临时禁用 SSL 验证
git config --global http.sslVerify false

# 推送
git push -u origin main

# 推送成功后，恢复 SSL 验证（重要！）
git config --global http.sslVerify true
```

---

### 方案二：使用 SSH 方式（如果之前配置过 SSH 密钥）

```bash
cd "/Users/franklin/Downloads/路由插件/想"

# 更改远程地址为 SSH
git remote set-url origin git@github.com:frankjj922/zerowrt-firmware.git

# 推送
git push -u origin main
```

如果 SSH 也不行，可能需要：
1. 检查 SSH 密钥是否已添加到 GitHub
2. 测试连接：`ssh -T git@github.com`

---

### 方案三：配置 Git 使用系统证书

```bash
# Mac 系统
git config --global http.sslCAInfo /etc/ssl/cert.pem

# 或者
git config --global http.sslBackend openssl

# 然后重试推送
git push -u origin main
```

---

### 方案四：检查并配置代理（如果您使用代理）

```bash
# 查看当前代理设置
git config --global --get http.proxy
git config --global --get https.proxy

# 如果使用代理，设置代理（替换为您的代理地址）
git config --global http.proxy http://127.0.0.1:7890
git config --global https.proxy http://127.0.0.1:7890

# 推送
git push -u origin main

# 如果不需要代理，取消设置
git config --global --unset http.proxy
git config --global --unset https.proxy
```

---

### 方案五：使用 GitHub Desktop（最简单，推荐⭐⭐⭐）

如果命令行都不行，使用图形界面：

1. **下载安装 GitHub Desktop**
   - https://desktop.github.com/

2. **打开 GitHub Desktop**
   - File → Add Local Repository
   - 选择：`/Users/franklin/Downloads/路由插件/想`
   - 点击 "Publish repository" 或 "Push origin"

GitHub Desktop 会自动处理网络问题。

---

### 方案六：检查网络连接

```bash
# 测试 GitHub 连接
ping github.com

# 测试 HTTPS 连接
curl -I https://github.com

# 如果都失败，可能是网络问题
```

---

## 🎯 推荐操作顺序

1. **先试方案一**（临时禁用 SSL）- 最快
2. **如果不行，试方案五**（GitHub Desktop）- 最可靠
3. **如果都不行，检查网络**（方案六）

---

## 💡 快速执行

在终端中执行：

```bash
cd "/Users/franklin/Downloads/路由插件/想"

# 临时禁用 SSL（仅用于推送）
git config --global http.sslVerify false

# 推送
git push -u origin main

# 如果成功，恢复 SSL
git config --global http.sslVerify true
```

---

## ⚠️ 注意事项

- 临时禁用 SSL 验证仅用于解决连接问题
- 推送成功后**务必恢复** SSL 验证
- 如果持续出现 SSL 错误，建议使用 GitHub Desktop

---

现在试试方案一吧！

