PKG_NAME="testdisk"
pkgver=7.0
PKG_URL="http://www.cgsecurity.org/$PKG_NAME-$pkgver.tar.bz2"
#PKG_GIT_URL="https://git.cgsecurity.org/testdisk.git"
PKG_DEPENDS_TARGET="toolchain readline"
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

pre_configure_target() {
  export LIBS="-lterminfo"
}

pre_configure_host() {
  export LIBS="-lterminfo"
}

PKG_CONFIGURE_OPTS_TARGET="--enable-static \
			      --disable-shared \
			      --without-ewf \
			      --enable-sudo" 


PKG_CONFIGURE_OPTS_INIT="$PKG_CONFIGURE_OPTS_TARGET"

