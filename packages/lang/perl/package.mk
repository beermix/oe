PKG_NAME="perl"
PKG_VERSION="5.29.7"
PKG_SITE="http://www.cpan.org/src/5.0/?C=M;O=D"
PKG_URL="https://fossies.org/linux/misc/$PKG_NAME-$PKG_VERSION.tar.gz"
#PKG_URL="http://www.cpan.org/src/5.0/perl-${PKG_VERSION}.tar.xz"
PKG_DEPENDS_TARGET="toolchain openssl bzip2 gdbm db"
#PKG_DEPENDS_TARGET="toolchain openssl bzip2 gdbm"
PKG_TOOLCHAIN="configure"

pre_configure_target() {
 cd $PKG_BUILD
 rm -rf .$TARGET_NAME
}

configure_target() {
./Configure -Dusedevel \
	     -Dcc=$CC \
	     -Dprefix=/usr  \
	     -Dvendorprefix=/usr \
	     -Dlibswanted="dl m c crypt ndbm gdbm db" \
	     -des \
	     -Dusethreads \
	     -Dldflags="$LDFLAGS -lpthread -lrt -lm" \
	     -Dccflags="$CFLAGS"
}

post_makeinstall_target() {
  rm -rf $INSTALL/usr/share/man
  ln -sf perl${PKG_VERSION} $INSTALL/usr/bin/perl
}