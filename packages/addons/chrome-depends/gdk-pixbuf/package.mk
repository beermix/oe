# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2016-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="gdk-pixbuf"
PKG_VERSION="2.37.0"
PKG_SHA256="81508700f500eca3f21c4cfd0a3486459a373a65e07457a9a4f3bf7d08109c11"
PKG_ARCH="any"
PKG_LICENSE="OSS"
PKG_SITE="https://ftp.gnome.org/pub/gnome/sources/gdk-pixbuf/?C=M;O=D"
PKG_URL="https://ftp.gnome.org/pub/gnome/sources/gdk-pixbuf/${PKG_VERSION:0:4}/gdk-pixbuf-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain glib libjpeg-turbo libpng jasper shared-mime-info tiff"
PKG_LONGDESC="GdkPixbuf is a a GNOME library for image loading and manipulation."

PKG_MESON_OPTS_TARGET="-Ddocs=false \
                       -Dgir=false \
                       -Dman=false \
                       -Drelocatable=false \
                       -Dx11=true \
                       -Djasper=true \
                       -Dpng=true \
                       -Dtiff=true \
                       -Djpeg=true \
                       -Dinstalled_tests=false"
