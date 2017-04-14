################################################################################
#      This file is part of Alex@ELEC - http://www.alexelec.in.ua
#      Copyright (C) 2011-2017 Alexandr Zuyev (alex@alexelec.in.ua)
################################################################################

PKG_NAME="gnutls"
PKG_VERSION="3.5.11"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="http://www.gnutls.org"
PKG_URL="ftp://ftp.gnutls.org/gcrypt/gnutls/v3.5/gnutls-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain zlib"
PKG_SECTION="xmedia/tools"
PKG_SHORTDESC="gnutls: Development Library for TLS applications"
PKG_LONGDESC="GnuTLS is a project that aims to develop a library which provides a secure layer, over a reliable transport layer. Currently the GnuTLS library implements the proposed standards by the IETF's TLS working group. Quoting from RFC2246 - the TLS 1.0 protocol specification: The TLS protocol provides communications privacy over the Internet. The protocol allows client/server applications to communicate in a way that is designed to prevent eavesdropping, tampering, or message forgery."
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

PKG_CONFIGURE_OPTS_TARGET="--enable-hardware-acceleration \
			      --disable-openssl-compatibility \
			      --enable-cxx \
			      --without-p11-kit \
			      --enable-local-libopts \
			      --with-included-libtasn1 \
			      --with-libz-prefix=$SYSROOT_PREFIX/usr \
			      --with-librt-prefix=$SYSROOT_PREFIX/usr \
			      --with-libpthread-prefix=$SYSROOT_PREFIX/usr \
			      --without-libiconv-prefix \
			      --without-libintl-prefix \
			      --with-included-unistring \
			      --disable-libdane \
			      --disable-doc \
			      --disable-nls \
			      --disable-guile \
			      --disable-valgrind-tests \
			      --without-lzo \
			      --with-gnu-ld"s