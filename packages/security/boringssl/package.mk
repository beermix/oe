PKG_NAME="boringssl"
PKG_VERSION="d79bc9d"
PKG_SITE="http://www.openssl.org/"
PKG_GIT_URL="https://boringssl.googlesource.com/boringssl"
PKG_DEPENDS_HOST="ccache:host"
PKG_DEPENDS_TARGET="toolchain go:host"
PKG_SECTION="security"
PKG_SHORTDESC="openssl: a FREE version of the SSL/TLS protocol forked from openssl"
PKG_LONGDESC="openssl is a FREE version of the SSL/TLS protocol forked from openssl"
PKG_IS_ADDON="no"
PKG_USE_CMAKE="yes"
PKG_AUTORECONF="no"

strip_lto

PKG_CMAKE_OPTS_TARGET="-DCMAKE_BUILD_TYPE=Release \
			  -DGO_EXECUTABLE=$ROOT/$TOOLCHAIN/lib/golang/bin/go \
			  -DCMAKE_MAKE_PROGRAM=$ROOT/$TOOLCHAIN/bin/make \
			  -DFOUND_LIBRT=$SYSROOT_PREFIX/usr/lib/librt.so"

makeinstall_target() {
  cp $ROOT/$PKG_BUILD/.x86_64-openelec-linux-gnu/crypto/libcrypto.a $SYSROOT_PREFIX/usr/lib
  cp $ROOT/$PKG_BUILD/.x86_64-openelec-linux-gnu/ssl/libssl.a $SYSROOT_PREFIX/usr/lib
}
