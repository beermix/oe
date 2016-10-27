PKG_NAME="dropbear"
PKG_VERSION="2016.74"
PKG_URL="https://matt.ucc.asn.au/dropbear/dropbear-$PKG_VERSION.tar.bz2"
#PKG_SOURCE_DIR="dropbear-DROPBEAR_$PKG_VERSION*"
PKG_DEPENDS_TARGET="toolchain"
PKG_PRIORITY="optional"
PKG_AUTORECONF="no"

pre_cofigure_target() {
  sed 's:.*\(#define DO_HOST_LOOKUP\).*:\1:' $PKG_BUILD/$PKG_NAME/options.h
  cd $ROOT/$PKG_BUILD
  autoreconf --verbose --install --force -I m4
}


PKG_CONFIGURE_OPTS_TARGET="--prefix=/usr \
			   --enable-bundled-libtom \
			   --disable-pam \
			   --enable-openpty \
			   --enable-syslog \
			   --disable-lastlog \
			   --disable-wtmp \
			   --disable-wtmpx \
			   --disable-pututxline \
			   --with-zlib=$SYSROOT_PREFIX/usr"
