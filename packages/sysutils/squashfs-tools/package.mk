# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2017-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="squashfs-tools"
PKG_VERSION="81e9fe70209406aad4df46985a85ff5ca8a54b11" # release 4.4
PKG_SHA256="8eecf452cfb541febd00c6a0056f12bfc25fd78731adabbda2ff49da23b58541"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/plougher/squashfs-tools"
PKG_URL="https://github.com/plougher/squashfs-tools/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_HOST="ccache:host zlib:host lzo:host xz:host zstd:host"
PKG_NEED_UNPACK="$(get_pkg_directory zlib) $(get_pkg_directory lzo) $(get_pkg_directory xz) $(get_pkg_directory zstd)"
PKG_LONGDESC="Tools for squashfs, a highly compressed read-only filesystem for Linux."
PKG_TOOLCHAIN="manual"

make_host() {
  make -C squashfs-tools \
          mksquashfs \
          XZ_SUPPORT=1 \
          LZO_SUPPORT=1 \
          ZSTD_SUPPORT=1 \
          XATTR_SUPPORT=0 \
          XATTR_DEFAULT=0 \
          INCLUDEDIR="-I. -I${TOOLCHAIN}/include"
}

makeinstall_host() {
  mkdir -p ${TOOLCHAIN}/bin
    cp squashfs-tools/mksquashfs ${TOOLCHAIN}/bin
}
