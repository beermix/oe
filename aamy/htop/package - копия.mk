PKG_NAME="htop"
PKG_VERSION="b7b66b7"
PKG_SITE="https://github.com/hishamhm/htop"
PKG_URL="https://github.com/hishamhm/htop/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain ncurses libpciaccess libxml2 udevil"
PKG_SECTION="debug/tools"
PKG_TOOLCHAIN="autotools"

#pre_configure_target() {
#  export LIBS="$LIBS -lm -ludev -lltdl -lpthread -ldl -lhwloc"
#}

PKG_CONFIGURE_OPTS_TARGET="--sysconfdir=/storage/.config/htop \
			      --datarootdir=/storage/.config/htop \
                           --enable-proc \
                           --enable-taskstats \
                           --enable-unicode \
                           --enable-linux-affinity \
                           --enable-setuid \
                           --disable-hwloc \
                           --enable-cgroup"