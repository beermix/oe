PKG_NAME="zsync"
PKG_VERSION="0.6.2"
PKG_SITE="http://ftp.debian.org/"
PKG_URL="http://zsync.moria.org.uk/download/zsync-$PKG_VERSION.tar.bz2"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="system"
PKG_TOOLCHAIN="autotools"

pre_configure_target() {
  cd $PKG_BUILD
  rm -rf .$TARGET_NAME
}