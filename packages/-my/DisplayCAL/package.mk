PKG_NAME="DisplayCAL"
PKG_VERSION="3.3.1.0"
PKG_SITE="https://sourceforge.net/projects/dispcalgui"
PKG_URL="https://sourceforge.net/projects/dispcalgui/files/release/$PKG_VERSION/DisplayCAL-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain libX11 libXext libXtst libjpeg-turbo wxPython numpy"
PKG_SECTION="system"
PKG_AUTORECONF="no"

make_target() {
  python setup.py build
}

makeinstall_target() {
  python setup.py install --root=$INSTALL --prefix=/usr --optimize=1
}

post_makeinstall_target() {
  rm -rf $INSTALL/etc/udev
  mkdir -pv $INSTALL/root/-3SDC/oe/build.OE-Generic.x86_64-8.0-devel/toolchain/bin
  ln -sfv python $INSTALL/root/-3SDC/oe/build.OE-Generic.x86_64-8.0-devel/toolchain/bin/python
}