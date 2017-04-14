PKG_NAME="MPlayer"
PKG_VERSION="ch0414"
PKG_URL="https://dl.dropboxusercontent.com/s/3ht4a92bbgk5zj0/MPlayer-ch0414.tar.xz"
#PKG_SOURCE_DIR="mplayer-export-2017-04-14"
PKG_DEPENDS_TARGET="toolchain ffmpeg faad2"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

configure_target() {
  cd $ROOT/$PKG_BUILD
  strip_lto
  ./configure --enable-runtime-cpudetection \
  		--disable-inet6 \
  		--enable-big-endian \
  		--prefix=/usr \
  		--yasm=$ROOT/$TOOLCHAIN/bin/yasm  \
  		--nm="$NM" \
  		--ar="$AR" \
  		--as="$CC" \
  		--cc="$CC" \
  		--host-cc="$HOST_CC" \
  		--enable-mmx \
  		--enable-sse \
  		--enable-sse2 \
  		--enable-sse3 \
  		--enable-ssse3 \
  		--enable-sse4 \
  		--enable-avx \
  		--disable-iconv \
  		--disable-smb \
  		--enable-faad \
  		--disable-faac
}
