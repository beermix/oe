PKG_NAME="qemu"
PKG_VERSION="2.9.1"
PKG_SITE="http://wiki.qemu.org"
PKG_URL="https://fossies.org/linux/misc/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_HOST="toolchain Python2:host libffi:host zlib:host glib:host"
PKG_DEPENDS_TARGET="toolchain SDL"
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
  rm -rf .$TARGET_NAME
  
  #strip_lto
  #strip_gold
  
  PKG_CONFIG_LIBDIR=/root/-3SDC/oe/build.OE-Generic.x86_64-8.0-devel/toolchain/x86_64-openelec-linux-gnu/sysroot/usr/lib/pkgconfig
}

configure_target() {
  ./configure --prefix=/usr \
              --cross-prefix=${TARGET_NAME}- \
              --cc=$CC \
              --cxx=$CXX \
              --host-cc=$HOST_CC \
              --datadir=/storage/.config/qemu \
              --sysconfdir=/storage/.config/qemu \
              --smbd=/usr/bin/smbd \
              --disable-user \
              --disable-libnfs \
              --disable-werror \
              --enable-guest-agent \
              --disable-libusb \
              --disable-docs \
              --disable-vnc \
              --disable-blobs \
              --disable-system \
              --disable-docs \
              --disable-gcrypt \
              --target-list=x86_64-linux-user"
              
}

makeinstall_target() {
  mkdir -p $INSTALL/usr/bin
  $STRIP ../.$HOST_NAME/x86_64-linux-user/qemu-x86_64
  cp ../.$HOST_NAME/x86_64-linux-user/qemu-x86_64 $INSTALL/usr/bin/qemu-x86_64-static
}

