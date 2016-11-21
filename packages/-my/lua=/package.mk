PKG_NAME="lua"
PKG_VERSION="5.3.3"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="MIT"
PKG_SITE="http://www.lua.org/"
PKG_URL="http://www.lua.org/ftp/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain readline netbsd-curses"
PKG_PRIORITY="optional"
PKG_SECTION="system"
PKG_SHORTDESC="whois is a client-side application which queries the whois directory service for information pertaining to a particular domain name."
PKG_LONGDESC="whois is a client-side application which queries the whois directory service for information pertaining to a particular domain name."
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"


makeinstall_target() {
#. config/options $1

#cd $PKG_BUILD

# build and install host packages
  make CFLAGS=-O2 LDFLAGS=-static PREFIX=/usr all linux -j1
}