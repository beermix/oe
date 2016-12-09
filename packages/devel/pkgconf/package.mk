PKG_NAME="pkgconf"
PKG_VERSION="1.0.2"
PKG_URL="https://distfiles.dereferenced.org/pkgconf/pkgconf-$PKG_VERSION.tar.xz"
PKG_DEPENDS_HOST="ccache:host gettext:host autotools:host"

PKG_SECTION="toolchain/devel"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

PKG_CONFIGURE_OPTS_HOST="--enable-static --disable-shared -with-gnu-ld"

PKG_CONFIGURE_OPTS_TARGET="$PKG_CONFIGURE_OPTS_HOST"

post_makeinstall_host() {
#	mkdir -p $SYSROOT_PREFIX/usr/share/aclocal
#	cp $ROOT/$PKG_BUILD/pkg.m4 $SYSROOT_PREFIX/usr/share/aclocal
	ln -sfi pkgconf $ROOT/$TOOLCHAIN/bin/pkg-config
}