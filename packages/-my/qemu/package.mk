PKG_NAME="qemu"
PKG_VERSION="2.7.0"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="http://wiki.qemu.org"
PKG_URL="http://wiki.qemu-project.org/download/qemu-$PKG_VERSION.tar.bz2"
PKG_DEPENDS_HOST="toolchain Python:host libffi:host zlib:host glib:host"
PKG_PRIORITY="optional"
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
  
pre_configure_target() {
   cd $ROOT/$PKG_BUILD
   export PKG_CONFIG_LIBDIR="$ROOT/$TOOLCHAIN/bin/pkg-config"
   ./configure --cross-prefix=$TARGET_NAME \
			--prefix=/usr \
			--static \
			--sysconfdir=/etc \
			--disable-libssh2 \
			--disable-gtk \
			--disable-vnc \
			--disable-spice \
			--disable-libnfs \
			--disable-docs \
			--disable-sdl \
			--disable-strip \
			--bindir=/usr/bin
}			