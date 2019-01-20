# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="xorg-server"
PKG_VERSION="709c656"
PKG_LICENSE="OSS"
PKG_SITE="https://cgit.freedesktop.org/xorg/xserver/log/" # https://github.com/mirror/xserver
PKG_URL="http://xorg.freedesktop.org/archive/individual/xserver/$PKG_NAME-$PKG_VERSION.tar.bz2"
PKG_URL="https://cgit.freedesktop.org/xorg/xserver/snapshot/$PKG_VERSION.tar.xz"
#PKG_URL="https://github.com/mirror/xserver/archive/${PKG_VERSION}.tar.gz"
PKG_SOURCE_DIR="$PKG_VERSION*"
#PKG_SOURCE_DIR="xserver-$PKG_VERSION*"
PKG_DEPENDS_TARGET="toolchain util-macros font-util xorgproto libpciaccess libX11 libXfont2 libXinerama libxshmfence libxkbfile libdrm openssl freetype pixman systemd xorg-launch-helper nettle libXcomposite mesa libepoxy"
PKG_NEED_UNPACK="$(get_pkg_directory xf86-video-nvidia) $(get_pkg_directory xf86-video-nvidia-legacy)"
PKG_LONGDESC="Xorg is a full featured X server running on Intel x86 hardware."
PKG_TOOLCHAIN="autotools"

get_graphicdrivers

PKG_MESON_OPTS_TARGET="-Dos_vendor="LibreELEC.tv" \
			  -Dipv6=false \
			  -Ddmx=false \
			  -Dxvfb=false \
			  -Dxnest=false \
			  -Dxcsecurity=false \
			  -Dxorg=true \
			  -Dxephyr=false \
			  -Dxwayland_eglstream=false \
			  -Dglamor=true \
			  -Ddri2=true \
			  -Ddri3=true \
			  -Dudev=true \
			  -Dxv=true \
			  -Dxres=true \
			  -Dxvmc=false \
			  -Dpciaccess=true \
			  -Dvbe=true \
			  -Dvgahw=true \
			  -Dglx=true \
			  -Dlinux_acpi=false \
			  -Dmitshm=true \
			  -Dint10=x86emu \
			  -Dxinerama=true \
			  -Dxselinux=false \
			  -Dsystemd_logind=false \
			  -Dxdmcp=false \
			  -Dmodule_dir=$XORG_PATH_MODULES \
			  -Dlog_dir=/var/log \
			  -Ddefault_font_path=/usr/share/fonts/misc,built-ins \
			  -Dxkb_dir=$XORG_PATH_XKB \
			  -Dxkb_output_dir=/var/cache/xkb"

pre_configure_target() {
  LDFLAGS="$LDFLAGS -lm -ldl -lz -lpthread"
  CFLAGS=`echo $CFLAGS | sed -e "s|-O3|-O2|" -e "s|-Ofast|-O2|"`
  LDFLAGS=`echo $LDFLAGS | sed -e "s|-O3|-O2|" -e "s|-Ofast|-O2|"`
}

post_makeinstall_target() {
  rm -rf $INSTALL/var/cache/xkb

  mkdir -p $INSTALL/usr/lib/xorg
    cp -P $PKG_DIR/scripts/xorg-configure $INSTALL/usr/lib/xorg
      sed -i -e "s|@NVIDIA_VERSION@|$(get_pkg_version xf86-video-nvidia)|g" $INSTALL/usr/lib/xorg/xorg-configure
      sed -i -e "s|@NVIDIA_LEGACY_VERSION@|$(get_pkg_version xf86-video-nvidia-legacy)|g" $INSTALL/usr/lib/xorg/xorg-configure

  if [ ! "$OPENGL" = "no" ]; then
    if [ -f $INSTALL/usr/lib/xorg/modules/extensions/libglx.so ]; then
      mv $INSTALL/usr/lib/xorg/modules/extensions/libglx.so \
         $INSTALL/usr/lib/xorg/modules/extensions/libglx_mesa.so # rename for cooperate with nvidia drivers
      ln -sf /var/lib/libglx.so $INSTALL/usr/lib/xorg/modules/extensions/libglx.so
    fi
  fi

  mkdir -p $INSTALL/etc/X11
    if find_file_path config/xorg.conf ; then
      cp $FOUND_PATH $INSTALL/etc/X11
    fi
}

post_install() {
  enable_service xorg.service
}
