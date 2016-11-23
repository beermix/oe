################################################################################
#      This file is part of OpenELEC - http://www.openelec.tv
#      Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
#
#  OpenELEC is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 2 of the License, or
#  (at your option) any later version.
#
#  OpenELEC is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with OpenELEC.  If not, see <http://www.gnu.org/licenses/>.
################################################################################

PKG_NAME="ccache"
PKG_VERSION="3.3.3"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="http://ccache.samba.org/"
PKG_URL="http://samba.org/ftp/ccache/$PKG_NAME-$PKG_VERSION.tar.bz2"
PKG_DEPENDS_HOST="make:host libzz:host"
PKG_PRIORITY="optional"
PKG_SECTION="devel"
PKG_SHORTDESC="ccache: A fast compiler cache"
PKG_LONGDESC="Ccache is a compiler cache. It speeds up re-compilation of C/C++ code by caching previous compiles and detecting when the same compile is being done again."

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

CFLAGS="-march=native -O3 -pipe -fno-stack-protector -I$ROOT/$TOOLCHAIN/include"
LDFLAGS="-Wl,-O1,--as-needed -Wl,-Bsymbolic-functions -Wl,-z,relro -Wl,-rpath,$ROOT/$TOOLCHAIN/lib -L$ROOT/$TOOLCHAIN/lib -static -s"

PKG_CONFIGURE_OPTS_HOST="HOST_CCACHE_DO_INITIAL_SETUP"

post_makeinstall_host() {
# setup ccache
  $ROOT/$TOOLCHAIN/bin/ccache --max-size=$CCACHE_CACHE_SIZE
  $ROOT/$TOOLCHAIN/bin/ccache --set-config=compiler_check=string:$(gcc -dumpversion)-$(get_pkg_version gcc)

  mkdir -p $ROOT/$TOOLCHAIN/lib/ccache
    ln -sf $ROOT/$TOOLCHAIN/bin/ccache $ROOT/$TOOLCHAIN/lib/ccache/gcc
    ln -sf $ROOT/$TOOLCHAIN/bin/ccache $ROOT/$TOOLCHAIN/lib/ccache/g++
    ln -sf $ROOT/$TOOLCHAIN/bin/ccache $ROOT/$TOOLCHAIN/lib/ccache/${HOST_NAME}-gcc
    ln -sf $ROOT/$TOOLCHAIN/bin/ccache $ROOT/$TOOLCHAIN/lib/ccache/${HOST_NAME}-g++
}
