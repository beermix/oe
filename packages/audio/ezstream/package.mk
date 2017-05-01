PKG_NAME="ezstream"
PKG_VERSION="0.6.0"
PKG_URL="http://downloads.xiph.org/releases/ezstream/ezstream-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain libshout libxml2 taglib libvorbis libtheora opus taglib"
PKG_SECTION="tools"
PKG_AUTORECONF="yes"

pre_configure_target() {
  export LIBS="$LIBS -lvorbis -lvorbisenc -logg -lFLAC -lshout -lspeex -ltheora -lopus -ltag -lshout -pthread"
  strip_lto
}

PKG_CONFIGURE_OPTS_TARGET="--disable-rpath --disable-debug"