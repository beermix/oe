PKG_NAME="bwm-ng"
PKG_VERSION="f54b3fa"
PKG_GIT_URL="https://github.com/vgropp/bwm-ng"
PKG_DEPENDS_TARGET="toolchain libstatgrab"
PKG_TOOLCHAIN="autotools"

pre_configure_target() {
  export LIBS="-lterminfo"
}

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
			      --enable-64bit \
			      --enable-netstatbyte \
			      --enable-netstatlink \
			      --with-ncurses \
			      --with-getopt_long \
			      --with-netstatlinux \
			      --without-strip \
			      --enable-configfile \
			      --enable-html \
			      --enable-extendedstats \
			      --with-getopt_long \
			      --without-diskstats"
