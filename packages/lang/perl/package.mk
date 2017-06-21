PKG_NAME="perl"
PKG_VERSION="5.27.1"
PKG_URL="http://www.cpan.org/src/5.0/perl-${PKG_VERSION}.tar.xz"
PKG_DEPENDS_TARGET="toolchain openssl gdbm db"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

configure_target() {
  ./Configure -des \
  		-Duselargefiles \
  		-Duse64bitint \
  		-A ccflags="$CFLAGS -fPIC -DPIC" \
  		-Dcc="$CC" \
  		-Dusedevel \
  		-Dldflags="$LDFLAGS -fPIC -DPIC" \
		-Dvendorprefix=/usr \
		-Dlocincpth=' ' \
		-Duselargefiles \
		-Dusethreads \
		-Duseshrplib \
		-DEBUGGING=none \
		-Uusevendorprefix \
		-Duseithreads \
		-Duseperlio \
		-Uman1dir \
		-Uman3dir \
		-Usiteman1dir \
		-Usiteman3dir
}


post_makeinstall_target() {
  ln -sf perl$PKG_VERSION $INSTALL/usr/bin/perl
}