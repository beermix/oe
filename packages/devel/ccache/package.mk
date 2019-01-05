# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)

PKG_NAME="ccache"
PKG_SITE="https://www.samba.org/ftp/ccache/?C=M;O=D"
PKG_VERSION="3.5.1a"
PKG_SHA256="98b6386cbac1fe43dde209ecb65591803dc7fcc16153b824d58dee5908691ed5"
#PKG_VERSION="3.3.6"
#PKG_SHA256="eac8d2a5055014bebae1434d9b7c66c25d64323800808c27a4534cee167e6bea"
PKG_LICENSE="GPL"
PKG_URL="https://samba.org/ftp/ccache/$PKG_NAME-$PKG_VERSION.tar.bz2"
PKG_DEPENDS_HOST="make:host"
PKG_LONGDESC="A compiler cache to speed up re-compilation of C/C++ code by caching."

export CC=$LOCAL_CC
export CXX=$LOCAL_CXX

export CFLAGS="-march=native -O2 -fstack-protector-strong"
export CXXFLAGS="-march=native -O2 -fstack-protector-strong"
export LDFLAGS="-Wl,-O1,--sort-common,--as-needed,-z,relro,-z,now -s"

PKG_CONFIGURE_OPTS_HOST="--with-bundled-zlib"

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
