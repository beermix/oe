# SPDX-License-Identifier: GPL-2.0-or-later-or-later
# Copyright (C) 2017 Escalade
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="gtk3"
PKG_VERSION="3.24.10"
PKG_SHA256=""
PKG_LICENSE="LGPL"
PKG_SITE="https://ftp.acc.umu.se/pub/gnome/sources/gtk+/?C=M;O=D"
PKG_URL="https://ftp.gnome.org/pub/gnome/sources/gtk+/${PKG_VERSION:0:4}/gtk+-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain at-spi2-atk atk cairo gdk-pixbuf glib libX11 libXi libXrandr libepoxy pango"
PKG_LONGDESC="A library for creating graphical user interfaces for the X Window System."
PKG_TOOLCHAIN="meson"

pre_configure_target() {
#  export CFLAGS="$CFLAGS -DG_ENABLE_DEBUG -DG_DISABLE_CAST_CHECKS"
   export CFLAGS="$CFLAGS -DG_DISABLE_CAST_CHECKS"
}

PKG_MESON_OPTS_TARGET="-Dx11_backend=true \
			  -Dwayland_backend=false \
			  -Dbroadway_backend=false \
			  -Dwin32_backend=false \
			  -Dquartz_backend=false \
			  -Dmir_backend=false \
			  -Dintrospection=false \
			  -Dprint_backends=file \
			  -Dcolord=no \
			  -Dgtk_doc=false \
			  -Dman=false \
			  -Ddemos=false \
			  -Dexamples=false \
			  -Dtests=false \
			  -Dinstalled_tests=false"

#pre_configure_target() {
#  LIBS="$LIBS -lXcursor"
#  export PKG_CONFIG_PATH="$(get_build_dir pango)/.$TARGET_NAME/meson-private:$(get_build_dir gdk-pixbuf)/.$TARGET_NAME/meson-private:$(get_build_dir shared-mime-info)/.$TARGET_NAME"
#  export CFLAGS="$CFLAGS -I$(get_build_dir pango) -I$(get_build_dir pango)/.$TARGET_NAME -L$(get_build_dir pango)/.$TARGET_NAME/pango"
#  export GLIB_COMPILE_RESOURCES=glib-compile-resources GLIB_MKENUMS=glib-mkenums GLIB_GENMARSHAL=glib-genmarshal
#}

#makeinstall_target() {
#  :
#}
