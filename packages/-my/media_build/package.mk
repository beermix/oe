################################################################################
#      This file is part of Alex@ELEC - http://www.alexelec.in.ua
#      Copyright (C) 2011-2016 Alexandr Zuyev (alex@alexelec.in.ua)
################################################################################

PKG_NAME="media_build"
PKG_VERSION="a68b800"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_GIT_URL="http://git.linuxtv.org/media_build.git"
PKG_DEPENDS_TARGET="toolchain linux"
PKG_NEED_UNPACK="$LINUX_DEPENDS"
PKG_PRIORITY="optional"
PKG_SECTION="xmedia/dvb"
PKG_SHORTDESC="Build system to use the latest experimental drivers/patches without needing to replace the entire Kernel"
PKG_LONGDESC="Build system to use the latest experimental drivers/patches without needing to replace the entire Kernel"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

pre_make_target() {
  export KERNEL_VER=$(get_module_dir)
  # dont use our LDFLAGS, use the KERNEL LDFLAGS
  export LDFLAGS=""
}

make_target() {
  make VER=$KERNEL_VER SRCDIR=$(kernel_path) stagingconfig
  make VER=$KERNEL_VER SRCDIR=$(kernel_path)
}

makeinstall_target() {
  : # not
}

post_install() {
  MOD_VER=`ls $BUILD/linux*/.install_pkg/lib/modules`

  # install media_build drivers
  cp -Pa $INSTALL/lib/modules/$MOD_VER $INSTALL/lib/modules/$MOD_VER-mb
  mkdir -p $INSTALL/lib/modules/$MOD_VER-mb/updates/mb
  find $ROOT/$PKG_BUILD/v4l/ -name \*.ko -exec cp {} $INSTALL/lib/modules/$MOD_VER-mb/updates/mb \;
  echo "Media_Build drivers version: $PKG_VERSION" > $INSTALL/lib/modules/$MOD_VER-mb/updates/mb-drivers.txt
}
