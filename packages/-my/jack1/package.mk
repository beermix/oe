PKG_NAME="jack1"
PKG_VERSION="efd4794"
PKG_GIT_URL="https://github.com/jackaudio/jack1.git"
PKG_DEPENDS_TARGET="toolchain Python ffmpeg flac bzip2 libsamplerate"

PKG_SECTION="my"

PKG_AUTORECONF="no"

configure_target() {
  cd $PKG_BUILD
  autoreconf -if
  ./configure
}


