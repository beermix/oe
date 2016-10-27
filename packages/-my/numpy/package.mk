PKG_NAME="numpy"
PKG_VERSION="4092a9e"
PKG_SITE="https://pypi.python.org/pypi/PyAMF/"
PKG_GIT_URL="https://github.com/numpy/numpy.git"
PKG_DEPENDS_TARGET="toolchain Python distutilscross:host"
PKG_PRIORITY="optional"
PKG_SECTION="python/system"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

pre_configure_target() {
  cd $ROOT/$PKG_BUILD
  rm -rf .$TARGET_NAME

  export PYTHONXCPREFIX="$SYSROOT_PREFIX/usr"
  export LDFLAGS="$LDFLAGS -L$SYSROOT_PREFIX/usr/lib -L$SYSROOT_PREFIX/lib"
  export LDSHARED="$CC -shared"
  
    sed -e "s|#![ ]*/usr/bin/python$|#!/usr/bin/python|" \
          -e "s|#![ ]*/usr/bin/env python$|#!/usr/bin/env python|" \
          -e "s|#![ ]*/bin/env python$|#!/usr/bin/env python|" \
          -i $(find . -name '*.py')
}
make_target() {
cd numpy
python setup.py config_fc --cross-compile build echo "Building Python3" 
cd ..


python setup.py config_fc --cross-compile build

  python setup.py build --cross-compile
}

makeinstall_target() {
  python setup.py install --root=$INSTALL --prefix=/usr
  find $INSTALL/usr/lib -name "*.py" -exec rm -rf "{}" ";"
  rm -rf $INSTALL/usr/lib/python*/site-packages/*/tests  
} 

post_makeinstall_target() {

  cd numpy
  python setup.py config_fc --cross-compile install --prefix=/usr --optimize=1
  
  install -m755 -d "${pkgdir}/usr/share/licenses/python-numpy"
  install -m644 LICENSE.txt "${pkgdir}/usr/share/licenses/python-numpy/"
  	
  install -m755 -d "${pkgdir}/usr/include/python${_pyinc}"
}