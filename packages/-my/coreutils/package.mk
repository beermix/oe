PKG_NAME="coreutils"
PKG_VERSION="8.29"
PKG_URL="http://ftpmirror.gnu.org/coreutils/coreutils-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain acl libcap pcre readline openssl"
PKG_TOOLCHAIN="configure"

pre_configure_target() {
  export CFLAGS="$CFLAGS -O3 -Os -fdata-sections -ffat-lto-objects -ffunction-sections -flto=4 -fno-semantic-interposition "
  export FCFLAGS="$CFLAGS -O3 -Os -fdata-sections -ffat-lto-objects -ffunction-sections -flto=4 -fno-semantic-interposition "
  export FFLAGS="$CFLAGS -O3 -Os -fdata-sections -ffat-lto-objects -ffunction-sections -flto=4 -fno-semantic-interposition "
  export CXXFLAGS="$CXXFLAGS -O3 -Os -fdata-sections -ffat-lto-objects -ffunction-sections -flto=4 -fno-semantic-interposition "
}

PKG_CONFIGURE_OPTS_TARGET="PERL=missing \
			      MAKEINFO=missing \
			      --without-selinux \
			      --enable-no-install-program=kill,groups \
			      --enable-single-binary=symlinks \
			      --enable-single-binary-exceptions=expr,factor,rm \
			      --disable-shared"
			      
PKG_CONFIGURE_OPTS_HOST="$PKG_CONFIGURE_OPTS_TARGET"