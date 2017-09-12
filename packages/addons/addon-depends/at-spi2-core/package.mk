PKG_NAME="at-spi2-core"
PKG_VERSION="2.26.0"
PKG_ARCH="any"
PKG_LICENSE="OSS"
PKG_SITE="http://ftp.gnome.org/pub/gnome/sources/at-spi2-core/?C=M;O=D"
PKG_URL="http://ftp.gnome.org/pub/gnome/sources/$PKG_NAME/2.25/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain dbus glib libXtst"
PKG_SECTION="escalade/depends"
PKG_SHORTDESC="Protocol definitions and daemon for D-Bus at-spi"
PKG_IS_ADDON="no"

PKG_AUTORECONF="no"

PKG_CONFIGURE_OPTS_TARGET="--disable-shared"

pre_configure_target() {
  export CFLAGS="$CFLAGS -fPIC"
}