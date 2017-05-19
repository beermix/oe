PKG_NAME="mpv"
PKG_VERSION="v0.25.0"
PKG_GIT_URL="https://github.com/mpv-player/mpv"
PKG_DEPENDS_TARGET="toolchain libass"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

pre_configure_target() {
  cd $ROOT/$PKG_BUILD
  rm -rf .$TARGET_NAME
  strip_lto
  strip_gold
  #export LIBS="$LIBS -lavcodec -lXv -lXext -lasound -lavfilter -lXext -lvdpau-lva-x11 -lX11 -lva -lva-drm -lva -lswresample -lm -lswscale"
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
  		    --disable-static-build \
  		    LDFLAGS=-lresolv
}

make_target() {
  ./waf build -j 4 
}

make_install_target() {
  ./waf install --destdir=$INSTALL
}