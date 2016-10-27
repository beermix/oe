PKG_NAME="dash"
PKG_VERSION="0.5.9.1"
PKG_URL="http://gondor.apana.org.au/~herbert/dash/files/dash-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain netbsd-curses readline"
PKG_PRIORITY="optional"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

LC_CTYPE=C
#CFLAGS="-D_GNU_SOURCE -D__KLIBC__ $CFLAGS -g"
#LDFLAGS="$LDFLAGS -static"
LIBS="-lcurses -lterminfo"

CFLAGS="-march=corei7-avx -mtune=corei7-avx -fdata-sections -ffunction-sections -O3 -Wa,--noexecstack"
LDFLAGS="-s -Wl,-O1,--as-needed -static"

PKG_CONFIGURE_OPTS_TARGET="--enable-statcic \
			   --enable-fnmatch \
			   --bindir=/bin \
			   --with-libedit \
			   --enable-glob \
			   --with-sysroot=$SYSROOT_PREFIX"