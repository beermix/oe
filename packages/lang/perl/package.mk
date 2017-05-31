PKG_NAME="perl"
PKG_VERSION="5.24.1"
PKG_URL="http://www.cpan.org/src/5.0/perl-${PKG_VERSION}.tar.xz"
PKG_DEPENDS_TARGET="toolchain openssl db gdbm"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

configure_target() {
  ./Configure -des \
		-Dcccdlflags='-fPIC' \
		-Dccdlflags='-rdynamic' \
		-Dprefix=/usr \
		-Dprivlib=$_privlib \
		-Darchlib=$_archlib \
		-A ccflags="$CFLAGS -fPIC -DPIC" \
		-Dcc="$CC" \
		-Dldflags="$LDFLAGS -fPIC" \
		-Dlibs="$LIBS -lrt -lz -lm -lcrypt -pthread" \
		-Doptimize="$CFLAGS -ffunction-sections -fdata-sections -finline-limit=8 -ffast-math" \
		-Dvendorprefix=/usr \
		-Dvendorlib=/usr/share/perl5/vendor_perl \
		-Dvendorarch=/usr/lib/perl5/vendor_perl \
		-Dsiteprefix=/usr/local \
		-Dsitelib=/usr/local/share/perl5/site_perl \
		-Dsitearch=/usr/local/lib/perl5/site_perl \
		-Dlocincpth=' ' \
		-Duselargefiles \
		-Dusethreads \
		-Duseshrplib \
		-Dd_semctl_semun \
		-Dman1dir=/usr/share/man/man1 \
		-Dman3dir=/usr/share/man/man3 \
		-Dinstallman1dir=/usr/share/man/man1 \
		-Dinstallman3dir=/usr/share/man/man3 \
		-Dman1ext='1' \
		-Dman3ext='3pm' \
		-Dcf_by='OE' \
		-Ud_csh \
		-Dusenm \
		|| return 1
		make; make
}

               
post_makeinstall_target() {
  ln -sf perl$PKG_VERSION $INSTALL/usr/bin/perl
}
