PKG_NAME="HandBrake"
PKG_VERSION="0.10.5"
PKG_URL="https://github.com/HandBrake/HandBrake/archive/$PKG_VERSION.tar.gz"
PKG_SOURCE_DIR="HandBrake-$PKG_VERSION"
PKG_DEPENDS_TARGET="toolchain openssl ffmpeg libdvdnav lame flac opus"

PKG_SECTION="devel"



configure_target() {
  cd $PKG_BUILD
  strip_lto
  strip_gold
  ./configure --prefix=/usr \
  	      --enable-qsv \
  	      --arch=x86_64 \
  	      --cross=$SPEC \
  	      --disable-gtk \
  	      --disable-x265
  	      --force \
  	      --verbose \
  	      --ar=$AR \
  	      --gcc=$CC \
  	      --ranlib=$RANLIB \
  	      --launch \
  	      --launch-jobs=8
}
