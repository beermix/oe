PKG_NAME="MPlayer"
#PKG_VERSION="export-snapshot"
PKG_VERSION="1.3.0"
PKG_URL="ftp://ftp.mplayerhq.hu/MPlayer/releases/MPlayer-$PKG_VERSION.tar.xz"
#PKG_URL="ftp://ftp.mplayerhq.hu/MPlayer/releases/mplayer-export-snapshot.tar.bz2"
#PKG_SOURCE_DIR="mplayer-export-2016-10-07"
PKG_DEPENDS_TARGET="toolchain libiconv"
PKG_PRIORITY="optional"
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
  	      --enable-iconv \
  	      --disable-smb \
  	      --disable-faad \
  	      --disable-faac
}