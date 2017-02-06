PKG_NAME="zfs"
PKG_VERSION="0.6.5.9"
PKG_URL="https://fossies.org/linux/misc/zfs-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain libaio attr fuse3"
PKG_SECTION="debug/tools"
PKG_SHORTDESC="htop: Htop is an ncurses based interactive process viewer for Linux."
PKG_LONGDESC="Htop is an ncurses based interactive process viewer for Linux."
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_TARGET="--enable-static \
			      --disable-shared \
			      --with-gnu-ld \
			      --with-linux=$(get_pkg_build linux)"