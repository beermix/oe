PKG_NAME="megatools"
PKG_VERSION="b2750d2"
PKG_GIT_URL="https://github.com/megous/megatools/"
PKG_DEPENDS_TARGET="toolchain fuse neon"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

pre_configure_target() {
  export CFLAGS="$CFLAGS -fPIC -DPIC"
  export LIBS="-ltermcap"
}

PKG_CONFIGURE_OPTS_TARGET="--enable-static \
			      --disable-shared \
			      --disable-docs \
			      --disable-option-checking \
			      --sysconfdir=/storage/.config/megatools"
