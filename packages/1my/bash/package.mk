PKG_NAME="bash"
PKG_VERSION="5.0"
PKG_SHA256=""
#PKG_SITE="https://github.com/bminor/bash/"
#PKG_URL="http://ftp.gnu.org/gnu/bash/bash-$PKG_VERSION.tar.gz"
PKG_URL="https://github.com/bminor/bash/archive/${PKG_VERSION}.tar.gz"
PKG_URL="https://fossies.org/linux/misc/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain ncurses readline"

pre_patch() {
  cd $PKG_BUILD
  patch -p0 -i $PKG_DIR/patches0/bash50-001.patch
  patch -p0 -i $PKG_DIR/patches0/bash50-002.patch
  patch -p0 -i $PKG_DIR/patches0/bash50-003.patch
  patch -p0 -i $PKG_DIR/patches0/bash50-004.patch
  patch -p0 -i $PKG_DIR/patches0/bash50-005.patch
  patch -p0 -i $PKG_DIR/patches0/bash50-006.patch
  patch -p0 -i $PKG_DIR/patches0/bash50-007.patch
  patch -p0 -i $PKG_DIR/patches0/bash50-008.patch
  patch -p0 -i $PKG_DIR/patches0/bash50-009.patch
  patch -p0 -i $PKG_DIR/patches0/bash50-010.patch
  patch -p0 -i $PKG_DIR/patches0/bash50-011.patch
}

PKG_CONFIGURE_OPTS_TARGET="--with-curses \
			      --enable-readline \
			      --without-bash-malloc \
			      --with-installed-readline \
			      --enable-direxpand-default \
			      --enable-job-control \
			      --disable-rpath"

#post_makeinstall_target() {
#  ln -sfv bash $INSTALL/usr/bin/sh
#}