################################################################################
#PKG_VERSION="19c4de7"
#PKG_VERSION="b5d3ac2"
#PKG_GIT_URL="git://sourceware.org/git/binutils-gdb.git"
################################################################################

PKG_NAME="binutils"
PKG_VERSION="2.28"
#PKG_VERSION="d81c51a"
PKG_URL="https://fossies.org/linux/misc/binutils-$PKG_VERSION.tar.xz"
#PKG_GIT_URL="git://sourceware.org/git/binutils-gdb.git"
PKG_DEPENDS_HOST="ccache:host bison:host flex:host linux:host"
PKG_SECTION="toolchain/devel"
PKG_SHORTDESC="binutils: A GNU collection of binary utilities"

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

#CONCURRENCY_MAKE_LEVEL=1

PKG_CONFIGURE_OPTS_HOST="--target=$TARGET_NAME \
                         --with-sysroot=$SYSROOT_PREFIX \
                         --with-lib-path=$SYSROOT_PREFIX/lib:$SYSROOT_PREFIX/usr/lib \
                         --without-ppl \
                         --without-cloog \
                         --disable-werror \
                         --disable-multilib \
                         --disable-libada \
                         --disable-libssp \
                         --enable-version-specific-runtime-libs \
                         --enable-plugins \
                         --enable-gold \
                         --enable-ld=default \
                         --enable-lto \
                         --disable-shared \
                         --enable-poison-system-directories"

makeinstall_host() {
  cp -v ../include/libiberty.h $SYSROOT_PREFIX/usr/include
  make -j1 install
}