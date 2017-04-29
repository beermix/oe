PKG_NAME="htop"
PKG_VERSION="b1028e0"
PKG_GIT_URL="https://github.com/hishamhm/htop"
PKG_DEPENDS_TARGET="toolchain hwloc"
PKG_SECTION="debug/tools"
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_TARGET="--enable-cgroup \
			      --enable-vserver \
			      --sysconfdir=/storage/.config/htop \
			      --datarootdir=/storage/.config/htop \
			      --disable-silent-rules \
			      --enable-unicode \
			      --enable-native-affinity \
			      --enable-hwloc \
			      --enable-proc"


