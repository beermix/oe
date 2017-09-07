PKG_NAME="megatools"
PKG_VERSION="4621580"
PKG_GIT_URL="https://github.com/megous/megatools/"
PKG_DEPENDS_TARGET="toolchain fuse neon"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_TARGET="--enable-static \
			      --disable-shared \
			      --disable-docs \
			      --disable-option-checking \
			      --with-gnu-ld \
			      --sysconfdir=/storage/.config/megatools"