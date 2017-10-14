PKG_NAME="bwm-ng"
PKG_VERSION="d9d7f7c"
PKG_URL="https://github.com/virtualboots/bwm-ng/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain libstatgrab"
PKG_AUTORECONF="yes"

CFLAGS="$CFLAGS -static"
CXXFLAGS="$CXXFLAGS -static"

PKG_CONFIGURE_OPTS_TARGET="ac_cv_func_malloc_0_nonnull=yes \
			      ac_cv_func_realloc_0_nonnull=yes \
			      --with-libstatgrab \
			      --enable-static \
			      --disable-shared \
			      --with-time \
			      --with-getifaddrs \
			      --without-sysctl \
			      --with-sysctldisk \
			      --with-procnetdev \
			      --with-partitions \ 
			      --enable-64bit \
			      --with-ncurses \
			      --with-getopt_long \
			      --enable-configfile \
			      --enable-html \
			      --enable-extendedstats \
			      --with-getopt_long \
			      --with-gnu-ld"
