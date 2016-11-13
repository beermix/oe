PKG_NAME="wxWidgets"
PKG_VERSION="v3.1.0"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="wxWindows Licence"
PKG_SITE="http://www.wxwidgets.org/"
PKG_GIT_URL="https://github.com/wxWidgets/wxWidgets"
PKG_DEPENDS_TARGET="toolchain gtk+ libSM"
PKG_SECTION="depends"
PKG_SHORTDESC="A cross-platform GUI and tools library for GTK, MS Windows, and MacOS."
PKG_LONGDESC="A cross-platform GUI and tools library for GTK, MS Windows, and MacOS."
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"


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
			   --with-opengl"


pre_configure_target() {
  export CFLAGS="$CFLAGS -fPIC"
  export CXXFLAGS="$CXXFLAGS -fPIC"
  export LDFLAGS="$LDFLAGS -fPIC"
}

post_makeinstall_target() {
  #ln -sf $SYSROOT_PREFIX/usr/lib/wx/config/i686-libreelec-linux-gnu-gtk2-unicode-3.0 $SYSROOT_PREFIX/usr/bin/wx-config
  #$SED "s:^prefix=.*:prefix=$SYSROOT_PREFIX/usr:g" $SYSROOT_PREFIX/usr/bin/wx-config
  rm -rf $INSTALL
}
