PKG_NAME="pkgconf"
PKG_VERSION="1.6.3"
PKG_SHA256=""
PKG_URL="https://github.com/pkgconf/pkgconf/archive/pkgconf-$PKG_VERSION.tar.gz"
PKG_DEPENDS_HOST="ccache:host autoconf:host automake:host"
PKG_TOOLCHAIN="autotools"

_pcdirs=/usr/lib/pkgconfig:/usr/share/pkgconfig
_libdir=${TOOLCHAIN}/lib
_includedir=${TOOLCHAIN}/include

PKG_CONFIGURE_OPTS_HOST="--with-pkg-config-dir="$_pcdirs" \
			    --with-system-libdir="$_libdir" \
			    --with-system-includedir="$_includedir" \
			    --disable-static"

post_makeinstall_host() {
  ln -s pkgconf $TOOLCHAIN/bin/pkg-config
}

pre_configure_host() {
  export CFLAGS="$CFLAGS -Wall"
}