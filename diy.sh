#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy.sh
# Description: OpenWrt DIY script (After Update feeds)
#


# Add OpenClash
git clone --depth=1 -b master https://github.com/vernesong/OpenClash ./package/lean/luci-app-openclash

cd $OLDPWD

# Add luci-app-netdata
rm -rf feeds/luci/applications/luci-app-netdata
git clone --depth=1 https://github.com/sirpdboy/luci-app-netdata.git ./package/lean/luci-app-netdata

# Add luci-theme-argon
rm -rf feeds/luci/themes/luci-theme-argon
git clone --depth=1 -b 18.06 https://github.com/jerrykuku/luci-theme-argon.git package/luci-theme-argon
rm -rf package/luci-theme-argon/README* package/luci-theme-argon/Screenshots/
git clone --depth=1 https://github.com/jerrykuku/luci-app-argon-config.git package/luci-app-argon-config

# Add luci-theme-neobird
git clone --depth=1 https://github.com/thinktip/luci-theme-neobird.git package/lean/luci-theme-neobird

# Mod default theme
# sed -i 's/luci-theme-bootstrap/luci-theme-neobird/g' ./feeds/luci/collections/luci/Makefile
# sed -i 's/luci-theme-bootstrap/luci-theme-neobird/g' ./feeds/luci/collections/luci-nginx/Makefile

# Add luci-app-poweroff
git clone --depth=1 https://github.com/esirplayground/luci-app-poweroff ./package/lean/luci-app-poweroff

# Mod zzz-default-settings
pushd package/lean/default-settings/files
sed -i '/http/d' zzz-default-settings
sed -i '/18.06/d' zzz-default-settings
export orig_version=$(cat "zzz-default-settings" | grep DISTRIB_REVISION= | awk -F "'" '{print $2}')
sed -i "s/${orig_version}/Firmware compiled by Maverick/g" zzz-default-settings
popd

# Change default theme luci-theme-neobird
sed -i 's/luci-theme-bootstrap/luci-theme-neobird/' feeds/luci/collections/luci/Makefile

# Modify default IP
sed -i 's/192.168.1.1/192.168.2.2/g' package/base-files/files/bin/config_generate

# Clear the login password
sed -i 's/$1$V4UetPzk$CYXluq4wUazHjmCDBCqXF.//g' package/lean/default-settings/files/zzz-default-settings
