PKG_NAME="dropbear"
PKG_VERSION="2016.74"
PKG_URL="https://matt.ucc.asn.au/dropbear/dropbear-$PKG_VERSION.tar.bz2"
PKG_DEPENDS_TARGET="toolchain"
PKG_AUTORECONF="yes"

pre_cofigure_target() {
  cd $ROOT/$PKG_BUILD
}

PKG_CONFIGURE_OPTS_TARGET="--disable-pam \
			      --enable-openpty \
			      --enable-syslog \
			      --disable-lastlog \
			      --disable-utmpx \
			      --disable-utmp \
			      --disable-wtmp \
			      --disable-wtmpx \
			      --disable-loginfunc \
			      --disable-pututline \
			      --disable-pututxline \
			      --disable-zlib \
			      --enable-bundled-libtom"
