PKG_NAME="perl"
PKG_VERSION="5.24.1"
PKG_URL="http://www.cpan.org/src/5.0/perl-${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain openssl db gdbm"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

configure_target() {
  export LD="$LD"
  ./Configure \
		-Dcc="$CC" \
		-Dcflags="$CFLAGS" \
		-Dldflags="$LDFLAGS" \
		-Dcf_by="OE" \
		-Dprefix=/usr \
		-Dvendorprefix=/usr \
		-Dsiteprefix=/usr \
		\
		-Duseshrplib \
		-Dusethreads \
		-Duseithreads \
		-Duselargefiles \
		-Dnoextensions=ODBM_File \
		-Ud_dosuid \
		-Ui_db \
		-Ui_ndbm \
		-Ui_gdbm \
		-Ui_gdbm_ndbm \
		-Ui_gdbmndbm \
		-Di_shadow \
		-Di_syslog \
		-Duseperlio \
		-Dman3ext=3pm \
		-Dsed=/bin/sed \
		-Uafs \
		-Ud_csh \
		-Uusesfio \
		-Uusenm -des
}

               
post_makeinstall_target() {
  ln -sf perl$PKG_VERSION $INSTALL/usr/bin/perl
}
