PKG_NAME="f2fs-tools"
PKG_VERSION="1e7aedf"
PKG_SITE="http://git.kernel.org/cgit/linux/kernel/git/jaegeuk/f2fs-tools.git"
PKG_GIT_URL="git://git.kernel.org/pub/scm/linux/kernel/git/jaegeuk/f2fs-tools.git"
PKG_DEPENDS_TARGET="toolchain util-linux libselinux"
PKG_DEPENDS_INIT="f2fs-tools"
PKG_SECTION="tools"
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_TARGET="cross_compiling=maybe \
                           --prefix=/usr \
                           --bindir=/bin \
                           --sbindir=/sbin \
                           --host=$TARGET_HOST \
                           --build=$HOST_NAME \
                           --disable-shared \
                           --with-gnu-ld"

configure_init() {
  : # reuse target
}

make_init() {
  : # reuse target
}

makeinstall_init() {
  mkdir -p $INSTALL/sbin
  mkdir -p $INSTALL/lib
  cp ../.install_pkg/sbin/fsck.f2fs $INSTALL/sbin
  cp ../.install_pkg/sbin/mkfs.f2fs $INSTALL/sbin
  cp -a $(get_pkg_build libselinux)/.install_pkg/usr/lib/libselinux* $INSTALL/lib
  cp $(get_pkg_build glibc)/.install_pkg/lib/libdl.so.2 $INSTALL/lib
}
