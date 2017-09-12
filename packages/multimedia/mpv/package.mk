PKG_NAME="mpv"
PKG_VERSION="v0.26.0"
#PKG_VERSION="v0.24.0"
PKG_GIT_URL="https://github.com/mpv-player/mpv"
PKG_DEPENDS_TARGET="toolchain libass lua"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

get_graphicdrivers

LTO_SUPPORT="no"
GOLD_SUPPORT="no"

pre_configure_target() {
  cd $ROOT/$PKG_BUILD
  rm -rf .$TARGET_NAME
  export LDFLAGS="$LDFLAGS -lresolv"
  strip_gold
}

configure_target() {
  ./bootstrap.py
  ./waf dist
  ./waf configure --prefix=/usr \
  		    --confdir=/storage/.config/mpv \
  		    --disable-manpage-build \
  		    --check-c-compiler=gcc \
  		    --disable-dvdnav \
  		    --disable-dvdread \
  		    --disable-apple-remote \
  		    --disable-static-build 
}

make_target() {
  ./waf build
  ./waf install --prefix=$INSTALL
}