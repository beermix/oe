PKG_NAME="qemu"
PKG_VERSION="2.9.0"
PKG_SITE="http://wiki.qemu.org"
PKG_URL="https://fossies.org/linux/misc/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_HOST="toolchain Python:host libffi:host zlib:host glib:host"
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
  
  export NM="$NM"
  export AR="$AR"
  export AS="$CC"
  export as="$CC"
  export LD="$CC"
  export cc1="$CC"

  #strip_lto
  #strip_gold
  
  #export pkg_config_exe="$ROOT/$TOOLCHAIN/bin/pkg-config"
}
 \
configure_target() {
  ./configure --prefix=/usr \
              --cross-prefix=${TARGET_NAME}- \
              --source-path=$(get_pkg_build qemu) \
              --cc=$CC \
              --cxx=$CXX \
              --extra-cflags=-I$SYSROOT_PREFIX/usr/include \
              --extra-ldflags=-L$SYSROOT_PREFIX/usr/lib \
              --host-cc=$HOST_CC \
              --datadir=/storage/.config/qemu \
              --sysconfdir=/storage/.config/qemu \
              --smbd=/usr/bin/smbd \
              --static \
              --disable-user \
              --enable-system \
              --disable-libnfs \
              --enable-guest-agent \
              --disable-libusb \
              --disable-docs
}

make_target() {
  make NM="$NM" AR="$AR" AS="$CC" as="$CC" LD="$CC" cc1="$CC"
}
