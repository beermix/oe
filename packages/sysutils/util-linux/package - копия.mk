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

PKG_NAME="util-linux"
PKG_VERSION="eff2c9a"
PKG_GIT_URL="https://github.com/karelzak/util-linux"
PKG_DEPENDS_TARGET="toolchain readline"
PKG_DEPENDS_INIT="toolchain gcc:init readline"
PKG_SECTION="system"
PKG_SHORTDESC="util-linux: Miscellaneous system utilities for Linux"
PKG_LONGDESC="The util-linux package contains a large variety of low-level system utilities that are necessary for a Linux system to function. Among many features, Util-linux contains the fdisk configuration tool and the login program."

PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

pre_configure_init() {
  export LDFLAGS="-lcurses -lterminfo"
}

pre_configure_target() {
  export LDFLAGS="-lcurses -lterminfo"
}

UTILLINUX_CONFIG_DEFAULT="--disable-gtk-doc \
                          --disable-nls \
                          --disable-rpath \
                          --enable-tls \
                          --enable-chsh-only-listed \
                          --disable-pylibmount \
                          --disable-pg-bell \
                          --disable-use-tty-group \
                          --disable-makeinstall-chown \
                          --disable-makeinstall-setuid \
                          --with-gnu-ld \
                          --without-selinux \
                          --without-audit \
                          --without-udev \
                          --without-ncurses \
                          --without-slang \
                          --without-utempter \
                          --without-user \
                          --without-systemd \
                          --without-smack \
                          --without-python \
                          --without-systemdsystemunitdir"

PKG_CONFIGURE_OPTS_TARGET="--sbindir=/sbin \
                           --libexecdir=/lib \
                           $UTILLINUX_CONFIG_DEFAULT \
                           --enable-libuuid \
                           --enable-libblkid \
                           --enable-libmount \
                           --enable-libsmartcols \
                           --enable-losetup \
                           --enable-fsck \
                           --enable-blkid"

if [ "$SWAP_SUPPORT" = "yes" ]; then
  PKG_CONFIGURE_OPTS_TARGET+=" --enable-swapon"
fi

PKG_CONFIGURE_OPTS_HOST="--enable-static \
                         --disable-shared \
                         $UTILLINUX_CONFIG_DEFAULT \
                         --enable-uuidgen \
                         --enable-libuuid"

PKG_CONFIGURE_OPTS_INIT="--prefix=/ \
                         --bindir=/bin \
                         --sbindir=/sbin \
                         --sysconfdir=/etc \
                         --libexecdir=/lib \
                         --localstatedir=/var \
                         $UTILLINUX_CONFIG_DEFAULT \
                         --enable-libblkid \
                         --enable-libmount \
                         --enable-libuuid \
                         --enable-fsck"

if [ "$INITRAMFS_PARTED_SUPPORT" = "yes" ]; then
  PKG_CONFIGURE_OPTS_INIT+=" --enable-mkfs --enable-libuuid"
fi

post_makeinstall_target() {
  if [ "$SWAP_SUPPORT" = "yes" ]; then
    mkdir -p $INSTALL/usr/lib/openelec
      cp -PR $PKG_DIR/scripts/mount-swap $INSTALL/usr/lib/openelec

    mkdir -p $INSTALL/etc
      cat $PKG_DIR/config/swap.conf | \
        sed -e "s,@SWAPFILESIZE@,$SWAPFILESIZE,g" \
            -e "s,@SWAP_ENABLED_DEFAULT@,$SWAP_ENABLED_DEFAULT,g" \
            > $INSTALL/etc/swap.conf
  fi
}

post_install () {
  if [ "$SWAP_SUPPORT" = "yes" ]; then
    enable_service swap.service
  fi
}
