PKG_NAME="beautifulsoup4"
PKG_VERSION="4.6.0"
PKG_SITE="https://pypi.python.org/pypi/PyAMF/"
PKG_URL="https://pypi.python.org/packages/fa/8d/1d14391fdaed5abada4e0f63543fef49b8331a34ca60c88bd521bcf7f782/beautifulsoup4-4.6.0.tar.gz"
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
  python setup.py build --cross-compile
}

makeinstall_target() {
  python setup.py install --root=$INSTALL --prefix=/usr
}

post_makeinstall_target() {
  find $INSTALL/usr/lib -name "*.py" -exec rm -rf "{}" ";"
  rm -rf $INSTALL/usr/lib/python*/site-packages/*/tests
}
