PKG_NAME="gnutls"
PKG_VERSION="3.6.0"
PKG_ARCH="any"
PKG_LICENSE="GPLv3"
PKG_SITE="https://www.gnupg.org/ftp/gcrypt/gnutls/v3.6/"
PKG_URL="https://www.gnupg.org/ftp/gcrypt/gnutls/v3.6/gnutls-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain openssl libidn2 nettle libgcrypt libtasn1 libunistring"
PKG_SECTION="escalade/depends"
PKG_SHORTDESC="GnuTLS is a secure communications library implementing the SSL, TLS and DTLS protocols and technologies around them."
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_TARGET="--without-p11-kit \
			      --with-libgcrypt \
			      --disable-tools \
			      --disable-doc \
			      --disable-guile \
			      --disable-libdane \
			      --disable-rpath \
			      --enable-local-libopts \
			      --enable-openssl-compatibility \
			      --without-tpm \
			      --disable-shared \
			      --with-pic"
