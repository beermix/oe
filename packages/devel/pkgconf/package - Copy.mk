PKG_NAME="pkgconf"
PKG_VERSION="1.0.1"
PKG_URL="http://rabbit.dereferenced.org/%7Enenolod/distfiles/pkgconf-$PKG_VERSION.tar.xz"
PKG_DEPENDS_HOST="ccache:host gettext:host"
PKG_PRIORITY="optional"
PKG_SECTION="toolchain/devel"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"


PKG_CONFIGURE_OPTS_HOST="--enable-static --disable-shared --disable-silent-rules --with-gnu-ld"

post_makeinstall_host() {
	mkdir -p $SYSROOT_PREFIX/usr/share/aclocal
	cp $ROOT/$PKG_BUILD/pkg.m4 $SYSROOT_PREFIX/usr/share/aclocal
	ln -sf $ROOT/$TOOLCHAIN/bin/pkgconf $ROOT/$TOOLCHAIN/bin/pkg-config
}
