PKG_NAME="ca-certificates"
PKG_VERSION="20161130"
PKG_URL="http://ftp.ru.debian.org/debian/pool/main/c/ca-certificates/ca-certificates_$PKG_VERSION.tar.xz"
PKG_SOURCE_DIR="ca-certificates"
PKG_DEPENDS_TARGET="toolchain"


pre_configure_target() {
  mkdir -p $INSTALL/usr/share/ca-certificates/mozilla/
  mkdir -p $INSTALL_DEV/usr/share/ca-certificates/mozilla/
  mkdir -p $INSTALL/usr/sbin
  mkdir -p $INSTALL_DEV/sbin/
}

post_makeinstall_target() {
  $PKG_DIR/extra/update-ca-certificates
}