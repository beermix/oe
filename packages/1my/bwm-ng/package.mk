PKG_NAME="bwm-ng"
PKG_VERSION="b81da65"
PKG_URL="https://github.com/vgropp/bwm-ng/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain ncurses libstatgrab"
PKG_TOOLCHAIN="autotools"

#pre_configure_target() {
#  export CFLAGS="$CFLAGS -static -lpthread -static-libgcc -lrt -ldl -lm"
#}

PKG_CONFIGURE_OPTS_TARGET="ac_cv_func_malloc_0_nonnull=yes \
			      ac_cv_func_realloc_0_nonnull=yes \
			      --with-libstatgrab \
			      --enable-static \
			      --disable-shared \
			      --with-time \
			      --with-getifaddrs \
			      --with-sysctl \
			      --with-sysctldisk \
			      --with-procnetdev \
			      --with-partitions \ 
			      --with-ncurses \
			      --with-getopt_long \
			      --enable-configfile \
			      --enable-html \
			      --enable-extendedstats \
			      --with-getopt_long"
