PKG_NAME="dropbear"
PKG_VERSION="2016.74"
PKG_URL="https://matt.ucc.asn.au/dropbear/dropbear-$PKG_VERSION.tar.bz2"
PKG_DEPENDS_TARGET="toolchain openssl"
PKG_AUTORECONF="yes"

pre_configure_target() {
  cd $PKG_BUILD
  rm -rf .$TARGET_NAME
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

post_install() {
  enable_service dropbear.service
}