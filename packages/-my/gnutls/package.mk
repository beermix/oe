PKG_NAME="gnutls"
PKG_VERSION="3.5.5"
PKG_SITE="http://www.gnutls.org/"
PKG_URL="ftp://ftp.gnutls.org/gcrypt/gnutls/v3.5/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain libz libidn gmp lzo nettle"
PKG_PRIORITY="optional"
PKG_SECTION="security"
PKG_SHORTDESC="gnutls: Development Library for TLS applications"
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

pre_configure_target() {
   strip_lto
}

PKG_CONFIGURE_OPTS_TARGET="--enable-hardware-acceleration \
                           --disable-openssl-compatibility \
                           --enable-cxx \
                           --enable-static \
                           --disable-shared \
                           --with-gnu-ld \
                           --enable-guile \
                           --with-guile-site-dir=no \
                           --disable-doc \
                           --disable-tests \
                           --with-idn \
                           --disable-rpath \
                           --enable-local-libopts \
                           --with-included-libtasn1 \
                           --without-libiconv-prefix \
                           --without-tpm \
                           --without-libintl-prefix \
                           --disable-valgrind-tests \
                           --disable-silent-rules \
                           --without-lzo \
                           --disable-tools \
                           --disable-libdane \
                           --without-p11-kit \
                           --with-zlib"
