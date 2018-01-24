PKG_NAME="perl"
PKG_VERSION="5.27.8"
PKG_SITE="http://www.cpan.org/src/5.0/?C=M;O=D"
PKG_URL="https://fossies.org/linux/misc/$PKG_NAME-$PKG_VERSION.tar.xz"
#PKG_URL="http://www.cpan.org/src/5.0/perl-${PKG_VERSION}.tar.xz"
PKG_DEPENDS_TARGET="toolchain openssl bzip2 gdbm"
PKG_SECTION="my"
PKG_TOOLCHAIN="configure"

pre_configure_target() {
 cd $PKG_BUILD
 rm -rf .$TARGET_NAME
 strip_lto
 strip_gold
}

configure_target() {
./Configure -Dusedevel \
	     -Dcc=$CC \
	     -Dprefix=/usr  \
	     -Dvendorprefix=/usr \
	     -Dprivlib=/usr/share/perl5/core_perl \
	     -Darchlib=/usr/lib/perl5/core_perl \
	     -Dsitelib=/usr/share/perl5/site_perl/${PKG_VERSION} \
	     -Dsitearch=/usr/lib/perl5/site_perl/${PKG_VERSION} \
	     -Dvendorlib=/usr/share/perl5/vendor_perl \
	     -Dvendorarch=/usr/lib/perl5/vendor_perl \
	     -Dotherlibdirs=/usr/lib/perl5/current:/usr/lib/perl5/site_perl/current \
	     -Dscriptdir='/usr/bin/perlbin/core' \
	     -Dsitescript='/usr/bin/perlbin/site' \
	     -Dvendorscript='/usr/bin/perlbin/vendor' \
	     -Dman1ext=1perl \
	     -Dman3ext=3perl \
	     -Dlibswanted="dl m c crypt db ndbm gdbm" \
	     -des \
	     -Dusethreads \
	     -Dldflags="$LDFLAGS -lm" \
	     -Dccflags="$CFLAGS" \
	     -Dmydomain="" \
	     -Dmyhostname="noname" \
	     -Dosname=linux \
	     -Dperladmin=root \
	     -Di_shadow -Di_syslog -Duseithreads -Duselargefiles \
	     -Di_db -Di_gdbm -Di_ndbm -Di_sdbm -Ui_odbm	

}

post_makeinstall_target() {
  rm -rf $INSTALL/usr/share/man
  ln -sf perl${PKG_VERSION} $INSTALL/usr/bin/perl
}