# ZeroWrt 自定义固件编译配置

## 项目信息

- **GitHub 仓库**: https://github.com/frankjj922/zerowrt-firmware
- **编译分支**: `ZeroWrt-Firmware-IPQ60XX-WiFi_NO-251221042559`
- **固件类型**: ZeroWrt (基于 ImmortalWrt)

## 已添加的软件包

### 基础工具
- `naiveproxy` - NaiveProxy 代理工具
- `btop` - 系统监控工具
- `automount` - 自动挂载工具

### LuCI 主题
- `luci-theme-openmptcprouter`
- `luci-theme-routerich`
- `luci-theme-spectra`
- `luci-theme-openwrt`
- `luci-theme-material3`
- `luci-theme-alpha`
- `luci-theme-argon` (默认主题)
- `luci-theme-edge`
- `luci-theme-design`
- `luci-theme-teleofis`
- `luci-theme-lightblue`
- `luci-theme-openwrt-2020`
- `luci-theme-opencash` (iStoreOS 主题)

### LuCI 应用
- `luci-app-parentcontrol` - 家长控制
- `luci-app-netdata` - Netdata 监控界面
- `luci-app-subconverter` - 订阅转换器
- `luci-app-store` - iStore 应用商店
- `luci-app-ddns-go` - DDNS-Go 动态域名

### 互联网工具
- `luci-app-passwall` - PassWall
- `luci-app-homeproxy` - HomeProxy
- `luci-app-openclash` - OpenClash

### 其他
- `netdata` - 系统监控
- `nginx` - Web 服务器

## 系统配置

### 网络设置
- **后台地址**: `192.168.50.201`
- **子网掩码**: `255.255.255.0`
- **IPv4 网关**: `192.168.50.1`
- **IPv6**: 已启用
- **DHCP 服务器**: 已关闭

### 系统设置
- **主机名**: `zerowrt`
- **后台密码**: `password`
- **默认主题**: Argon
- **Web 服务器**: Nginx
- **后台快捷访问地址**: `pdwrt.com`

### iStoreOS 兼容
- 已配置 iStoreOS 伪装
- 支持 iStore 应用商店

## 文件结构

```
.
├── .github/
│   └── workflows/
│       └── build.yml          # GitHub Actions 工作流
├── config/                     # 配置文件目录
│   └── etc/
│       ├── config/            # UCI 配置文件
│       │   ├── network        # 网络配置
│       │   ├── dhcp           # DHCP 配置
│       │   ├── system         # 系统配置
│       │   ├── luci           # LuCI 配置
│       │   └── uhttpd         # Web 服务器配置
│       └── uci-defaults/      # 首次启动配置脚本
│           └── 99-custom-config
└── script/                     # 脚本目录
    └── apply-config.sh         # 配置应用脚本
```

## 使用方法

### 1. 推送代码到 GitHub

将配置文件推送到您的 GitHub 仓库：

```bash
git add .
git commit -m "Add custom ZeroWrt build configuration"
git push origin main
```

### 2. 触发编译

编译会在以下情况自动触发：
- 推送到 `main` 或 `master` 分支
- 创建 Pull Request
- 手动触发（在 GitHub Actions 页面点击 "Run workflow"）

### 3. 下载固件

编译完成后：
1. 前往 GitHub Actions 页面
2. 选择最新的工作流运行
3. 在 "Artifacts" 部分下载固件文件

## 注意事项

1. **编译时间**: 首次编译可能需要 2-6 小时，取决于 GitHub Actions 的负载
2. **固件大小**: 由于添加了大量软件包，固件可能较大
3. **软件包可用性**: 某些软件包可能在某些架构上不可用，编译时会自动跳过
4. **配置覆盖**: 配置文件会在首次启动时应用，确保固件刷入后重启一次

## 参考资源

- ZeroWrt 官方仓库: https://github.com/zero-dream/zerowrt-firmware
- ImmortalWrt 文档: https://immortalwrt.org/docs/guide-build
- OpenWrt 编译文档: https://openwrt.org/docs/guide-developer/build-system/start

## 更新日志

- 2024-12-21: 初始配置，添加所有软件包和主题
- 配置网络参数和系统设置
- 添加 iStoreOS 兼容性支持

