PKG_NAME="btrfs-progs"
PKG_VERSION="4.4"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="OSS"
PKG_SITE="http://www.boost.org/"
PKG_URL="https://copy.com/j8ih70vi3ocL/btrfs-progs-4.4.tar.gz"
#PKG_SOURCE_DIR="${PKG_NAME}-${PKG_VERSION}"
PKG_DEPENDS_HOST="toolchain"
PKG_DEPENDS_TARGET="toolchain util-linux zlib lzo"
PKG_PRIORITY="optional"
PKG_SECTION="devel"
PKG_SHORTDESC="libtorrent is a feature complete C++ bittorrent implementation focusing on efficiency and scalability."
PKG_LONGDESC="libtorrent is a feature complete C++ bittorrent implementation focusing on efficiency and scalability. It runs on embedded devices as well as desktops. It boasts a well documented library interface that is easy to use. It comes with a simple bittorrent client demonstrating the use of the library."
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"


PKG_CONFIGURE_OPTS_TARGET="--exec-prefix=/ \
                           --bindir=/sbin \
                           --disable-backtrace \
                           --disable-documentation \
                           --disable-convert"

pre_configure_target() {
  ./autogen.sh
}