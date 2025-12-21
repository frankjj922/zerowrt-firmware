# 🔧 解决 VPN/代理导致的 Git 推送问题

## 问题分析

错误信息：`LibreSSL SSL_connect: SSL_ERROR_SYSCALL in connection to github.com:443`

**很可能的原因：**
- ✅ VPN/代理拦截了 SSL 连接
- ✅ 代理服务器证书验证失败
- ✅ 代理配置不正确
- ✅ 网络连接被中断

---

## ✅ 解决方案（按优先级）

### 方案一：临时关闭 VPN/代理（最简单，推荐⭐⭐⭐）

1. **关闭您的科学上网插件**
2. **重新尝试推送**
3. **推送成功后，再开启 VPN**

**优点**：最简单直接，通常能立即解决问题

---

### 方案二：配置 Git 使用代理

如果您的 VPN/代理有本地代理端口（通常是 7890、1080、8080 等）：

#### 查找代理端口：
- **Clash**: 通常是 `7890`
- **V2Ray**: 通常是 `1080`
- **Shadowsocks**: 通常是 `1080`
- **其他**: 查看代理软件的设置

#### 配置 Git 使用代理：

```bash
cd "/Users/franklin/Downloads/路由插件/想"

# 设置 HTTP 代理（替换 7890 为您的实际端口）
git config --global http.proxy http://127.0.0.1:7890
git config --global https.proxy http://127.0.0.1:7890

# 推送
git push -u origin main

# 推送成功后，取消代理设置
git config --global --unset http.proxy
git config --global --unset https.proxy
```

---

### 方案三：只对 GitHub 使用代理

```bash
# 只对 GitHub 使用代理
git config --global http.https://github.com.proxy http://127.0.0.1:7890
git config --global https.https://github.com.proxy http://127.0.0.1:7890

# 推送
git push -u origin main
```

---

### 方案四：使用 SSH 代替 HTTPS（推荐⭐⭐）

SSH 通常不受 VPN/代理影响：

```bash
cd "/Users/franklin/Downloads/路由插件/想"

# 更改远程地址为 SSH
git remote set-url origin git@github.com:frankjj922/zerowrt-firmware.git

# 推送
git push -u origin main
```

**前提**：需要配置 SSH 密钥（之前已经配置过）

---

### 方案五：临时禁用 SSL 验证（不推荐，仅用于测试）

```bash
cd "/Users/franklin/Downloads/路由插件/想"

# 临时禁用 SSL 验证
git config --global http.sslVerify false

# 推送
git push -u origin main

# 推送成功后，恢复 SSL 验证
git config --global http.sslVerify true
```

---

## 🎯 推荐操作顺序

1. **先试方案一**（关闭 VPN）- 最简单
2. **如果不行，试方案四**（使用 SSH）- 最稳定
3. **如果还不行，试方案二**（配置代理）- 需要知道代理端口

---

## 📋 快速检查代理端口

### 在终端中检查：

```bash
# 检查常见的代理端口
netstat -an | grep LISTEN | grep -E "7890|1080|8080|8888"
```

### 查看代理软件设置：
- Clash: 设置 → 端口 → HTTP 端口
- V2Ray: 设置 → 本地监听端口
- Shadowsocks: 设置 → 本地端口

---

## 💡 最佳实践

**推荐组合方案：**

1. **日常使用 SSH**（不受 VPN 影响）
   ```bash
   git remote set-url origin git@github.com:frankjj922/zerowrt-firmware.git
   ```

2. **如果 SSH 不行，临时关闭 VPN 推送**

3. **如果需要一直使用 VPN，配置 Git 代理**

---

## 🔍 诊断命令

检查当前 Git 配置：

```bash
# 查看所有 Git 配置
git config --global --list

# 查看代理设置
git config --global --get http.proxy
git config --global --get https.proxy

# 查看 SSL 设置
git config --global --get http.sslVerify
```

---

## ✅ 现在试试

**最快的方法：**

1. **关闭科学上网插件**
2. **在 GitHub Desktop 中点击 "Push origin"**
3. **推送成功后，再开启 VPN**

或者：

```bash
cd "/Users/franklin/Downloads/路由插件/想"
git remote set-url origin git@github.com:frankjj922/zerowrt-firmware.git
git push -u origin main
```

---

试试关闭 VPN 后推送，应该就能成功了！🚀

