# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="xorg-server"
PKG_VERSION="c20e7b5e2222c0cae2a487264748fa5db711e6e4"
PKG_SHA256=""
PKG_ARCH="any"
PKG_LICENSE="OSS"
PKG_SITE="https://www.x.org/archive/individual/xserver/?C=M;O=D"
PKG_URL="http://xorg.freedesktop.org/archive/individual/xserver/$PKG_NAME-$PKG_VERSION.tar.bz2"
PKG_URL="https://cgit.freedesktop.org/xorg/xserver/snapshot/$PKG_VERSION.tar.xz"
PKG_SOURCE_DIR="$PKG_VERSION*"
PKG_DEPENDS_TARGET="toolchain util-macros font-util xorgproto libpciaccess libX11 libXfont2 libXinerama libxshmfence libxkbfile libdrm openssl freetype pixman systemd xorg-launch-helper libXcomposite libtirpc libepoxy nettle"
PKG_NEED_UNPACK="$(get_pkg_directory xf86-video-nvidia) $(get_pkg_directory xf86-video-nvidia-legacy)"
PKG_SECTION="x11/xserver"
PKG_SHORTDESC="xorg-server: The Xorg X server"
PKG_LONGDESC="Xorg is a full featured X server that was originally designed for UNIX and UNIX-like operating systems running on Intel x86 hardware."

get_graphicdrivers

PKG_MESON_OPTS_TARGET="-Dos_vendor="LibreELEC.tv" \
			  -Dipv6=false \
			  -Ddmx=false \
			  -Dxvfb=false \
			  -Dxnest=false \
			  -Dxcsecurity=false \
			  -Dxorg=true \
			  -Dxephyr=false \
			  -Dglamor=false \
			  -Dudev=true \
			  -Dsystemd_logind=false \
			  -Dxdmcp=false \
			  -Dxkb_dir=$XORG_PATH_XKB \
			  -Dxkb_output_dir=/var/cache/xkb"

pre_configure_target() {
  LDFLAGS="$LDFLAGS -lpthread"
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
