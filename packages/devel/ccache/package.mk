# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="ccache"
#PKG_VERSION="3.5.1a"
#PKG_SHA256="98b6386cbac1fe43dde209ecb65591803dc7fcc16153b824d58dee5908691ed5"
PKG_VERSION="3.5"
PKG_SHA256="bdd44b72ae4506a2e2deef9fefb15c606a474bbca7658cd2be26105155eec012"
PKG_LICENSE="GPL"
PKG_SITE="https://www.samba.org/ftp/ccache/?C=M;O=D"
PKG_URL="https://samba.org/ftp/ccache/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_HOST="make:host zlib:host"
PKG_LONGDESC="A compiler cache to speed up re-compilation of C/C++ code by caching."

PKG_CONFIGURE_OPTS_HOST="--with-bundled-zlib --disable-man --enable-more-warnings"

pre_configure_host() {
  export CC=$LOCAL_CC
  export CXX=$LOCAL_CXX

  export CFLAGS="-march=haswell -O3 -fstack-protector-strong -D_FORTIFY_SOURCE=2 -fno-plt -Wall"
  export CXXFLAGS="-march=haswell -O3 -fstack-protector-strong -D_FORTIFY_SOURCE=2 -fno-plt -Wall"
  export LDFLAGS="-march=haswell -Wl,-z,relro -Wl,-z,now -s"
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
