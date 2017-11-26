PKG_NAME="atk"
PKG_VERSION="2.27.1"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="http://library.gnome.org/devel/atk/"
PKG_URL="http://ftp.acc.umu.se/pub/gnome/sources/atk/2.27/atk-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="accessibility"
PKG_SHORTDESC="ATK - Accessibility Toolkit"
PKG_LONGDESC="ATK provides the set of accessibility interfaces that are implemented by other toolkits and applications. Using the ATK interfaces, accessibility tools have full access to view and control running applications."

PKG_USE_MESON="no"

PKG_CONFIGURE_OPTS_TARGET="--disable-rebuilds --disable-glibtest"

