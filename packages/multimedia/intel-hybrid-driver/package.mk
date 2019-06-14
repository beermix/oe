# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="intel-hybrid-driver"
PKG_VERSION="1.0.2"
PKG_SHA256=""
PKG_ARCH="x86_64"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/01org/intel-hybrid-driver/releases"
PKG_URL="https://github.com/01org/intel-hybrid-driver/archive/${PKG_VERSION}.tar.gz"
PKG_SOURCE_DIR="$PKG_NAME-gdb-$PKG_VERSION*"
PKG_DEPENDS_TARGET="toolchain libva cmrt"
PKG_SECTION="multimedia"
PKG_SHORTDESC="intel-vaapi-driver: VA-API user mode driver for Intel GEN Graphics family"
PKG_LONGDESC="intel-vaapi-driver: VA-API user mode driver for Intel GEN Graphics family"
PKG_TOOLCHAIN="autotools"

PKG_CONFIGURE_OPTS_TARGET="--disable-silent-rules \
                           --enable-drm \
                           --enable-x11"
