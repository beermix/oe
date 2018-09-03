# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)

PKG_NAME="pcre"
PKG_VERSION="8.42"
PKG_ARCH="any"
PKG_LICENSE="OSS"
PKG_SITE="https://github.com/svn2github/pcre/"
PKG_URL="http://ftp.csx.cam.ac.uk/pub/software/programming/pcre/$PKG_NAME-$PKG_VERSION.tar.bz2"
PKG_DEPENDS_TARGET="toolchain"
PKG_DEPENDS_HOST="ccache:host autotools:host autoconf:host"
PKG_SECTION="devel"
PKG_SHORTDESC="pcre: Perl Compatible Regulat Expressions"
PKG_LONGDESC="The PCRE library is a set of functions that implement regular expression pattern matching using the same syntax and semantics as Perl 5. PCRE has its own native API, as well as a set of wrapper functions that correspond to the POSIX regular expression API. The PCRE library is free, even for building commercial software."
PKG_TOOLCHAIN="autotools"
PKG_TOOLCHAIN="configure"
#PKG_BUILD_FLAGS="+pic:host"

PKG_CONFIGURE_OPTS_TARGET="--enable-jit \
			      --enable-utf8 \
			      --enable-unicode-properties \
			      --enable-pcre8 \
			      --enable-pcre16 \
			      --enable-cpp"

PKG_CONFIGURE_OPTS_HOST="$PKG_CONFIGURE_OPTS_TARGET"

post_makeinstall_target() {
  rm -rf $INSTALL/usr/bin
  sed -e "s:\(['= ]\)/usr:\\1$SYSROOT_PREFIX/usr:g" -i $SYSROOT_PREFIX/usr/bin/$PKG_NAME-config
}
