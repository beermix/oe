PKG_NAME="htop"
PKG_VERSION="9487bda"
PKG_GIT_URL="https://github.com/hishamhm/htop"
PKG_DEPENDS_TARGET="toolchain hwloc ncurses"
PKG_SECTION="debug/tools"
PKG_AUTORECONF="yes"

pre_configure_target() {
  export LIBS="$LIBS -ludev -lhwloc -lxml2 -lpciaccess"
}

PKG_CONFIGURE_OPTS_TARGET="--enable-cgroup \
			      --enable-vserver \
			      --sysconfdir=/storage/.config/htop \
			      --datarootdir=/storage/.config/htop \
			      --disable-silent-rules \
			      --disable-unicode \
			      --enable-hwloc \
			      --enable-proc"


