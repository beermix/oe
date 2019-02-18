PKG_NAME="megatools"
PKG_VERSION="4621580"
PKG_GIT_URL="https://github.com/megous/megatools/"
PKG_URL="https://github.com/megous/megatools/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain fuse neon"
PKG_SECTION="my"
PKG_TOOLCHAIN="autotools"

PKG_CONFIGURE_OPTS_TARGET="-disable-shared \
			      --disable-docs \
			      --disable-option-checking \
			      --sysconfdir=/storage/.config/megatools"