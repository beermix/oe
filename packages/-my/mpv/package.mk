PKG_NAME="mpv"
PKG_VERSION="dc5dfa5"
PKG_GIT_URL="https://github.com/mpv-player/mpv"
PKG_DEPENDS_TARGET="toolchain ffmpeg libxkbcommon libass lua"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

pre_configure_target() {
  cd $ROOT/$PKG_BUILD
  rm -rf .$TARGET_NAME
}

configure_target() {
  ./bootstrap.py
  ./waf dist
  ./waf configure --prefix=/usr \
  		    --disable-wayland \
  		    --disable-android \
  		    --disable-caca \
  		    --disable-cdda \
  		    --disable-cocoa \
  		    --disable-coreaudio \
  		    --disable-libv4l2 \
  		    --disable-opensles \
  		    --disable-rpi \
  		    --disable-rsound \
  		    --disable-rubberband \
  		    --disable-uchardet \
  		    --disable-vapoursynth \
  		    --disable-vapoursynth-lazy \
  		    --disable-vdpau
}

make_target() {
  ./waf build -j4
}

make_install_target() {
  ./waf install --destdir=$INSTALL
}