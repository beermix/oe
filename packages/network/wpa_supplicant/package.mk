################################################################################
#      This file is part of OpenELEC - http://www.openelec.tv
#      Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
#
#  OpenELEC is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 2 of the License, or
#  (at your option) any later version.
#
#  OpenELEC is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with OpenELEC.  If not, see <http://www.gnu.org/licenses/>.
################################################################################

PKG_NAME="wpa_supplicant"
PKG_VERSION="2.6"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="http://hostap.epitest.fi/wpa_supplicant/"
PKG_URL="http://hostap.epitest.fi/releases/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain dbus libnl-tiny openssl"
PKG_PRIORITY="optional"
PKG_SECTION="network"
PKG_SHORTDESC="wpa_supplicant: An IEEE 802.11i supplicant implementation"
PKG_LONGDESC="The wpa_supplicant is a free software implementation of an IEEE 802.11i supplicant. In addition to being a full-featured WPA2 supplicant, it also has support for WPA and older wireless LAN security protocols."

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

PKG_MAKE_OPTS_TARGET="-C wpa_supplicant V=1 LIBDIR=/usr/lib BINDIR=/usr/bin"
PKG_MAKEINSTALL_OPTS_TARGET="-C wpa_supplicant V=1 LIBDIR=/usr/lib BINDIR=/usr/bin"

configure_target() {
  LDFLAGS="$LDFLAGS -lpthread -lm"
  CFLAGS="$CFLAGS -D_GNU_SOURCE -DCONFIG_LIBNL20 -I$SYSROOT_PREFIX/usr/include/libnl-tiny"
  cp $PKG_DIR/config/makefile.config wpa_supplicant/.config

#echo "CONFIG_TLS=gnutls" >> .config
#echo "CONFIG_GNUTLS_EXTRA=y" >> .config
echo "CONFIG_P2P=y" >> .config
echo "CONFIG_WIFI_DISPLAY=y" >> .config
echo "CONFIG_CTRL_IFACE_DBUS_NEW=y" >> .config
echo "CONFIG_DRIVER_TEST=y" >> .config
echo "CONFIG_DRIVER_WIRED=y" >> .config
echo "CONFIG_IEEE8021X_EAPOL=y" >> .config
echo "CONFIG_EAP_FAST=y" >> .config
echo "CONFIG_EAP_MD5=y" >> .config
echo "CONFIG_EAP_MSCHAPV2=y" >> .config
echo "CONFIG_EAP_TLS=y" >> .config
echo "CONFIG_EAP_PEAP=y" >> .config
echo "CONFIG_EAP_TTLS=y" >> .config
echo "CONFIG_EAP_GTC=y" >> .config
echo "CONFIG_EAP_OTP=y" >> .config
echo "CONFIG_EAP_LEAP=y" >> .config
echo "CONFIG_WPS=y" >> .config
echo "CONFIG_PKCS12=y" >> .config
echo "CONFIG_CTRL_IFACE=y" >> .config
echo "CONFIG_PEERKEY=y" >> .config
echo "CONFIG_IEEE80211W=y" >> .config
echo "CONFIG_TLS=internal" >> .config
echo "CONFIG_INTERNAL_LIBTOMMATH_FAST=y" >> .config
echo "CONFIG_IEEE80211R=y" >> .config
echo "CONFIG_NO_RANDOM_POOL=y" >> .config
echo "CONFIG_IBSS_RSN=y" >> .config
echo "NEED_80211_COMMON=y" >> .config
echo "CONFIG_READLINE=y" >> .config
}

post_makeinstall_target() {
  rm -r $INSTALL/usr/bin/wpa_cli

mkdir -p $INSTALL/etc/dbus-1/system.d
  cp wpa_supplicant/dbus/dbus-wpa_supplicant.conf $INSTALL/etc/dbus-1/system.d

mkdir -p $INSTALL/usr/lib/systemd/system
  cp wpa_supplicant/systemd/wpa_supplicant.service $INSTALL/usr/lib/systemd/system

mkdir -p $INSTALL/usr/share/dbus-1/system-services
  cp wpa_supplicant/dbus/fi.w1.wpa_supplicant1.service $INSTALL/usr/share/dbus-1/system-services
  cp wpa_supplicant/dbus/fi.epitest.hostap.WPASupplicant.service $INSTALL/usr/share/dbus-1/system-services
}
