PKG_NAME="testdisk"
PKG_VERSION="0db61bd"
#PKG_URL="https://dl.dropboxusercontent.com/s/02huv7ugt9ofkis/testdisk-989.tar.xz"
PKG_GIT_URL="https://git.cgsecurity.org/testdisk.git"
PKG_DEPENDS_TARGET="toolchain readline netbsd-curses"
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
			      --disable-sudo" 


PKG_CONFIGURE_OPTS_INIT="$PKG_CONFIGURE_OPTS_TARGET"