PKG_NAME="glproto"
PKG_VERSION="1.4.17"
PKG_SHA256="adaa94bded310a2bfcbb9deb4d751d965fcfe6fb3a2f6d242e2df2d6589dbe40"
PKG_LICENSE="OSS"
PKG_SITE="http://www.x.org/"
PKG_URL="http://xorg.freedesktop.org/archive/individual/proto/$PKG_NAME-$PKG_VERSION.tar.bz2"
PKG_DEPENDS_TARGET="toolchain util-macros"
PKG_SHORTDESC="glproto: GL extension headers"
PKG_LONGDESC="GL extension headers"

# package specific configure options
PKG_CONFIGURE_OPTS_TARGET="--without-xmlto"
