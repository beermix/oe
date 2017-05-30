PKG_NAME="mpv"
PKG_VERSION="v0.22.0"
PKG_GIT_URL="https://github.com/mpv-player/mpv"
PKG_DEPENDS_TARGET="toolchain libass"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

pre_configure_target() {
  cd $ROOT/$PKG_BUILD
  rm -rf .$TARGET_NAME
  
  strip_lto
  #strip_gold
  
  export LDFLAGS="$LDFLAGS -lresolv"
}

configure_target() {
  ./bootstrap.py
  ./waf dist
  ./waf configure --prefix=/usr \
  		    --disable-debug-build \
  		    --disable-manpage-build \
  		    --disable-dvdnav \
  		    --disable-dvdread \
  		    --disable-apple-remote \
  		    --disable-static-build 
}

make_target() {
  ./waf build -j1
  
}

make_install_target() {
  ./waf install --destdir=$INSTALL
}