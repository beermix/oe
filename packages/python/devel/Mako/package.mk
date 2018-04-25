################################################################################
#      This file is part of LibreELEC - https://LibreELEC.tv
#      Copyright (C) 2016 Team LibreELEC
#
#  LibreELEC is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 2 of the License, or
#  (at your option) any later version.
#
#  LibreELEC is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with LibreELEC.  If not, see <http://www.gnu.org/licenses/>.
################################################################################

PKG_NAME="Mako"
PKG_VERSION="1.0.7"
PKG_ARCH="any"
PKG_LICENSE="OSS"
PKG_SITE="http://www.makotemplates.org"
PKG_URL="https://pypi.python.org/packages/eb/f3/67579bb486517c0d49547f9697e36582cd19dafb5df9e687ed8e22de57fa/Mako-1.0.7.tar.gz"
PKG_DEPENDS_TARGET="toolchain Python2:host distutilscross:host"
PKG_DEPENDS_HOST="$PKG_DEPENDS_TARGET"
PKG_SECTION="python/devel"
PKG_SHORTDESC="Hyperfast and lightweight templating for the Python platform."
PKG_TOOLCHAIN="manual"

pre_build_host() {
  mkdir -p $PKG_BUILD/.$HOST_NAME
  cp -RP $PKG_BUILD/* $PKG_BUILD/.$HOST_NAME
}

pre_build_target() {
  mkdir -p $PKG_BUILD/.$TARGET_NAME
  cp -RP $PKG_BUILD/* $PKG_BUILD/.$TARGET_NAME
}

pre_make_host() {
  export CFLAGS="-I$TOOLCHAIN/include/python2.7 $CFLAGS"
  export LDSHARED="$CC -shared"
  cd .$HOST_NAME
}

pre_make_target() {
  export PYTHONXCPREFIX="$SYSROOT_PREFIX/usr"
  export LDFLAGS="$LDFLAGS -L$SYSROOT_PREFIX/usr/lib -L$SYSROOT_PREFIX/lib"
  export LDSHARED="$CC -shared"
  cd .$TARGET_NAME
}

make_host() {
  python setup.py build
}

make_target() {
  python setup.py build --cross-compile
}

makeinstall_target() {
  python setup.py install --root=$INSTALL --prefix=/usr
}

makeinstall_host() {
  python setup.py install --prefix=$TOOLCHAIN
}

post_makeinstall_target() {
  find $INSTALL/usr/lib/python*/site-packages/  -name "*.py" -exec rm -rf {} ";"
}
