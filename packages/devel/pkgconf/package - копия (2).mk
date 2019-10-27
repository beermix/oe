PKG_NAME="pkgconf"
PKG_VERSION="1.6.3"
PKG_SHA256="743bac2b1fae7985cc6ff91deece9af2b64d6fe7dae7cebd6c42f8a04fcc4c2d"
PKG_URL="https://github.com/pkgconf/pkgconf/archive/pkgconf-$PKG_VERSION.tar.gz"
PKG_DEPENDS_HOST="ccache:host autotools:host"
PKG_TOOLCHAIN="autotools"

PKG_CONFIGURE_OPTS_HOST="--with-system-libdir="$_libdir" \
			    --with-system-includedir="$_includedir" \
			    --disable-shared"

post_makeinstall_host() {
  ln -s pkgconf $TOOLCHAIN/bin/pkg-config
}

pre_configure_host() {
  export _libdir=${TOOLCHAIN}/lib
  export  _includedir=${TOOLCHAIN}/include
}