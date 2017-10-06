PKG_NAME="htop"
PKG_VERSION="e3f65c8"
PKG_GIT_URL="https://github.com/hishamhm/htop"
PKG_DEPENDS_TARGET="toolchain ncurses libpciaccess libxml2 udevil"
PKG_SECTION="debug/tools"
PKG_AUTORECONF="yes"

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
                           --disable-hwloc"