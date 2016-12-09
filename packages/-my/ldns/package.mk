PKG_NAME="ldns"
PKG_VERSION="1.6.17"
PKG_URL="http://www.nlnetlabs.nl/downloads/ldns/ldns-1.6.17.tar.gz"
PKG_DEPENDS_TARGET="toolchain Python ffmpeg flac bzip2 libsamplerate"

PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

configure_target() {
  cd $ROOT/$PKG_BUILD
  ./configure
}


make_target() {
  cd $ROOT/$PKG_BUILD

}
