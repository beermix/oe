PKG_NAME="fbset"
PKG_VERSION="2.1"
PKG_URL="https://dl.dropboxusercontent.com/s/6l4mm14rv1jg7os/fbset_2.1.orig.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="audio"
PKG_SHORTDESC="DTS Coherent Acoustics decoder with support for HD extensions"
PKG_LONGDESC="DTS Coherent Acoustics decoder with support for HD extensions"




make_target() {
  make SHELL='sh -x' CC="$CC" CFLAGS="$CFLAGS" CPPFLAGS="$CPPFLAGS" LDFLAGS="$LDFLAGS"
}

post_make_target() {
  mkdir -p $INSTALL/bin/
  #mkdir -p $INSTALL_DEV/usr/bin/
  cp $PKG_BUILD/fbset $INSTALL/bin/
  cp $PKG_BUILD/con2fbmap $INSTALL/bin/
  cp $PKG_BUILD/modeline2fb $INSTALL/bin/
}


makeinstall_target() {
  :
}
