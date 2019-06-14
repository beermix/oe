PKG_NAME="ezstream"
PKG_VERSION="0.6.0"
PKG_URL="http://downloads.xiph.org/releases/ezstream/ezstream-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain libshout libxml2 taglib libvorbis libtheora opus taglib"
PKG_SECTION="tools"
PKG_TOOLCHAIN="autotools"

PKG_CONFIGURE_OPTS_TARGET="--disable-rpath --disable-debug"

pre_configure_target() {
  CFLAGS="$CFLAGS -fPIC -DPIC"

  # alsa-lib fails building with LTO support
    strip_lto
}