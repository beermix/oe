PKG_NAME="htop"
PKG_VERSION="65ec0bd"
PKG_GIT_URL="https://github.com/hishamhm/htop"
PKG_DEPENDS_TARGET="toolchain ncurses libpciaccess libxml2 udevil"
PKG_SECTION="debug/tools"
PKG_AUTORECONF="yes"

pre_configure_target() {
  export CFLAGS="$CFLAGS -fno-strict-aliasing -lncursesw -ltinfo"
}

PKG_CONFIGURE_OPTS_TARGET="--sysconfdir=/storage/.config/htop \
                           --enable-proc \
                           --enable-taskstats \
                           --enable-unicode \
                           --enable-linux-affinity \
                           --enable-setuid"