PKG_NAME="libnl-tiny"
PKG_VERSION="1.0.1"
PKG_SITE="https://github.com/sabotage-linux/libnl-tiny"
PKG_URL="http://ftp.barfooze.de/pub/sabotage/tarballs/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="libnl-tiny is a tiny replacement for libnl versions 1 and 2 whichis a library for applications dealing with netlink socket. It provides an easy to use interface for raw netlink message but also netlink family specific APIs."

LIBNLTINY_MAKE_OPTS="CC=$CC AR=$AR RANLIB=$RANLIB prefix=/usr SHAREDLIB="

PKG_MAKE_OPTS_TARGET="$LIBNLTINY_MAKE_OPTS"
PKG_MAKEINSTALL_OPTS_TARGET="$LIBNLTINY_MAKE_OPTS"

