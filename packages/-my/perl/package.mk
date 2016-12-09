PKG_NAME="perl"
PKG_VERSION="5.25.5"
PKG_URL="http://www.cpan.org/src/5.0/perl-${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain openssl gdbm"

PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

configure_target() {
  sed -i 's,-fstack-protector,-fnostack-protector,g' ./Configure
  ./Configure -des -Duselargefiles \
  		   -Duse64bitint \
  		   -Dusethreads \
  		   -Duseshrplib \
  		   -Dprefix=/usr \
  		   -Dvendorprefix=/usr \
  		   -Dusedevel \
  		   -Accflags="-fno-stack-protector $CFLAGS -fPIC -DPIC" \
  		   -Dld="$LD" \
  		   -Dar="$AR" \
  		   -Dcc="$CC" \
  		   -Dldflags="$LDFLAGS -fPIC" \
  		   -Dlibs="-lm -lcrypt -pthread" \
  		   -Doptimize="-fno-stack-protector -O3 -ffunction-sections -fdata-sections -finline-limit=8 -ffast-math" \
  		   
}

               
post_makeinstall_target() {
  mv $INSTALL/usr/bin/perl5.25.5 $INSTALL/usr/bin/perl
}