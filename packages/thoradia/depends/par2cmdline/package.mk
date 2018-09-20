PKG_NAME="par2cmdline"
PKG_VERSION="0.8.0"
PKG_SHA256="461b45627a0d800061657b2d800c432c7d1c86c859b40a3ced35a0cc6a85faca"
PKG_LICENSE="OSS"
PKG_SITE="https://github.com/Parchive/par2cmdline"
PKG_URL="https://github.com/Parchive/$PKG_NAME/archive/v$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_SHORTDESC="par2cmdline: a PAR 2.0 compatible file verification and repair tool"
PKG_TOOLCHAIN="autotools"

post_makeinstall_target() {
  ln -fs $INSTALL/usr/bin/par2 $INSTALL/usr/bin/par2create
  ln -fs $INSTALL/usr/bin/par2 $INSTALL/usr/bin/par2repair
  ln -fs $INSTALL/usr/bin/par2 $INSTALL/usr/bin/par2verify
}
