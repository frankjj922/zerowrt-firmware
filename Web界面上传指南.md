# 🌐 GitHub Web 界面上传指南 - 隐藏文件解决方案

## 问题：隐藏文件夹无法直接上传

`.github` 文件夹是隐藏文件夹（以 `.` 开头），无法通过拖拽上传。需要在 GitHub Web 界面手动创建。

---

## ✅ 解决方案：手动创建文件（GitHub 会自动创建目录）

### 步骤 1: 创建 GitHub Actions 工作流文件

1. 访问：https://github.com/frankjj922/zerowrt-firmware
2. 点击 "Add file" → "Create new file"
3. **重要**：在文件名输入框中输入完整路径：
   ```
   .github/workflows/build.yml
   ```
   （GitHub 会自动创建 `.github` 和 `workflows` 目录）
4. 复制下面 `build.yml` 的完整内容并粘贴到编辑器中
5. 点击 "Commit new file"

---

## 📋 需要创建的所有文件

### 1. GitHub Actions 工作流
**路径**：`.github/workflows/build.yml`
**内容**：见下方完整内容

### 2. 网络配置文件
**路径**：`config/etc/config/network`
**内容**：见下方

### 3. DHCP 配置文件
**路径**：`config/etc/config/dhcp`
**内容**：见下方

### 4. 系统配置文件
**路径**：`config/etc/config/system`
**内容**：见下方

### 5. LuCI 配置文件
**路径**：`config/etc/config/luci`
**内容**：见下方

### 6. Web 服务器配置
**路径**：`config/etc/config/uhttpd`
**内容**：见下方

### 7. 首次启动脚本
**路径**：`config/etc/uci-defaults/99-custom-config`
**内容**：见下方

### 8. 配置应用脚本
**路径**：`script/apply-config.sh`
**内容**：见下方

---

## 📝 文件内容（复制粘贴用）

### 文件 1: `.github/workflows/build.yml`

```yaml
name: Build ZeroWrt

on:
  push:
    branches: [ main, master ]
  pull_request:
    branches: [ main, master ]
  workflow_dispatch:  # 允许手动触发

jobs:
  build:
    runs-on: ubuntu-22.04
    timeout-minutes: 360  # 6小时超时（编译可能需要更长时间）
    
    steps:
    - name: Checkout code
      uses: actions/checkout@v4
      with:
        ref: ZeroWrt-Firmware-IPQ60XX-WiFi_NO-251221042559  # 使用指定分支
        submodules: recursive
    
    - name: Setup Build Environment
      run: |
        sudo apt-get update
        sudo apt-get install -y build-essential ccache ecj fastjar file g++ gawk gettext git \
          java-propose-classpath libelf-dev libncurses5-dev libncursesw5-dev libssl-dev \
          python3 python3-dev python3-distutils python3-setuptools rsync subversion \
          swig time xsltproc zlib1g-dev
    
    - name: Setup ccache
      uses: actions/cache@v3
      with:
        path: ~/.ccache
        key: ${{ runner.os }}-ccache-${{ github.sha }}
        restore-keys: |
          ${{ runner.os }}-ccache-
    
    - name: Update Feeds
      run: |
        ./scripts/feeds update -a
        ./scripts/feeds install -a
    
    - name: Apply Custom Configuration
      run: |
        # 创建配置目录
        mkdir -p files/etc/config
        mkdir -p files/etc/uci-defaults
        mkdir -p files/etc/nginx/conf.d
        
        # 应用配置文件（如果存在）
        if [ -d "config" ]; then
          cp -r config/* files/
        fi
        
        # 运行配置脚本（如果存在）
        if [ -f "script/apply-config.sh" ]; then
          chmod +x script/apply-config.sh
          ./script/apply-config.sh
        fi
    
    - name: Configure Build
      run: |
        make defconfig
        
        # 基础工具
        echo "CONFIG_PACKAGE_naiveproxy=y" >> .config
        echo "CONFIG_PACKAGE_btop=y" >> .config
        echo "CONFIG_PACKAGE_automount=y" >> .config
        
        # LuCI 主题
        echo "CONFIG_PACKAGE_luci-theme-openmptcprouter=y" >> .config
        echo "CONFIG_PACKAGE_luci-theme-routerich=y" >> .config
        echo "CONFIG_PACKAGE_luci-theme-spectra=y" >> .config
        echo "CONFIG_PACKAGE_luci-theme-openwrt=y" >> .config
        echo "CONFIG_PACKAGE_luci-theme-material3=y" >> .config
        echo "CONFIG_PACKAGE_luci-theme-alpha=y" >> .config
        echo "CONFIG_PACKAGE_luci-theme-argon=y" >> .config
        echo "CONFIG_PACKAGE_luci-theme-edge=y" >> .config
        echo "CONFIG_PACKAGE_luci-theme-design=y" >> .config
        echo "CONFIG_PACKAGE_luci-theme-teleofis=y" >> .config
        echo "CONFIG_PACKAGE_luci-theme-lightblue=y" >> .config
        echo "CONFIG_PACKAGE_luci-theme-openwrt-2020=y" >> .config
        
        # iStoreOS 主题
        echo "CONFIG_PACKAGE_luci-theme-opencash=y" >> .config
        
        # LuCI 应用
        echo "CONFIG_PACKAGE_luci-app-parentcontrol=y" >> .config
        echo "CONFIG_PACKAGE_luci-app-netdata=y" >> .config
        echo "CONFIG_PACKAGE_luci-app-subconverter=y" >> .config
        echo "CONFIG_PACKAGE_luci-app-store=y" >> .config
        echo "CONFIG_PACKAGE_luci-app-ddns-go=y" >> .config
        
        # 互联网工具
        echo "CONFIG_PACKAGE_luci-app-passwall=y" >> .config
        echo "CONFIG_PACKAGE_luci-app-homeproxy=y" >> .config
        echo "CONFIG_PACKAGE_luci-app-openclash=y" >> .config
        
        # Netdata
        echo "CONFIG_PACKAGE_netdata=y" >> .config
        
        # Nginx Web服务器
        echo "CONFIG_PACKAGE_nginx=y" >> .config
        echo "CONFIG_PACKAGE_nginx-mod-luci=y" >> .config
        
        # IPv6 支持
        echo "CONFIG_PACKAGE_ipv6helper=y" >> .config
        
        make defconfig
    
    - name: Download Dependencies
      run: make download -j$(nproc)
    
    - name: Build Firmware
      run: make -j$(nproc) V=s
      env:
        CCACHE_DIR: ~/.ccache
    
    - name: Upload Artifacts
      uses: actions/upload-artifact@v3
      with:
        name: firmware
        path: bin/targets/**/*.bin
        retention-days: 7
    
    - name: Upload Packages
      uses: actions/upload-artifact@v3
      with:
        name: packages
        path: bin/packages/**
        retention-days: 7
```

