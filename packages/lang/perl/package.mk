PKG_NAME="perl"
PKG_VERSION="5.27.2"
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
		-Usiteman3dir \
		-Dvendorlib=/usr/share/perl5/vendor_perl \
		-Dvendorarch=/usr/lib/perl5/vendor_perl \
		-Dsiteprefix=/usr/local \
		-Dsitelib=/usr/local/share/perl5/site_perl \
		-Dsitearch=/usr/local/lib/perl5/site_perl \
		-Dman1dir=/usr/share/man/man1 \
		-Dman3dir=/usr/share/man/man3 \
		-Dinstallman1dir=/usr/share/man/man1 \
		-Dinstallman3dir=/usr/share/man/man3 \
		-Dman1ext='1' \
		-Dman3ext='3pm' \
		-Dcf_by='OE' \
		-Ud_csh \
		-Dusenm
}


post_makeinstall_target() {
  ln -sf perl$PKG_VERSION $INSTALL/usr/bin/perl
}