# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="pcre"
PKG_VERSION="8.43"
PKG_SHA256="91e762520003013834ac1adb4a938d53b22a216341c061b0cf05603b290faf6b"
PKG_LICENSE="OSS"
PKG_SITE="https://github.com/svn2github/pcre/"
PKG_URL="https://ftp.pcre.org/pub/pcre/$PKG_NAME-$PKG_VERSION.tar.bz2"
PKG_DEPENDS_HOST="gcc:host"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="A set of functions that implement regular expression pattern matching."
PKG_TOOLCHAIN="cmake-make"
#PKG_TOOLCHAIN="configure"
PKG_BUILD_FLAGS="+pic:host"
#PKG_BUILD_FLAGS="+speed"

PKG_CONFIGURE_OPTS_HOST="--prefix=$TOOLCHAIN \
			    --enable-utf8 \
			    --enable-unicode-properties \
			    --enable-jit \
			    --with-gnu-ld \
			    --disable-shared \
			    --enable-static"

PKG_CONFIGURE_OPTS_TARGET="--enable-unicode-properties \
			      --enable-pcre16 \
			      --enable-ji"

PKG_CMAKE_OPTS_HOST="-DBUILD_SHARED_LIBS=OFF \
			-DPCRE_BUILD_PCRECPP=ON \
			-DPCRE_SUPPORT_UNICODE_PROPERTIES=ON \
			-DPCRE_SUPPORT_UTF=ON \
			-DPCRE_SUPPORT_JIT=ON \
			-DPCRE_BUILD_TESTS=OFF"

PKG_CMAKE_OPTS_TARGET="-DBUILD_SHARED_LIBS=ON \
			  -DPCRE_BUILD_PCRE16=ON \
			  -DPCRE_BUILD_PCRECPP=ON \
			  -DPCRE_SUPPORT_UNICODE_PROPERTIES=ON \
			  -DPCRE_SUPPORT_UTF=ON \
			  -DPCRE_SUPPORT_JIT=ON \
			  -DPCRE_BUILD_TESTS=OFF \
			  -DCMAKE_BUILD_TYPE=Release"

post_makeinstall_target() {
  rm -rf $INSTALL/usr/bin
  #sed -e "s:\(['= ]\)/usr:\\1$SYSROOT_PREFIX/usr:g" -i $SYSROOT_PREFIX/usr/bin/$PKG_NAME-config
}
