PKG_NAME="lm_sensors"
PKG_VERSION="3.4.0"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="http://secure.netroedge.com/~lm78/"
PKG_URL="http://sources.libreelec.tv/mirror/lm_sensors/lm_sensors-3.4.0.tar.bz2"
PKG_DEPENDS_TARGET="toolchain"

PKG_SECTION="system"
PKG_SHORTDESC="lm_sensors: Hardware monitoring via the SMBus"
PKG_LONGDESC="lm_sensors is a package to get data from the SMB (System Management Bus - an i2c bus) on modern mainboards. It consists of kernel modules and users space tools to get stuff like cpu / mb temperature, voltages, fan speed..."
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

pre_configure_target() {
   strip_lto
}

PKG_MAKE_OPTS_TARGET="PREFIX=/usr CC=$TARGET_CC AR=$TARGET_AR"
PKG_MAKEINSTALL_OPTS_TARGET="PREFIX=/usr"

pre_make_target() {
  export CFLAGS="$TARGET_CFLAGS"
  export CPPFLAGS="$TARGET_CPPFLAGS"
}

post_makeinstall_target() {
  rm -rf $INSTALL/usr/bin/sensors-conf-convert
  rm -rf $INSTALL/usr/sbin/
  rm -rf $INSTALL/usr/lib
  $STRIP $INSTALL/usr/bin/sensors
}
