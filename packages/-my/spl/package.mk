PKG_NAME="spl"
PKG_VERSION="0.6.5.9"
PKG_URL="https://github.com/zfsonlinux/zfs/releases/download/zfs-$PKG_VERSION/spl-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain libaio attr fuse fuse3"
PKG_SECTION="debug/tools"
PKG_SHORTDESC="htop: Htop is an ncurses based interactive process viewer for Linux."
PKG_LONGDESC="Htop is an ncurses based interactive process viewer for Linux."


PKG_CONFIGURE_OPTS_TARGET="cross_compiling=maybe \
			      --with-config=user \
			      --with-blkid=no \
			      --with-spec=generic \
			      --with-linux=$(get_pkg_build linux) \
			      --with-linux-obj=$(get_pkg_build linux)"