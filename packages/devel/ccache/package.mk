# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)

PKG_NAME="ccache"
PKG_VERSION="3.5"
PKG_SHA256="bdd44b72ae4506a2e2deef9fefb15c606a474bbca7658cd2be26105155eec012"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="https://www.samba.org/ftp/ccache/?C=M;O=D"
PKG_URL="https://samba.org/ftp/ccache/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_HOST="make:host"
PKG_SECTION="devel"
PKG_SHORTDESC="ccache: A fast compiler cache"
PKG_LONGDESC="Ccache is a compiler cache. It speeds up re-compilation of C/C++ code by caching previous compiles and detecting when the same compile is being done again."

export CC=$LOCAL_CC
export CXX=$LOCAL_CXX

#export CFLAGS="-march=haswell -O2 -fstack-protector-strong -Wp,-D_FORTIFY_SOURCE=2"

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

 strip $TOOLCHAIN/bin/ccache 
}
