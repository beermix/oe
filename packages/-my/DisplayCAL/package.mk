PKG_NAME="DisplayCAL"
PKG_VERSION="3.2.1.0"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="OSS"
PKG_SITE="http://www.X.org"
PKG_URL="https://sourceforge.net/projects/dispcalgui/files/release/3.2.1.0/DisplayCAL-3.2.1.0.tar.gz"
PKG_DEPENDS_TARGET="toolchain libX11 libXext libXtst libjpeg-turbo"

PKG_SECTION="service/system"
PKG_AUTORECONF="no"


configure_target() {
  :
}

make_target() {
  python setup.py build
  python setup.py install
  
}
