PKG_NAME="flac"
PKG_VERSION="55fba7e"
PKG_SITE="https://xiph.org/flac/"
PKG_GIT_URL="https://github.com/xiph/flac"
PKG_DEPENDS_TARGET="toolchain libogg"
PKG_SECTION="audio"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

PKG_CONFIGURE_OPTS_TARGET="--enable-static \
                           --disable-shared \
                           --disable-rpath \
                           --disable-altivec \
                           --disable-doxygen-docs \
                           --disable-thorough-tests \
                           --disable-cpplibs \
                           --disable-xmms-plugin \
                           --disable-oggtest \
                           --with-ogg=$SYSROOT_PREFIX/usr \
                           --with-gnu-ld \
                           --enable-sse \
                           --enable-avx"

if [ $TARGET_ARCH = "x86_64" ]; then
  PKG_CONFIGURE_OPTS_TARGET="$PKG_CONFIGURE_OPTS_TARGET --enable-sse"
else
  PKG_CONFIGURE_OPTS_TARGET="$PKG_CONFIGURE_OPTS_TARGET --disable-sse"
fi

pre_configure_target() {
  sh autogen.sh
  strip_lto
  export CFLAGS="$CFLAGS -fPIC -DPIC"
}

post_makeinstall_target() {
  rm -rf $INSTALL/usr/bin
}
