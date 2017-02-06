PKG_NAME="perl"
PKG_VERSION="5.24.1"
PKG_URL="http://www.cpan.org/src/5.0/perl-${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain openssl db gdbm"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

configure_target() {
  ./Configure -des \
  		-Duselargefiles \
  		-Duse64bitint \
  		-Dusethreads \
  		-Duseshrplib \
  		-Dprefix=/usr \
  		-Dvendorprefix=/usr \
  		-Dusedevel \
  		-Accflags="$CFLAGS -fPIC" \
  		-Dld="$LD" \
  		-Dar="$AR" \
  		-Dcc="$CC" \
  		-Dldflags="$LDFLAGS -fPIC" \
  		-Dlibs="-lm -lcrypt -pthread"
}

               
post_makeinstall_target() {
  ln -sf perl$PKG_VERSION $INSTALL/usr/bin/perl
}