PKG_NAME="html5lib"
PKG_VERSION="1.0.1"
PKG_SITE="https://pypi.python.org/pypi/html5lib/"
PKG_URL="https://files.pythonhosted.org/packages/85/3e/cf449cf1b5004e87510b9368e7a5f1acd8831c2d6691edd3c62a0823f98f/html5lib-1.0.1.tar.gz"
PKG_DEPENDS_TARGET="toolchain Python2 distutilscross:host"
PKG_SECTION="python/system"
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

make_host() {
  python setup.py build
}

makeinstall_host() {
  python setup.py install --prefix=$TOOLCHAIN
}

make_target() {
  python setup.py build
}

makeinstall_target() {
  python setup.py install --root=$INSTALL --prefix=/usr
}

post_makeinstall_target() {
  find $INSTALL/usr/lib -name "*.py" -exec rm -rf "{}" ";"
  rm -rf $INSTALL/usr/lib/python*/site-packages/*/tests
}