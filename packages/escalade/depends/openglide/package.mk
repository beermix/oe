# Made by github.com/escalade

PKG_NAME="openglide"
PKG_VERSION="3722fc5"
PKG_ARCH="any"
PKG_LICENSE="OSS"
PKG_SITE="http://openglide.sourceforge.net"
PKG_URL="https://github.com/voyageur/openglide/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="escalade/depends"
PKG_SHORTDESC="OpenGLide is a Glide to OpenGL wrapper."
PKG_IS_ADDON="no"

PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_TARGET="--disable-sdl"

pre_configure_target() {
 sed -e '/install-data-hook/,/$p/d' -i ../Makefile.am
}
