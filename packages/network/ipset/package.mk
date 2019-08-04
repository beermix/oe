PKG_NAME="ipset"
PKG_VERSION="7.1"
PKG_URL="http://ipset.netfilter.org/ipset-${PKG_VERSION}.tar.bz2"
PKG_DEPENDS_TARGET="toolchain linux libmnl libnftnl"
PKG_TOOLCHAIN="autotools"

PKG_CONFIGURE_OPTS_TARGET="--enable-static \
			      --disable-shared \
			      --with-kbuild=$(kernel_path) \
			      --sysconfdir=/storage/.config/ipset \
			      --with-kmod=yes"