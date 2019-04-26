PKG_NAME="libelf"
PKG_VERSION="0.8.13"
PKG_SITE="http://www.mr511.de/software/"
PKG_URL="http://www.mr511.de/software/libelf-$PKG_VERSION.tar.gz"
PKG_DEPENDS_HOST="intltool:host libtool:host bison:host flex:host"
#PKG_DEPENDS_TARGET="libelf:host"
PKG_SECTION="devel"
PKG_BUILD_FLAGS="+pic:host +pic"
PKG_TOOLCHAIN="configure"

PKG_CONFIGURE_OPTS_HOST="--disable-shared --enable-elf64"

PKG_CONFIGURE_OPTS_TARGET="--disable-shared --enable-elf64"

make_target() {
  make -C $PKG_BUILD/.x86_64-libreelec-linux-gnu/lib/ libelf.a
  
}

makeinstall_target() {
  make INSTALL_PREFIX=$INSTALL install
  make INSTALL_PREFIX=$SYSROOT_PREFIX install
  #chmod 755 $INSTALL/usr/lib/*.so*
  #chmod 755 $INSTALL/usr/lib/engines/*.so
}

#post_makeinstall_target() {
#  cp -r lib/{elf_repl.h,gelf.h,libelf.h,nlist.h,sys_elf.h} $SYSROOT/include/libelf/
#  cp lib/libelf.a $SYSROOT/lib
#}