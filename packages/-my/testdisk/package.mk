PKG_NAME="testdisk"
PKG_VERSION="0db61bd"
PKG_SITE="https://git.cgsecurity.org/cgit/testdisk/log/"
PKG_GIT_URL="https://git.cgsecurity.org/testdisk.git"
PKG_DEPENDS_TARGET="toolchain readline netbsd-curses"
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

CONCURRENCY_MAKE_LEVEL=1

pre_configure_target() {
  export LIBS="-lterminfo"
  strip_lto
  strip_gold
}

pre_configure_host() {
  export LIBS="-lterminfo"
}

PKG_CONFIGURE_OPTS_TARGET="--disable-shared" 


PKG_CONFIGURE_OPTS_INIT="$PKG_CONFIGURE_OPTS_TARGET"