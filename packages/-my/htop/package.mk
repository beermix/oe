PKG_NAME="htop"
PKG_VERSION="e940aec"
PKG_GIT_URL="https://github.com/hishamhm/htop"
PKG_DEPENDS_TARGET="toolchain hwloc"
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
			      --enable-unicode \
			      --enable-hwloc \
			      --enable-proc"


