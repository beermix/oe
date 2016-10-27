PKG_NAME="pixiewps"
PKG_VERSION="1448fff"
PKG_URL="https://github.com/wiire/pixiewps/archive/$PKG_VERSION.tar.gz"
#PKG_DEPENDS_TARGET="toolchain sqlite libpcap"
PKG_PRIORITY="optional"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"


post_target() {
cd src
make V=1 CCFLAGS="-std=c99 $optcflags $optldflags"
install -Dm 755 pixiewps "$butch_install_dir""$butch_prefix"/bin/pixiewps
}