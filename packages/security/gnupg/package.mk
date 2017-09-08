PKG_NAME="gnupg"
#PKG_VERSION="2.2.0"
PKG_VERSION="1.4.22"
PKG_SITE="http://www.gnupg.org/"
PKG_URL="ftp://ftp.gnupg.org/gcrypt/gnupg/$PKG_NAME-$PKG_VERSION.tar.bz2"
PKG_DEPENDS_TARGET="toolchain zlib curl libassuan libksba npth"
PKG_SECTION="security"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

pre_configure_target() {
  CFLAGS=`echo $CFLAGS | sed -e "s|-O.|-Os|"`
  CXXFLAGS=`echo $CXXFLAGS | sed -e "s|-O.|-Os|"`
}

PKG_CONFIGURE_OPTS_TARGET="--disable-shared \
			      --with-gnu-ld \
			      --with-pic \
			      --disable-rpath \
			      --enable-minimal \
			      --disable-regex \
			      --enable-sha256 \
			      --enable-sha512"
