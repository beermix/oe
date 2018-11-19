# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="pcre"
PKG_VERSION="8.42"
PKG_SHA256="2cd04b7c887808be030254e8d77de11d3fe9d4505c39d4b15d2664ffe8bf9301"
PKG_LICENSE="OSS"
PKG_SITE="https://github.com/svn2github/pcre/"
PKG_URL="http://ftp.csx.cam.ac.uk/pub/software/programming/pcre/$PKG_NAME-$PKG_VERSION.tar.bz2"
PKG_DEPENDS_TARGET="toolchain zlib bzip2"
PKG_DEPENDS_HOST="ccache:host autotools:host autoconf:host"
PKG_SHORTDESC="pcre: Perl Compatible Regulat Expressions"
PKG_TOOLCHAIN="configure"
PKG_BUILD_FLAGS="+hardening"

PKG_CONFIGURE_OPTS_TARGET="--enable-utf8 \
			      --enable-pcre16 \
			      --enable-unicode-properties \
			      --enable-cpp \
			      --enable-jit \
			      --enable-pcregrep-libz \
			      --enable-pcregrep-libbz2"

PKG_CONFIGURE_OPTS_HOST="$PKG_CONFIGURE_OPTS_TARGET"

post_makeinstall_target() {
  rm -rf $INSTALL/usr/bin
  sed -e "s:\(['= ]\)/usr:\\1$SYSROOT_PREFIX/usr:g" -i $SYSROOT_PREFIX/usr/bin/$PKG_NAME-config
}
