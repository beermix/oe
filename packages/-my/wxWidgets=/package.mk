PKG_NAME="wxWidgets"
PKG_VERSION="3.0.2"
PKG_SITE="http://www.wxwidgets.org/"
PKG_URL="ftp://ftp.wxwidgets.org/pub/$PKG_VERSION/$PKG_NAME-$PKG_VERSION.tar.bz2"
PKG_DEPENDS_TARGET="toolchain gtk+ expat"

PKG_TOOLCHAIN="autotools"


PKG_CONFIGURE_OPTS_TARGET="--disable-shared \
			      --enable-static \
			      --disable-debug_flag \
			      --enable-unicode \
			      --enable-graphics_ctx \
			      --disable-mediactrl \
			      --disable-monolithic \
			      --disable-mslu \
			      --enable-silent-rules \
			      --disable-precomp-headers \
			      --with-opengl \
			      --enable-cxx11"


pre_configure_target() {
  export CFLAGS="$CFLAGS -fPIC"
  export CXXFLAGS="$CXXFLAGS -fPIC"
  export LDFLAGS="$LDFLAGS -fPIC"
}


post_makeinstall_target() {
  rm -rf $INSTALL
}