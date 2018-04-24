PKG_NAME="whois"
PKG_VERSION="7735818"
PKG_SITE="http://ftp.debian.org/"
PKG_URL="http://ftp.debian.org/debian/pool/main/w/whois/${PKG_NAME}_${PKG_VERSION}.tar.xz"
PKG_URL="https://github.com/rfc1036/whois/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain libidn2"
PKG_SECTION="network"

makeinstall_target() {
  : # nop
}
