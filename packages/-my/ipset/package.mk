PKG_NAME="ipset"
PKG_VERSION="6.29"
PKG_URL="http://ipset.netfilter.org/ipset-${PKG_VERSION}.tar.bz2"
PKG_DEPENDS_TARGET="toolchain linux libmnl libnftnl"
PKG_PRIORITY="optional"
PKG_SECTION="tools"
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_TARGET="--enable-static \
		           --disable-shared \
		           --with-gnu-ld \
		           --with-kbuild=$(get_pkg_build linux) \
		           --sysconfdir=/storage/.config/ipset \
		           --with-kmod=no"