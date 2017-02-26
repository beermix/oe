PKG_NAME="pkgconf"
PKG_VERSION="1.3.0"
PKG_URL="https://distfiles.dereferenced.org/pkgconf/pkgconf-$PKG_VERSION.tar.xz"
PKG_DEPENDS_HOST="ccache:host gettext:host autotools:host"
PKG_SECTION="toolchain/devel"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"


PKG_CONFIGURE_OPTS_HOST="--enable-static --disable-shared"


#post_makeinstall_host() {
#  ln -sfv pkgconf $ROOT/$TOOLCHAIN/bin/pkg-config
#}
