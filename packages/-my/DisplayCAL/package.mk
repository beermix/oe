PKG_NAME="DisplayCAL"
PKG_VERSION="3.3.1.0"
PKG_SITE="http://www.X.org"
PKG_URL="https://dl.dropboxusercontent.com/s/i14sk2shsh9umy6/DisplayCAL-3.3.1.0.tar.xz"
PKG_DEPENDS_TARGET="toolchain libX11 libXext libXtst libjpeg-turbo wxPython"
PKG_SECTION="service/system"

PKG_AUTORECONF="no"

make_target() {
  python setup.py build_ext
}

makeinstall_target() {
  python setup.py install --root=$INSTALL --prefix=/usr
}