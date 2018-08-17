PKG_NAME="gnutls"
PKG_VERSION="3.5.16"
PKG_ARCH="any"
PKG_LICENSE="GPLv3"
PKG_SITE="https://www.gnupg.org/ftp/gcrypt/gnutls/v3.5/"
PKG_URL="https://www.gnupg.org/ftp/gcrypt/gnutls/v3.5/gnutls-$PKG_VERSION.tar.xz"
#PKG_DEPENDS_TARGET="toolchain openssl libidn2 nettle libgcrypt libtasn1 libunistring"
PKG_DEPENDS_TARGET="toolchain openssl nettle libtasn1"
PKG_SECTION="escalade/depends"
PKG_SHORTDESC="GnuTLS is a secure communications library implementing the SSL, TLS and DTLS protocols and technologies around them."

PKG_CONFIGURE_OPTS_TARGET="--disable-doc \
			      --disable-guile \
			      --disable-libdane \
			      --disable-rpath \
			      --enable-local-libopts \
			      --enable-openssl-compatibility \
			      --without-tpm \
			      --disable-tools \
			      --without-idn \
			      --without-libidn2 \
			      --without-p11-kit \
			      --with-included-unistring \
			      --with-zlib \
			      --disable-cryptodev \
			      --with-nettle-mini"