---

### 文件 2: `config/etc/config/network`

```
config interface 'loopback'
	option device 'lo'
	option proto 'static'
	option ipaddr '127.0.0.1'
	option netmask '255.0.0.0'

config globals 'globals'
	option ula_prefix 'fd00::/48'

config interface 'lan'
	option device 'br-lan'
	option proto 'static'
	option ipaddr '192.168.50.201'
	option netmask '255.255.255.0'
	option gateway '192.168.50.1'
	option ip6assign '60'
	option dns '192.168.50.1'

config interface 'wan'
	option device 'eth0'
	option proto 'dhcp'

config interface 'wan6'
	option device 'eth0'
	option proto 'dhcpv6'
```

---

### 文件 3: `config/etc/config/dhcp`

```
config dnsmasq
	option domainneeded '1'
	option boguspriv '1'
	option filterwin2k '0'
	option localise_queries '1'
	option rebind_protection '1'
	option rebind_localhost '1'
	option local '/lan/'
	option domain 'lan'
	option expandhosts '1'
	option nonegcache '0'
	option authoritative '1'
	option readethers '1'
	option leasefile '/tmp/dhcp.leases'
	option resolvfile '/tmp/resolv.conf.d/resolv.conf.auto'
	option nonwildcard '1'
	option localservice '1'
	option ednspacket_max '1232'

config dhcp 'lan'
	option interface 'lan'
	option ignore '1'  # 关闭 DHCP 服务器
	option dhcpv6 'server'
	option ra 'server'
	option ra_management '1'
	option ra_default '1'

config dhcp 'wan'
	option interface 'wan'
	option ignore '1'
```

---

### 文件 4: `config/etc/config/system`

```
config system
	option hostname 'zerowrt'
	option timezone 'CST-8'
	option ttylogin '0'
	option log_size '64'
	option urandom_seed '0'
	option log_proto 'udp'
	option conloglevel '8'
	option cronloglevel '8'
	option zonename 'Asia/Shanghai'

config timeserver 'ntp'
	list server '0.openwrt.pool.ntp.org'
	list server '1.openwrt.pool.ntp.org'
	list server '2.openwrt.pool.ntp.org'
	list server '3.openwrt.pool.ntp.org'
	option enabled '1'
	option enable_server '0'
```

---

### 文件 5: `config/etc/config/luci`

```
config core 'main'
	option resourcebase '/luci-static/resources'
	option mediaurlbase '/luci-static/openwrt.org'

config internal 'themes'
	option Bootstrap '/luci-static/bootstrap'
	option Argon '/luci-static/argon'
	option OpenWrt '/luci-static/openwrt.org'

config internal 'sauth'
	option sessionpath '/tmp/luci-sessions'
	option sessiontime '3600'

config internal 'ccache'
	option enable '1'

config internal 'languages'
	option zh_cn '简体中文'

# 设置默认主题为 Argon
config internal 'themes'
	option default 'argon'
```

