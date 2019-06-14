# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="pcre"
PKG_VERSION="8.43"
PKG_SHA256="91e762520003013834ac1adb4a938d53b22a216341c061b0cf05603b290faf6b"
PKG_LICENSE="OSS"
PKG_SITE="https://github.com/svn2github/pcre/"
PKG_URL="https://ftp.pcre.org/pub/pcre/$PKG_NAME-$PKG_VERSION.tar.bz2"
PKG_DEPENDS_HOST="gcc:host cmake:host zlib:host"
PKG_DEPENDS_TARGET="toolchain zlib"
PKG_LONGDESC="A set of functions that implement regular expression pattern matching."
PKG_TOOLCHAIN="cmake-make"
PKG_BUILD_FLAGS="+pic:host"

PKG_CONFIGURE_OPTS_HOST="--prefix=$TOOLCHAIN \
			    --enable-utf8 \
			    --enable-unicode-properties \
			    --enable-jit"

PKG_CMAKE_OPTS_HOST="-DBUILD_SHARED_LIBS=0 \
			-DCMAKE_BUILD_TYPE=Release \
			-DPCRE_SUPPORT_UNICODE_PROPERTIES=1 \
			-DPCRE_SUPPORT_UTF=1 \
			-DPCRE_SUPPORT_JIT=1"

PKG_CONFIGURE_OPTS_TARGET="--enable-utf8 \
			      --enable-pcre16 \
			      --enable-unicode-properties \
			      --enable-jit"


PKG_CMAKE_OPTS_TARGET="-DBUILD_SHARED_LIBS=1 \
			  -DCMAKE_BUILD_TYPE=Release \
			  -DPCRE_BUILD_PCRE16=1 \
			  -DPCRE_SUPPORT_UNICODE_PROPERTIES=1 \
			  -DPCRE_SUPPORT_UTF=1 \
			  -DPCRE_SUPPORT_JIT=1"

#post_makeinstall_target() {
#  rm -rf $INSTALL/usr/bin
#  sed -e "s:\(['= ]\)/usr:\\1$SYSROOT_PREFIX/usr:g" -i $SYSROOT_PREFIX/usr/bin/$PKG_NAME-config
#}
