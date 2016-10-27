PKG_NAME="wireshark"
PKG_VERSION="2.2.1"
PKG_URL="https://www.wireshark.org/download/src/all-versions/wireshark-$PKG_VERSION.tar.bz2"
PKG_DEPENDS_TARGET="toolchain libz libevent"
PKG_PRIORITY="optional"
PKG_SECTION="security"
PKG_USE_CMAKE="no"
PKG_AUTORECONF="no"


PKG_CONFIGURE_OPTS_TARGET="--prefix=/usr \
			   --with-openssl-dir=$SYSROOT_PREFIX/usr \
			   --sysconfdir=/storage/.config \
			   --datarootdir=/storage/.cache \
			   --datadir=/storage/.cache \
			   --with-zlib-dir=$ROOT/$TOOLCHAIN \
			   ac_cv_prog_cc_c99=-std=gnu99"