---

### 文件 6: `config/etc/config/uhttpd`

```
config uhttpd 'main'
	list listen_http '0.0.0.0:80'
	list listen_http '[::]:80'
	list listen_https '0.0.0.0:443'
	list listen_https '[::]:443'
	option redirect_https '0'
	option home '/www'
	option rfc1918_filter '0'
	option max_requests '3'
	option max_connections '100'
	option cert '/etc/uhttpd.crt'
	option key '/etc/uhttpd.key'
	option cgi_prefix '/cgi-bin'
	list lua_prefix '/cgi-bin/luci=/usr/lib/lua/luci/sgi/uhttpd.lua'
	list lua_prefix '/=/usr/lib/lua/luci/sgi/uhttpd.lua'
	option script_timeout '60'
	option network_timeout '30'
	option http_keepalive '20'
	option tcp_keepalive '1'
	option ubus_prefix '/ubus'
	option realm 'OpenWrt'
```

---

### 文件 7: `config/etc/uci-defaults/99-custom-config`

```
#!/bin/sh

# 设置默认密码为 password
echo -e "password\npassword" | passwd root

# 设置主机名
uci set system.@system[0].hostname='zerowrt'
uci commit system

# 配置网络接口
uci set network.lan.ipaddr='192.168.50.201'
uci set network.lan.netmask='255.255.255.0'
uci set network.lan.gateway='192.168.50.1'
uci commit network

# 关闭 DHCP 服务器
uci set dhcp.lan.ignore='1'
uci commit dhcp

# 设置默认主题为 Argon
uci set luci.main.mediaurlbase='/luci-static/argon'
uci commit luci

# 配置 Nginx（如果使用）
if [ -f /etc/config/nginx ]; then
    uci set nginx.global.uci_enable='true'
    uci commit nginx
fi

# 配置 iStoreOS 伪装
# 创建 iStoreOS 标识文件
mkdir -p /usr/lib/opkg/info
echo "iStoreOS" > /usr/lib/opkg/info/istoreos.control 2>/dev/null || true

# 设置快捷访问地址（通过 hosts 文件）
echo "127.0.0.1 pdwrt.com" >> /etc/hosts

# 启用 IPv6
uci set network.globals.ula_prefix='fd00::/48'
uci commit network

# 重启网络服务
/etc/init.d/network restart

exit 0
```

---

### 文件 8: `script/apply-config.sh`

```
#!/bin/bash

# ZeroWrt 自定义配置应用脚本
# 此脚本在编译时应用所有自定义配置

set -e

echo "开始应用自定义配置..."

# 确保在正确的目录
cd "$(dirname "$0")/.." || exit 1

# 创建必要的目录结构
mkdir -p files/etc/config
mkdir -p files/etc/uci-defaults
mkdir -p files/etc/nginx/conf.d
mkdir -p files/usr/lib/opkg/info

# 复制配置文件
if [ -d "config" ]; then
    echo "复制配置文件..."
    cp -r config/* files/ 2>/dev/null || true
fi

# 确保 uci-defaults 脚本可执行
chmod +x files/etc/uci-defaults/*.sh 2>/dev/null || true

# 创建 iStoreOS 伪装文件
echo "创建 iStoreOS 伪装..."
mkdir -p files/usr/lib/opkg/info
cat > files/usr/lib/opkg/info/istoreos.control << 'EOF'
Package: istoreos
Version: 1.0
Description: iStoreOS compatibility layer
EOF

# 配置 Nginx（如果使用）
if [ -f "files/etc/config/nginx" ]; then
    echo "配置 Nginx..."
    # Nginx 配置已在 config 目录中
fi

# 设置默认主题
if [ -f "files/etc/config/luci" ]; then
    echo "配置默认主题为 Argon..."
    # LuCI 配置已在 config 目录中
fi

echo "配置应用完成！"
```

---

## 🎯 快速操作步骤

1. **访问仓库**：https://github.com/frankjj922/zerowrt-firmware
2. **创建第一个文件**：点击 "Add file" → "Create new file"
3. **输入路径**：`.github/workflows/build.yml`
4. **粘贴内容**：复制上面的 build.yml 内容
5. **提交**：点击 "Commit new file"
6. **重复步骤 2-5**：创建其他 7 个文件

---

## ✅ 验证

创建完所有文件后：
1. 访问：https://github.com/frankjj922/zerowrt-firmware
2. 确认所有文件都存在
3. 前往 Actions 标签页查看自动编译

---

## 💡 提示

- 创建文件时，GitHub 会自动创建目录结构
- 路径要完整，例如：`config/etc/config/network`
- 每个文件创建后都会自动提交
- 可以一次性创建多个文件，使用 "Add file" → "Create new file" 多次

现在开始创建文件吧！🚀
