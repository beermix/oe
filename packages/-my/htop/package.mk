PKG_NAME="htop"
PKG_VERSION="aa813c7"
PKG_GIT_URL="https://github.com/hishamhm/htop"
PKG_DEPENDS_TARGET="toolchain hwloc ncurses"
PKG_SECTION="debug/tools"
PKG_AUTORECONF="yes"

MAKEFLAGS=-j1

PKG_CONFIGURE_OPTS_TARGET="--enable-cgroup \
			      --enable-vserver \
			      --sysconfdir=/storage/.config/htop \
			      --datarootdir=/storage/.config/htop \
			      --disable-silent-rules \
			      --enable-unicode \
			      --enable-native-affinity \
			      --enable-hwloc \
			      --enable-proc"


