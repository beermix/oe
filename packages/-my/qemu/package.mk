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
			
pre_configure_target() {
  cd $ROOT/$PKG_BUILD
  rm -rf .$TARGET_NAME

  #strip_lto

  	strip_gold
  
  export pkg_config_exe="$ROOT/$TOOLCHAIN/bin/pkg-config"
}

configure_target() {
  ./configure --prefix=/usr \
              --cpu="x86_64" \
              --cross-prefix=${TARGET_NAME}- \
              --source-path=$(get_pkg_build qemu) \
              --cc="$CC" \
              --cxx="$CXX" \
              --host-cc="$HOST_CC" \
              --extra-cflags="$CFLAGS" \
              --extra-ldflags="$LDFLAGS -fPIC" \
              --datadir="/storage/.config/qemu" \
              --sysconfdir="/storage/.config/qemu" \
              --smbd="/usr/bin/smbd" \
              --static \
              --enable-tcg-interpreter \
              --disable-user \
              --enable-system \
              --disable-libnfs \
              --enable-libssh2 \
              --enable-bzip2 \
              --enable-lzo \
              --enable-libusb \
              --enable-attr \
              --enable-sdl \
              --enable-linux-aio \
              --disable-curl \
              --enable-vnc \
              --enable-curses \
              --enable-gnutls \
              --enable-guest-agent \
              --disable-docs
}
