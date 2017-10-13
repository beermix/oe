PKG_NAME="ps3remote"
PKG_VERSION="7d20fa3e"
PKG_GIT_URL="https://github.com/rootlis/ps3remote"
PKG_DEPENDS_TARGET="toolchain systemd"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

make_target() {
  cd $PKG_BUILD
  rm -rf .$TARGET_NAME
  strip_hard
  make \
  	CC="$CC" \
  	CFLAGS="$CFLAGS -Wall -DDEBUG=0" \
  	LDFLAGS="$LDFLAGS" \
  	RANLIB="$RANLIB" \
  	AR="$AR" \
  	STRIP="$STRIP" \
  	-j1
}

post_make_target() {
  mkdir -p $INSTALL/usr/bin/
  mkdir -p $INSTALL_DEV/usr/bin/
  $STRIP $PKG_BUILD/ps3remote
  cp $PKG_BUILD/ps3remote $INSTALL/usr/bin/
}

makeinstall_target() {
  :
}

post_install () {
  enable_service ps3remote.service
}