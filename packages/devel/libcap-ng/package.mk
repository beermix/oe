# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2019-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="libcap-ng"
PKG_VERSION="0.7.10"
PKG_SHA256="a84ca7b4e0444283ed269b7a29f5b6187f647c82e2b876636b49b9a744f0ffbf"
PKG_URL="http://people.redhat.com/sgrubb/libcap-ng/libcap-ng-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain"

PKG_CONFIGURE_OPTS_TARGET="ac_cv_prog_swig_found=no --without-python --disable-shared --enable-static"

PKG_CONFIGURE_OPTS_HOST="$PKG_CONFIGURE_OPTS_TARGET"

PKG_CONFIGURE_OPTS_INIT="$PKG_CONFIGURE_OPTS_TARGET"