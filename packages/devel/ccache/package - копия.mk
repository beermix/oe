# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="ccache"
PKG_VERSION="3.7.5"
PKG_SHA256="e51c611a3da865754cb0ff1ddd95bd7a6acac603576c0bd39583f8cc30af28d2"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/ccache/ccache/releases"
PKG_URL="https://github.com/ccache/ccache/releases/download/v$PKG_VERSION/ccache-$PKG_VERSION.tar.xz"
PKG_DEPENDS_HOST="make:host"
PKG_LONGDESC="A compiler cache to speed up re-compilation of C/C++ code by caching."
PKG_TOOLCHAIN="manual"

PKG_CONFIGURE_OPTS_HOST="--with-bundled-zlib --disable-man --disable-option-checking"

pre_configure_host() {
  export CC=$LOCAL_CC
  export CXX=$LOCAL_CXX
}

post_makeinstall_host() {
 mkdir -p $TOOLCHAIN/bin
 ln -s  /home/user/.bin/ccache $TOOLCHAIN/bin/ccache
# setup ccache
  if [ -z "$CCACHE_DISABLE" ]; then
    $TOOLCHAIN/bin/ccache --max-size=$CCACHE_CACHE_SIZE
  fi

  cat > $TOOLCHAIN/bin/host-gcc <<EOF
#!/bin/sh
$TOOLCHAIN/bin/ccache $CC "\$@"
EOF

  chmod +x $TOOLCHAIN/bin/host-gcc

  cat > $TOOLCHAIN/bin/host-g++ <<EOF
#!/bin/sh
$TOOLCHAIN/bin/ccache $CXX "\$@"
EOF

  chmod +x $TOOLCHAIN/bin/host-g++
}
