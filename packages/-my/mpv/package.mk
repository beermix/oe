PKG_NAME="mpv"
PKG_VERSION="v0.23.0"
PKG_GIT_URL="https://github.com/mpv-player/mpv"
PKG_DEPENDS_TARGET="toolchain libass"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

pre_configure_target() {
  cd $ROOT/$PKG_BUILD
  rm -rf .$TARGET_NAME
  
  export LDFLAGS="$LDFLAGS -lresolv -lavresample -lm -lavformat -lX11 -lasound -lavutil -lavcodec"
  
  #strip_lto
  #strip_gold
}

configure_target() {
  ./bootstrap.py
  ./waf dist
  ./waf configure --prefix=/usr \
  		    --disable-debug-build \
  		    --disable-manpage-build \
  		    --disable-static-build
}

make_target() {
  ./waf build -j3
}

make_install_target() {
  ./waf install --destdir=$INSTALL
}