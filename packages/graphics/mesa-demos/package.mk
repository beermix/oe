PKG_NAME="mesa-demos"
PKG_VERSION="8.4.0"
PKG_SITE="http://www.mesa3d.org/"
PKG_URL="ftp://ftp.freedesktop.org/pub/mesa/demos/$PKG_VERSION/$PKG_NAME-$PKG_VERSION.tar.bz2"
PKG_URL="https://fossies.org/linux/misc/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain libX11 mesa glu glew"
PKG_LONGDESC="Mesa 3D demos - installed are the well known glxinfo and glxgears."

PKG_CONFIGURE_OPTS_TARGET="--without-glut"
