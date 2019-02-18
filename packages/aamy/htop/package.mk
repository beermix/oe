PKG_NAME="htop"
PKG_VERSION="402e46b"
PKG_SITE="https://github.com/hishamhm/htop"
PKG_URL="https://github.com/hishamhm/htop/archive/${PKG_VERSION}.tar.gz"
#PKG_DEPENDS_TARGET="toolchain ncurses libpciaccess"
PKG_TOOLCHAIN="autotools"

#pre_configure_target() {
#  export LIBS="$LIBS -lm  -ludev -lltdl -lpthread -ldl -lhwloc"
#}

PKG_CONFIGURE_OPTS_TARGET="ac_cv_file__proc_stat=yes \
                           ac_cv_file__proc_meminfo=yes \
                           --sysconfdir=/storage/.config/htop \
			      --datarootdir=/storage/.config/htop \
                           --enable-proc \
                           --enable-taskstats \
                           --disable-unicode \
                           --enable-linux-affinity \
                           --enable-setuid \
                           --enable-hwloc=no \
                           --enable-cgroup"