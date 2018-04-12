################################################################################
#      This file is part of OpenELEC - http://www.openelec.tv
#      Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
#
#  OpenELEC is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 2 of the License, or
#  (at your option) any later version.
#
#  OpenELEC is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with OpenELEC.  If not, see <http://www.gnu.org/licenses/>.
################################################################################

PKG_NAME="linux"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="http://www.kernel.org"
PKG_DEPENDS_HOST="ccache:host"
PKG_DEPENDS_TARGET="toolchain cpio:host kmod:host pciutils xz:host wireless-regdb keyutils $KERNEL_EXTRA_DEPENDS_TARGET"
PKG_DEPENDS_INIT="toolchain"
PKG_NEED_UNPACK="$LINUX_DEPENDS"
PKG_SECTION="linux"
PKG_SHORTDESC="linux26: The Linux kernel 2.6 precompiled kernel binary image and modules"
PKG_LONGDESC="This package contains a precompiled kernel image and the modules."
PKG_IS_KERNEL_PKG="yes"

PKG_PATCH_DIRS="$LINUX"

case "$LINUX" in
  git)
    PKG_VERSION="e241e3f"
    PKG_SITE="https://github.com/zen-kernel/zen-kernel/branches/active"
    PKG_URL="https://github.com/torvalds/linux/archive/$PKG_VERSION.tar.gz"
    PKG_SOURCE_DIR="zen-kernel-$PKG_VERSION*"
    PKG_PATCH_DIRS="4.17"
    PKG_BUILD_PERF="no"
    PKG_BUILD_POWER="no"
    ;;
  zen)
    PKG_VERSION="d7a1cfe"
    PKG_SITE="https://github.com/zen-kernel/zen-kernel/branches/active"
    PKG_URL="https://github.com/zen-kernel/zen-kernel/archive/$PKG_VERSION.tar.gz"
    PKG_SOURCE_DIR="zen-kernel-$PKG_VERSION*"
    PKG_PATCH_DIRS="4.16"
    PKG_BUILD_PERF="no"
    PKG_BUILD_POWER="no"
    ;;
  *)
    PKG_VERSION="4.14.33"
    PKG_SHA256=""
    PKG_URL="https://www.kernel.org/pub/linux/kernel/v4.x/$PKG_NAME-$PKG_VERSION.tar.xz"
    PKG_PATCH_DIRS="default"
    PKG_BUILD_PERF="no"
    PKG_BUILD_POWER="no"
    ;;
esac

PKG_KERNEL_CFG_FILE=$(kernel_config_path)

if [ "$TARGET_KERNEL_ARCH" = "arm64" -a "$TARGET_ARCH" = "arm" ]; then
  PKG_DEPENDS_HOST="$PKG_DEPENDS_HOST gcc-linaro-aarch64-linux-gnu:host"
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET gcc-linaro-aarch64-linux-gnu:host"
  HEADERS_ARCH=$TARGET_ARCH
fi

if [ "$DEVTOOLS" = "yes" -a "$PKG_BUILD_PERF" != "no" ] && grep -q ^CONFIG_PERF_EVENTS= $PKG_KERNEL_CFG_FILE ; then
  PKG_BUILD_PERF="yes"
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET binutils elfutils libunwind zlib openssl"
fi

PKG_MAKE_OPTS_HOST="ARCH=${HEADERS_ARCH:-$TARGET_KERNEL_ARCH} headers_check"

if [ "$TARGET_ARCH" = "x86_64" ]; then
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET intel-ucode:host kernel-firmware"
fi

if [ "$BUILD_ANDROID_BOOTIMG" = "yes" ]; then
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET mkbootimg:host"
fi

