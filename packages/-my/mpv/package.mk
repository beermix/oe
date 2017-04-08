PKG_NAME="mpv"
PKG_VERSION="v0.24.0"
PKG_SITE="http://qt-project.org"
PKG_GIT_URL="https://github.com/mpv-player/mpv"
PKG_DEPENDS_TARGET="toolchain ffmpeg libass lua"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

pre_configure_target() {
  cd $ROOT/$PKG_BUILD
  rm -rf .$TARGET_NAME
}

configure_target() {
  ./waf configure --prefix=/usr \
  		    --mandir=/usr/share/man \
  		    --confdir=/etc/mpv \
  		    --enable-runtime-cpudetection \
  		    --enable-cross-compile \
  		    --enable-alsa \
  		    --enable-libass \
  		    --enable-libmpv-shared \
  		    --enable-rsound \
  		    --enable-xrandr \
  		    --enable-xss \
  		    --disable-zsh-comp
  		    
./waf -v build
  make check
}