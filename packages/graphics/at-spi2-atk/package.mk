
# libepoxy (actually) needs to be built shared, to avoid
# (EE) Failed to load /usr/lib/xorg/modules/libglamoregl.so: 
# /usr/lib/xorg/modules/libglamoregl.so: undefined symbol: epoxy_eglCreateImageKHR
# in Xorg.log

PKG_NAME="at-spi2-atk"
PKG_VERSION="2.14.0"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/anholt/libepoxy"
PKG_URL="http://http.debian.net/debian/pool/main/a/at-spi2-atk/at-spi2-atk_2.14.0.orig.tar.xz"
PKG_DEPENDS_TARGET="toolchain atspi"
PKG_PRIORITY="optional"
PKG_SECTION="graphics"
PKG_SHORTDESC="libepoxy: a library for handling OpenGL function pointer management for you."
PKG_LONGDESC="Epoxy is a library for handling OpenGL function pointer management for you."

PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

