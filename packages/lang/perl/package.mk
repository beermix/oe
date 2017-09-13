PKG_NAME="perl"
PKG_VERSION="5.24.2"
PKG_SITE="http://www.cpan.org/src/5.0/?C=M;O=D"
#PKG_URL="https://fossies.org/linux/misc/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_URL="http://www.cpan.org/src/5.0/perl-${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain openssl gdbm"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

pre_configure_target() {
 cd $ROOT/$PKG_BUILD
 rm -rf .$TARGET_NAME
 strip_lto
 strip_gold
}

configure_target() {
./Configure -Dusedevel \
		   -Doptimize="$CFLAGS" \
		   -Dcc=$CC \
		   -Dprefix=/usr \
		   -Dinstallprefix=${startdir}/pkg/usr \
		   -Dvendorprefix=/usr \
		   -Dprivlib=/usr/share/perl5/core_perl \
		   -Darchlib=/usr/lib/perl5/core_perl \
		   -Dsitelib=/usr/share/perl5/site_perl/${pkgver} \
		   -Dsitearch=/usr/lib/perl5/site_perl/${pkgver} \
		   -Dvendorlib=/usr/share/perl5/vendor_perl \
		   -Dvendorarch=/usr/lib/perl5/vendor_perl \
		   -Dotherlibdirs=/usr/lib/perl5/current:/usr/lib/perl5/site_perl/current \
		   -Dscriptdir='/usr/bin/perlbin/core' \
		   -Dsitescript='/usr/bin/perlbin/site' \
		   -Dvendorscript='/usr/bin/perlbin/vendor' \
		   -Dman1ext=1perl -Dman3ext=3perl ${arch_opts} \
		   -Duseshrplib -Dlibperl=libperl.so.${pkgver} \
		   -Dlibswanted="dl m c crypt db ndbm gdbm" \
		   -des -Dusethreads \
		   -Dccdlflags="-rdynamic -Wl,-O1" -Dlddlflags="-shared -Wl,-O1" -Dldflags="-Wl,-O1" \
		   -Dmyhostname=localhost -Dperladmin=root at localhost \
		   -Di_shadow -Di_syslog -Duseithreads -Duselargefiles \
		   -Di_db -Di_gdbm -Di_ndbm -Di_sdbm -Ui_odbm
}

make_target() {
 make && make && make
}

post_makeinstall_target() {
  #rm -rf $INSTALL/usr/share
  ln -sfr perl $INSTALL/usr/bin/perl${PKG_VERSION}
}