PKG_NAME="libmediainfo-shared"
PKG_VERSION="17.12"
PKG_SHA256="6189804822fe90ed4c86beeb8f054eda3381ae3728b885842683c6bf768dca41"
PKG_LICENSE="GPL"
PKG_SITE="http://mediaarea.net/en/MediaInfo/Download/Source"
PKG_URL="https://github.com/MediaArea/MediaInfoLib/archive/v$PKG_VERSION.tar.gz"
PKG_SOURCE_DIR="MediaInfoLib-$PKG_VERSION"
PKG_DEPENDS_TARGET="toolchain libzen zlib"
PKG_SHORTDESC="MediaInfo is a convenient unified display of the most relevant technical and tag data for video and audio files"
PKG_TOOLCHAIN="make"

make_target() {
  CXXFLAGS="$CXXFLAGS -lpthread -lzen"
  cd Project/GNU/Library
  do_autoreconf
  ./configure \
        --host=$TARGET_NAME \
        --build=$HOST_NAME \
        --disable-static \
        --enable-shared \
        --prefix=/usr \
        --enable-visibility \
        --with-gnu-ld \
        --without-libcurl \
        --without-libmms
  make
}
