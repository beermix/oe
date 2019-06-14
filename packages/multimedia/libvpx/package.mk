# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2016-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="libvpx"
#PKG_VERSION="1.7.0"
#PKG_SHA256="1fec931eb5c94279ad219a5b6e0202358e94a93a90cfb1603578c326abfc1238"
PKG_VERSION="b625feb"
PKG_SITE="https://github.com/webmproject/libvpx"
PKG_URL="https://github.com/webmproject/libvpx/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain yasm:host"
PKG_LONGDESC="WebM VP8/VP9 Codec"
PKG_BUILD_FLAGS="-lto -gold -hardening"

get_graphicdrivers

configure_target() {

  case $ARCH in
    aarch64)
      PKG_TARGET_NAME_LIBVPX="arm64-linux-gcc"
      ;;
    arm)
      PKG_TARGET_NAME_LIBVPX="armv7-linux-gcc"
      ;;
    x86_64)
      PKG_TARGET_NAME_LIBVPX="x86_64-linux-gcc"
      ;;
  esac

  $PKG_CONFIGURE_SCRIPT --prefix=/usr \
                        --extra-cflags="$CFLAGS" \
                        --as=yasm \
                        --target=$PKG_TARGET_NAME_LIBVPX \
                        --disable-docs \
                        --disable-examples \
                        --disable-shared \
                        --disable-tools \
                        --disable-unit-tests \
                        --disable-vp8-decoder \
                        --disable-vp9-decoder \
                        --enable-ccache \
                        --enable-pic \
                        --enable-static \
                        --enable-vp8 \
                        --enable-vp9
}
