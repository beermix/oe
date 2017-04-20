PKG_NAME="mpv"
PKG_VERSION="51518dd"
PKG_GIT_URL="https://github.com/mpv-player/mpv"
PKG_DEPENDS_TARGET="toolchain ffmpeg libxkbcommon libass lua"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

pre_configure_target() {
  cd $ROOT/$PKG_BUILD
  rm -rf .$TARGET_NAME
  
  #strip_lto
  #strip_gold
}

configure_target() {
  ./bootstrap.py
  ./waf dist
  ./waf configure --prefix=/usr \
  		    --disable-wayland \
  		    --disable-libmpv-static \
  		    --disable-static-build \
  		    --disable-debug-build \
  		    --disable-manpage-build \
  		    --disable-apple-remote \
  		    --disable-macos-touchbar
}

make_target() {
  ./waf build -j1
}

make_install_target() {
  ./waf install --destdir=$INSTALL
}