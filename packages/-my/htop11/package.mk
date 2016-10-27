PKG_NAME="htop"
PKG_VERSION="2.0.2"
PKG_URL="http://hisham.hm/htop/releases/2.0.2/htop-2.0.2.tar.gz"
PKG_DEPENDS_TARGET="toolchain netbsd-curses"
PKG_PRIORITY="optional"
PKG_SECTION="debug/tools"
PKG_SHORTDESC="htop: Htop is an ncurses based interactive process viewer for Linux."
PKG_LONGDESC="Htop is an ncurses based interactive process viewer for Linux."
PKG_AUTORECONF="no"

PKG_CONFIGURE_OPTS_TARGET="--enable-cgroup \
            --disable-vserver \
            --disable-unicode \
            --disable-native-affinity \
            --disable-hwloc \
            --with-gnu-ld"


pre_build_target() {
  mkdir -p $PKG_BUILD/.$TARGET_NAME
  cp -RP $PKG_BUILD/* $PKG_BUILD/.$TARGET_NAME
}