PKG_NAME="at-spi2-atk"
PKG_VERSION="2.25.2"
PKG_ARCH="any"
PKG_LICENSE="OSS"
PKG_SITE="http://www.gnome.org/"
PKG_URL="http://ftp.gnome.org/pub/gnome/sources/$PKG_NAME/2.25/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain libX11 at-spi2-core atk libXtst"
PKG_SECTION="escalade/depends"
PKG_SHORTDESC="A GTK+ module that bridges ATK to D-Bus at-spi"
PKG_IS_ADDON="no"

PKG_AUTORECONF="yes"

#PKG_CONFIGURE_OPTS_TARGET="--disable-shared"

#pre_configure_target() {
#  export CFLAGS="$CFLAGS -fPIC"
#}
