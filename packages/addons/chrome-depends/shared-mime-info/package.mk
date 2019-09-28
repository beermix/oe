# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="shared-mime-info"
PKG_VERSION="1.10"
PKG_SHA256="c625a83b4838befc8cafcd54e3619946515d9e44d63d61c4adf7f5513ddfbebf"
PKG_LICENSE="GPL2"
PKG_SITE="https://freedesktop.org/wiki/Software/shared-mime-info/"
PKG_URL="http://freedesktop.org/~hadess/shared-mime-info-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain libxml2"
PKG_LONGDESC="The shared-mime-info package contains the core database of common types."
PKG_BUILD_FLAGS="-parallel"

PKG_CONFIGURE_OPTS_TARGET="--disable-nls \
                           --disable-update-mimedb"

#makeinstall_target() {
#  :
#}