post_patch() {
  sed -i -e "s|^HOSTCC[[:space:]]*=.*$|HOSTCC = $TOOLCHAIN/bin/host-gcc|" \
         -e "s|^HOSTCXX[[:space:]]*=.*$|HOSTCXX = $TOOLCHAIN/bin/host-g++|" \
         -e "s|^ARCH[[:space:]]*?=.*$|ARCH = $TARGET_KERNEL_ARCH|" \
         -e "s|^CROSS_COMPILE[[:space:]]*?=.*$|CROSS_COMPILE = $TARGET_KERNEL_PREFIX|" \
         $PKG_BUILD/Makefile

  cp $PKG_KERNEL_CFG_FILE $PKG_BUILD/.config
  if [ ! "$BUILD_ANDROID_BOOTIMG" = "yes" ]; then
    sed -i -e "s|^CONFIG_INITRAMFS_SOURCE=.*$|CONFIG_INITRAMFS_SOURCE=\"$BUILD/image/initramfs.cpio\"|" $PKG_BUILD/.config
    sed -i -e '/^CONFIG_INITRAMFS_SOURCE=*./ a CONFIG_INITRAMFS_ROOT_UID=0\nCONFIG_INITRAMFS_ROOT_GID=0' $PKG_BUILD/.config
  fi

  # set default hostname based on $DISTRONAME
    sed -i -e "s|@DISTRONAME@|$DISTRONAME|g" $PKG_BUILD/.config

  # ask for new config options after kernel update
  # make -C $PKG_BUILD oldconfig

  # disable swap support if not enabled
  if [ ! "$SWAP_SUPPORT" = yes ]; then
    sed -i -e "s|^CONFIG_SWAP=.*$|# CONFIG_SWAP is not set|" $PKG_BUILD/.config
  fi

  # disable nfs support if not enabled
  if [ ! "$NFS_SUPPORT" = yes ]; then
    sed -i -e "s|^CONFIG_NFS_FS=.*$|# CONFIG_NFS_FS is not set|" $PKG_BUILD/.config
  fi

  # disable cifs support if not enabled
  if [ ! "$SAMBA_SUPPORT" = yes ]; then
    sed -i -e "s|^CONFIG_CIFS=.*$|# CONFIG_CIFS is not set|" $PKG_BUILD/.config
  fi

  # disable iscsi support if not enabled
  if [ ! "$ISCSI_SUPPORT" = yes ]; then
    sed -i -e "s|^CONFIG_SCSI_ISCSI_ATTRS=.*$|# CONFIG_SCSI_ISCSI_ATTRS is not set|" $PKG_BUILD/.config
    sed -i -e "s|^CONFIG_ISCSI_TCP=.*$|# CONFIG_ISCSI_TCP is not set|" $PKG_BUILD/.config
    sed -i -e "s|^CONFIG_ISCSI_BOOT_SYSFS=.*$|# CONFIG_ISCSI_BOOT_SYSFS is not set|" $PKG_BUILD/.config
    sed -i -e "s|^CONFIG_ISCSI_IBFT_FIND=.*$|# CONFIG_ISCSI_IBFT_FIND is not set|" $PKG_BUILD/.config
    sed -i -e "s|^CONFIG_ISCSI_IBFT=.*$|# CONFIG_ISCSI_IBFT is not set|" $PKG_BUILD/.config
  fi

  # install extra dts files
  for f in $PROJECT_DIR/$PROJECT/config/*-overlay.dts; do
    [ -f "$f" ] && cp -v $f $PKG_BUILD/arch/$TARGET_KERNEL_ARCH/boot/dts/overlays || true
  done
  if [ -n "$DEVICE" ]; then
    for f in $PROJECT_DIR/$PROJECT/devices/$DEVICE/config/*-overlay.dts; do
      [ -f "$f" ] && cp -v $f $PKG_BUILD/arch/$TARGET_KERNEL_ARCH/boot/dts/overlays || true
    done
  fi
}

makeinstall_host() {
  make ARCH=${HEADERS_ARCH:-$TARGET_KERNEL_ARCH} INSTALL_HDR_PATH=dest headers_install
  mkdir -p $SYSROOT_PREFIX/usr/include
    cp -R dest/include/* $SYSROOT_PREFIX/usr/include
}

pre_make_target() {
  if [ "$TARGET_ARCH" = "x86_64" ]; then
    # copy some extra firmware to linux tree
    mkdir -p $PKG_BUILD/external-firmware
      cp -a $(get_build_dir kernel-firmware)/i915 $PKG_BUILD/external-firmware

    cp -a $(get_build_dir intel-ucode)/intel-ucode $PKG_BUILD/external-firmware

    FW_LIST="$(find $PKG_BUILD/external-firmware \( -type f -o -type l \) \( -iname '*.bin' -o -iname '*.fw' -o -path '*/intel-ucode/*' \) | sed 's|.*external-firmware/||' | sort | xargs)"
    sed -i "s|CONFIG_EXTRA_FIRMWARE=.*|CONFIG_EXTRA_FIRMWARE=\"${FW_LIST}\"|" $PKG_BUILD/.config
  fi

  make oldconfig

  # regdb (backward compatability with pre-4.15 kernels)
  if grep -q ^CONFIG_CFG80211_INTERNAL_REGDB= $PKG_BUILD/.config ; then
    cp $(get_build_dir wireless-regdb)/db.txt $PKG_BUILD/net/wireless/db.txt
  fi
}

make_target() {
  LDFLAGS="" make modules
  LDFLAGS="" make INSTALL_MOD_PATH=$INSTALL/$(get_kernel_overlay_dir) DEPMOD="$TOOLCHAIN/bin/depmod" modules_install
  rm -f $INSTALL/$(get_kernel_overlay_dir)/lib/modules/*/build
  rm -f $INSTALL/$(get_kernel_overlay_dir)/lib/modules/*/source

  if [ "$PKG_BUILD_PERF" = "yes" ] ; then
    ( cd tools/perf

      # arch specific perf build args
      case "$TARGET_ARCH" in
        x86_64)
          PERF_BUILD_ARGS="ARCH=x86"
          ;;
        aarch64)
          PERF_BUILD_ARGS="ARCH=arm64"
          ;;
        *)
          PERF_BUILD_ARGS="ARCH=$TARGET_ARCH"
          ;;
      esac

      WERROR=0 \
      NO_LIBPERL=1 \
      NO_LIBPYTHON=1 \
      NO_SLANG=1 \
      NO_GTK2=1 \
      NO_LIBNUMA=1 \
      NO_LIBAUDIT=1 \
      NO_LZMA=1 \
      NO_SDT=1 \
      LDFLAGS="$LDFLAGS -ldw -ldwfl -lebl -lelf -ldl -lz" \
      EXTRA_PERFLIBS="-lebl" \
      CROSS_COMPILE="$TARGET_PREFIX" \
      JOBS="$CONCURRENCY_MAKE_LEVEL" \
        make $PERF_BUILD_ARGS
      mkdir -p $INSTALL/usr/bin
        cp perf $INSTALL/usr/bin
    )
  fi
  
  if [ "$PKG_BUILD_POWER" = "yes" ] ; then
    ( cd tools/power/cpupower

      make \
      CROSS="$TARGET_PREFIX" \
      CPUFREQ_BENCH=false \
      STATIC=true \
      NLS=true \
      DEBUG=false \
      LDFLAGS="-lrt -lpci" all

      mkdir -p $INSTALL/usr/bin
      cp cpupower $INSTALL/usr/bin
        
    # cd ../../thermal/tmon
    # make CC="$CC" PKG_CONFIG_PATH="$TOOLCHAIN/bin/pkg-config" JOBS=1
    # cp tmon $INSTALL/usr/bin
    )
  fi

  ( cd $ROOT
    rm -rf $BUILD/initramfs
    $SCRIPTS/install initramfs
  )

  if [ "$BOOTLOADER" = "u-boot" -a -n "$KERNEL_UBOOT_EXTRA_TARGET" ]; then
    for extra_target in "$KERNEL_UBOOT_EXTRA_TARGET"; do
      LDFLAGS="" make $extra_target
    done
  fi

  LDFLAGS="" make $KERNEL_TARGET $KERNEL_MAKE_EXTRACMD

  if [ "$BUILD_ANDROID_BOOTIMG" = "yes" ]; then
    DTB_BLOBS=($(ls arch/$TARGET_KERNEL_ARCH/boot/dts/amlogic/*.dtb 2>/dev/null || true))
    DTB_BLOBS_COUNT="${#DTB_BLOBS[@]}"
    DTB_BLOB_OUTPUT="arch/$TARGET_KERNEL_ARCH/boot/dtb.img"
    ANDROID_BOOTIMG_SECOND="--second $DTB_BLOB_OUTPUT"

    if [ "$DTB_BLOBS_COUNT" -gt 1 ]; then
      $TOOLCHAIN/bin/dtbTool -o arch/$TARGET_KERNEL_ARCH/boot/dtb.img -p scripts/dtc/ arch/$TARGET_KERNEL_ARCH/boot/dts/amlogic/
    elif [ "$DTB_BLOBS_COUNT" -eq 1 ]; then
      cp -PR $DTB_BLOBS $DTB_BLOB_OUTPUT
    else
      ANDROID_BOOTIMG_SECOND=""
    fi

    LDFLAGS="" mkbootimg --kernel arch/$TARGET_KERNEL_ARCH/boot/$KERNEL_TARGET --ramdisk $BUILD/image/initramfs.cpio \
      $ANDROID_BOOTIMG_SECOND $ANDROID_BOOTIMG_OPTIONS --output arch/$TARGET_KERNEL_ARCH/boot/boot.img

    mv -f arch/$TARGET_KERNEL_ARCH/boot/boot.img arch/$TARGET_KERNEL_ARCH/boot/$KERNEL_TARGET

  fi
}

makeinstall_target() {
  if [ "$BOOTLOADER" = "u-boot" ]; then
    mkdir -p $INSTALL/usr/share/bootloader
    if [ -d arch/$TARGET_KERNEL_ARCH/boot/dts/amlogic -a -f arch/$TARGET_KERNEL_ARCH/boot/dtb.img ]; then
      cp arch/$TARGET_KERNEL_ARCH/boot/dtb.img $INSTALL/usr/share/bootloader/dtb.img 2>/dev/null || :
    else
      for dtb in arch/$TARGET_KERNEL_ARCH/boot/dts/*.dtb arch/$TARGET_KERNEL_ARCH/boot/dts/*/*.dtb; do
        if [ -f $dtb ]; then
          cp -v $dtb $INSTALL/usr/share/bootloader
        fi
      done
    fi
  elif [ "$BOOTLOADER" = "bcm2835-bootloader" ]; then
    mkdir -p $INSTALL/usr/share/bootloader/overlays

    # install platform dtbs, but remove upstream kernel dtbs (i.e. without downstream
    # drivers and decent USB support) as these are not required by LibreELEC
    cp -p arch/$TARGET_KERNEL_ARCH/boot/dts/*.dtb $INSTALL/usr/share/bootloader
    rm -f $INSTALL/usr/share/bootloader/bcm283*.dtb

    # install overlay dtbs
    for dtb in arch/$TARGET_KERNEL_ARCH/boot/dts/overlays/*.dtbo; do
      cp $dtb $INSTALL/usr/share/bootloader/overlays 2>/dev/null || :
    done
    cp -p arch/$TARGET_KERNEL_ARCH/boot/dts/overlays/README $INSTALL/usr/share/bootloader/overlays
  fi
}

make_init() {
 : # reuse make_target()
}

makeinstall_init() {
  if [ -n "$INITRAMFS_MODULES" ]; then
    mkdir -p $INSTALL/etc
    mkdir -p $INSTALL/usr/lib/modules

    for i in $INITRAMFS_MODULES; do
      module=`find .install_pkg/$(get_full_module_dir)/kernel -name $i.ko`
      if [ -n "$module" ]; then
        echo $i >> $INSTALL/etc/modules
        cp $module $INSTALL/usr/lib/modules/`basename $module`
      fi
    done
  fi

  if [ "$UVESAFB_SUPPORT" = yes ]; then
    mkdir -p $INSTALL/usr/lib/modules
      uvesafb=`find .install_pkg/$(get_full_module_dir)/kernel -name uvesafb.ko`
      cp $uvesafb $INSTALL/usr/lib/modules/`basename $uvesafb`
  fi
}

post_install() {
  mkdir -p $INSTALL/$(get_full_firmware_dir)/
    ln -sf /storage/.config/firmware/ $INSTALL/$(get_full_firmware_dir)/updates

  # bluez looks in /etc/firmware/
    ln -sf /$(get_full_firmware_dir)/ $INSTALL/etc/firmware

  # regdb and signature is now loaded as firmware by 4.15+
    if grep -q ^CONFIG_CFG80211_REQUIRE_SIGNED_REGDB= $PKG_BUILD/.config; then
      cp $(get_build_dir wireless-regdb)/regulatory.db{,.p7s} $INSTALL/$(get_full_firmware_dir)
    fi
}
