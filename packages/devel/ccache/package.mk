# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="ccache"
PKG_VERSION="3.6"
PKG_SHA256="a6b129576328fcefad00cb72035bc87bc98b6a76aec0f4b59bed76d67a399b1f"
PKG_LICENSE="GPL"
PKG_SITE="https://www.samba.org/ftp/ccache/?C=M;O=D"
PKG_URL="https://samba.org/ftp/ccache/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_HOST="make:host zlib:host"
PKG_LONGDESC="A compiler cache to speed up re-compilation of C/C++ code by caching."

PKG_CONFIGURE_OPTS_HOST="--with-bundled-zlib --disable-man --enable-more-warnings --disable-silent-rules"

pre_configure_host() {
  export CC=$LOCAL_CC
  export CXX=$LOCAL_CXX

  export CFLAGS="-march=haswell -O2 -fstack-protector-strong -fno-plt -Wall"
  export CXXFLAGS="-march=haswell -O2 -fstack-protector-strong -fno-plt -Wall"
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
