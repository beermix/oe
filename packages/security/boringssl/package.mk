PKG_NAME="boringssl"
PKG_VERSION="bda7b9a"
PKG_SITE="http://www.openssl.org/"
PKG_GIT_URL="https://boringssl.googlesource.com/boringssl"
PKG_DEPENDS_HOST="ccache:host"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="security"
PKG_SHORTDESC="openssl: a FREE version of the SSL/TLS protocol forked from openssl"
PKG_LONGDESC="openssl is a FREE version of the SSL/TLS protocol forked from openssl"
+PKG_BUILD_FLAGS="-lto -gold -hardening"

PKG_CMAKE_OPTS_TARGET="-DCMAKE_BUILD_TYPE=Release -DFOUND_LIBRT=$SYSROOT_PREFIX/usr/lib/librt.so"

makeinstall_target() {
  cp $PKG_BUILD/.x86_64-openelec-linux-gnu/crypto/libcrypto.a $SYSROOT_PREFIX/usr/lib
  cp $PKG_BUILD/.x86_64-openelec-linux-gnu/ssl/libssl.a $SYSROOT_PREFIX/usr/lib
}
