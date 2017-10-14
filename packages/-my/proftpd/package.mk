PKG_NAME="proftpd"
PKG_VERSION="b104d60"
PKG_ARCH="all"
PKG_SITE="http://www.proftpd.org/"
PKG_URL="https://github.com/proftpd/proftpd/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain libcap whois pcre libsodium openssl"

PKG_SECTION="service/system"
PKG_AUTORECONF="no"

pre_configure_target() {
  export CFLAGS="$CFLAGS -fPIC"
  export CXXFLAGS="$CXXFLAGS -fPIC"
  export LDFLAGS="$LDFLAGS -fPIC"
  cd $PKG_BUILD
  export LIBS="-ltermcap"
}

PKG_CONFIGURE_OPTS_TARGET="--enable-statcic \
			   --disable-auth-pam \
			   --disable-ipv6 \
			   --disable-silent-rules \
			   --sysconfdir=/storage/.config/proftpd"

