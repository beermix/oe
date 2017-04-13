PKG_NAME="mpv"
PKG_VERSION="v0.24.0"
PKG_GIT_URL="https://github.com/mpv-player/mpv"
PKG_DEPENDS_TARGET="toolchain ffmpeg libxkbcommon libass lua libav"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

pre_configure_target() {
  cd $ROOT/$PKG_BUILD
  rm -rf .$TARGET_NAME
}

configure_target() {
  ./bootstrap.py
  ./waf configure --prefix=/usr \
  		    --enable-static-build \
  		    --enable-libmpv-static \
  		    --disable-wayland \
  		    --disable-zsh-comp
}

make_target() {
  ./waf -v build
}

make_install_target() {
  ./waf install --destdir=$INSTALL
}