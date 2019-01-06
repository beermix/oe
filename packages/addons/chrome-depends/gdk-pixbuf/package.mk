# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2016-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="gdk-pixbuf"
PKG_VERSION="2.38.0"
PKG_SHA256="dd50973c7757bcde15de6bcd3a6d462a445efd552604ae6435a0532fbbadae47"
PKG_LICENSE="OSS"
PKG_SITE="https://ftp.gnome.org/pub/gnome/sources/gdk-pixbuf/?C=M;O=D"
PKG_URL="https://ftp.gnome.org/pub/gnome/sources/gdk-pixbuf/${PKG_VERSION:0:4}/gdk-pixbuf-$PKG_VERSION.tar.xz"
#PKG_DEPENDS_TARGET="toolchain glib libjpeg-turbo libpng jasper shared-mime-info tiff"

#PKG_MESON_OPTS_TARGET="-Ddocs=false \
#                       -Dgir=false \
#                       -Dman=false \
#                       -Drelocatable=false \
#                       -Dbuiltin_loaders=none \
#                       -Dpng=true \
#                       -Dtiff=true \
#                       -Djpeg=true \
#                       -Djasper=true \
#                       -Dx11=true \
#                       -Dinstalled_tests=false"

PKG_MESON_OPTS_TARGET="-Ddocs=false \
                       -Dgir=false \
                       -Dman=false \
                       -Drelocatable=false"