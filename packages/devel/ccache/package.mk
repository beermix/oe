# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="ccache"
PKG_VERSION="3.7.2"
PKG_SHA256="f312b5714849ddb06e5f0668008707c69541b5e3a921aea16545c19b92c09905"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/ccache/ccache/releases"
PKG_URL="https://github.com/ccache/ccache/releases/download/v$PKG_VERSION/ccache-$PKG_VERSION.tar.gz"
PKG_DEPENDS_HOST="make:host"
PKG_LONGDESC="A compiler cache to speed up re-compilation of C/C++ code by caching."

PKG_CONFIGURE_OPTS_HOST="--with-bundled-zlib"

pre_configure_host() {
  export CC=$LOCAL_CC
  export CXX=$LOCAL_CXX
}

post_makeinstall_host() {
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
