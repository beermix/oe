PKG_NAME="whois"
PKG_VERSION="5.2.13"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="http://ftp.debian.org/"
PKG_URL="http://ftp.debian.org/debian/pool/main/w/whois/${PKG_NAME}_${PKG_VERSION}.tar.xz"
PKG_DEPENDS_TARGET="toolchain libidn"
PKG_SECTION="system"
PKG_SHORTDESC="whois is a client-side application which queries the whois directory service for information pertaining to a particular domain name."
PKG_LONGDESC="whois is a client-side application which queries the whois directory service for information pertaining to a particular domain name."
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

make_target() {
  make mkpasswd
}
