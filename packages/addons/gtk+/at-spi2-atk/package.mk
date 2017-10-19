PKG_NAME="at-spi2-atk"
PKG_VERSION="2.26.0"
PKG_ARCH="any"
PKG_LICENSE="OSS"
PKG_SITE="http://ftp.gnome.org/pub/gnome/sources/at-spi2-atk/?C=M;O=D"
PKG_URL="http://ftp.gnome.org/pub/gnome/sources/$PKG_NAME/2.26/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain libX11 libxkbcommon at-spi2-core atk libXtst"
PKG_SECTION="escalade/depends"
PKG_SHORTDESC="A GTK+ module that bridges ATK to D-Bus at-spi"


PKG_AUTORECONF="no"

#PKG_CONFIGURE_OPTS_TARGET="--disable-shared --with-pic"