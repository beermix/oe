PKG_NAME="pkgconf"
PKG_VERSION="082fd4a"
PKG_GIT_URL="https://github.com/pkgconf/pkgconf"
PKG_DEPENDS_HOST="ccache:host gettext:host"
PKG_PRIORITY="optional"
PKG_SECTION="toolchain/devel"
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"


PKG_CONFIGURE_OPTS_HOST="--enable-static --disable-shared --disable-silent-rules"

PKG_CONFIGURE_OPTS_TARGET="$PKG_CONFIGURE_OPTS_HOST"

post_makeinstall_host() {
#	mkdir -p $SYSROOT_PREFIX/usr/share/aclocal
#	cp $ROOT/$PKG_BUILD/pkg.m4 $SYSROOT_PREFIX/usr/share/aclocal
	ln -sf $ROOT/$TOOLCHAIN/bin/pkgconf $ROOT/$TOOLCHAIN/bin/pkg-config
}
