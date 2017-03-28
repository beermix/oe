PKG_NAME="qemu"
PKG_VERSION="2.9.0-rc1"
PKG_SITE="http://wiki.qemu.org"
PKG_URL="http://wiki.qemu-project.org/download/qemu-$PKG_VERSION.tar.bz2"
PKG_DEPENDS_HOST="toolchain Python:host libffi:host zlib:host glib:host"
PKG_SECTION="tools"
PKG_SHORTDESC="QEMU is a generic and open source machine emulator and virtualizer."
PKG_LONGDESC="QEMU is a generic and open source machine emulator and virtualizer."

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

HOST_CONFIGURE_OPTS="--prefix=$ROOT/$TOOLCHAIN \
			--bindir=$ROOT/$TOOLCHAIN/bin \
			--sbindir=$ROOT/$TOOLCHAIN/sbin \
			--sysconfdir=$ROOT/$TOOLCHAIN/etc \
			--libexecdir=$ROOT/$TOOLCHAIN/lib \
			--localstatedir=$ROOT/$TOOLCHAIN/var \
			--extra-cflags=-I$ROOT/$TOOLCHAIN/include \
			--extra-ldflags=-L$ROOT/$TOOLCHAIN/lib \
			--static \
			--disable-vnc \
			--disable-werror \
			--disable-blobs \
			--disable-system \
			--disable-user \
			--disable-docs"

configure_target() {
  #strip_gold
  cd $ROOT/$PKG_BUILD
  ./configure --prefix=/usr --cc=$CC --cxx=$CXX --host-cc=gcc --disable-user --disable-docs --disable-debug-info --static --enable-opengl --enable-curl
}
