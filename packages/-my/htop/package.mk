PKG_NAME="htop"
PKG_VERSION="9487bda"
PKG_GIT_URL="https://github.com/hishamhm/htop"
PKG_DEPENDS_TARGET="toolchain hwloc ncurses libxml2"
PKG_SECTION="debug/tools"
PKG_AUTORECONF="yes"

pre_configure_target() {
  export LIBS="$LIBS -ludev -lhwloc -lxml2 -lpciaccess"
}

PKG_CONFIGURE_OPTS_TARGET="--enable-cgroup \
			      --enable-vserver \
			      --disable-silent-rules \
			      --enable-unicode \
			      --enable-openvz \
			      --enable-hwloc \
			      --enable-proc \
			      --with-gnu-ld \
			      --sysconfdir=/storage/.config/htop \
			      --datarootdir=/storage/.config/htop"
