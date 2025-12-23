#!/bin/bash

# --------------------------------------------------

cd "$WRT_MainPath/"

echo '--------------------------------------------------'
echo 'FirmwareSettings.sh'
echo "WRT_MainPath: $WRT_MainPath"
echo ''

# --------------------------------------------------

WRT_HOST=${WRT_HOST:-zerowrt}
THEME_DIR=$(find ./feeds ./package -maxdepth 4 -type d -iname "luci-theme-$WRT_THEME" 2>/dev/null | head -n1)

collections_files=$(find ./feeds/luci/collections/ -type f -name "Makefile")
[[ -n "$collections_files" && -n "$THEME_DIR" ]] && sed -i "s/luci-theme-bootstrap/luci-theme-$WRT_THEME/g" $collections_files
flash_js_files=$(find ./feeds/luci/modules/luci-mod-system/ -type f -name "flash.js")
[[ -n "$flash_js_files" ]] && sed -i "s/192\.168\.[0-9]*\.[0-9]*/$WRT_IP/g" $flash_js_files
system_js_files=$(find ./feeds/luci/modules/luci-mod-status/ -type f -name "10_system.js")
[[ -n "$system_js_files" ]] && sed -i "s/(\(luciversion || ''\))/(\1) + (' \/ ZeroWrt-$ZD_DATE')/g" $system_js_files
distfeeds_conf="./openwrt/files/etc/opkg/distfeeds.conf"
if [[ -f "$distfeeds_conf" ]]; then
  if [[ "$WRT_DISTFEEDS_MIRROR" == "cn" ]]; then
    sed -i "s#https://downloads.immortalwrt.org#https://mirrors.immortalwrt.org#g" "$distfeeds_conf"
  elif [[ -n "$WRT_DISTFEEDS_HOST" ]]; then
    sed -i "s#https://downloads.immortalwrt.org#${WRT_DISTFEEDS_HOST}#g" "$distfeeds_conf"
  fi
fi

WIFI_SH=$(find ./target/linux/{mediatek/filogic,qualcommax}/base-files/etc/uci-defaults/ -type f -name "*set-wireless.sh" 2>/dev/null)
WIFI_UC="./package/network/config/wifi-scripts/files/lib/wifi/mac80211.uc"
if [[ -f "$WIFI_SH" ]]; then
	# 修改 WIFI 名称
	sed -i "s/BASE_SSID='.*'/BASE_SSID='$WRT_SSID'/g" $WIFI_SH
	# 修改 WIFI 密码
	sed -i "s/BASE_WORD='.*'/BASE_WORD='$WRT_WORD'/g" $WIFI_SH
elif [[ -f "$WIFI_UC" ]]; then
	# 修改 WIFI 名称
	sed -i "s/ssid='.*'/ssid='$WRT_SSID'/g" $WIFI_UC
	# 修改 WIFI 密码
	sed -i "s/key='.*'/key='$WRT_WORD'/g" $WIFI_UC
	# 修改 WIFI 地区
	sed -i "s/country='.*'/country='CN'/g" $WIFI_UC
	# 修改 WIFI 加密
	sed -i "s/encryption='.*'/encryption='psk2+ccmp'/g" $WIFI_UC
fi

CFG_FILE="./package/base-files/files/bin/config_generate"
# 修改默认 IP 地址
sed -i "s/192\.168\.[0-9]*\.[0-9]*/$WRT_IP/g" $CFG_FILE
# 修改默认主机名
sed -i "s/hostname='.*'/hostname='$WRT_HOST'/g" $CFG_FILE

# 允许 Dropbear 接受远程访问
sed -i "s/option DirectInterface '.*'/option DirectInterface ''/g" ./package/network/services/dropbear/files/dropbear.config

# --------------------------------------------------

# 高通平台调整
if [[ "${WRT_TARGET^^}" == *"QUALCOMMAX"* ]]; then
	# 无 WiFi 配置调整 Q6 大小
	if [[ "${WRT_CONFIG,,}" == *"wifi"* && "${WRT_CONFIG,,}" == *"no"* ]]; then
		# DTS_PATH="./target/linux/qualcommax/files/arch/arm64/boot/dts/qcom/"
		# find $DTS_PATH -type f ! -iname '*nowifi*' -exec sed -i 's/ipq\(6018\|8074\).dtsi/ipq\1-nowifi.dtsi/g' {} +
		# echo "Successful: qualcommax set up nowifi"
		# echo ''
    :
	fi
fi

# 修改设备内核大小
imageFile="./target/linux/qualcommax/image/ipq60xx.mk"
if [[ -f "$imageFile" ]]; then
  sed -i "/^define Device\/jdcloud_re-ss-01/,/^endef/ { /KERNEL_SIZE := 6144k/s//KERNEL_SIZE := 12288k/ }" "$imageFile"
  sed -i "/^define Device\/jdcloud_re-cs-02/,/^endef/ { /KERNEL_SIZE := 6144k/s//KERNEL_SIZE := 12288k/ }" "$imageFile"
  sed -i "/^define Device\/jdcloud_re-cs-07/,/^endef/ { /KERNEL_SIZE := 6144k/s//KERNEL_SIZE := 12288k/ }" "$imageFile"
  sed -i "/^define Device\/redmi_ax5-jdcloud/,/^endef/ { /KERNEL_SIZE := 6144k/s//KERNEL_SIZE := 12288k/ }" "$imageFile"
  echo 'Successful: modify kernel size'
	echo ''
fi
