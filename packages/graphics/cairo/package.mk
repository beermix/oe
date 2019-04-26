# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)

PKG_NAME="cairo"
PKG_VERSION="1.16.0"
PKG_SHA256="5e7b29b3f113ef870d1e3ecf8adf21f923396401604bda16d44be45e66052331"
PKG_LICENSE="LGPL"
PKG_SITE="https://cairographics.org/snapshots/?C=M;O=D"
PKG_URL="https://cairographics.org/snapshots/cairo-$PKG_VERSION.tar.xz"
PKG_URL="https://cairographics.org/releases/cairo-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain zlib freetype fontconfig libpng pixman"
PKG_LONGDESC="Cairo is a vector graphics library with cross-device output support."
PKG_TOOLCHAIN="configure" # ToDo

if [ "$OPENGL" != "no" ]; then
  PKG_DEPENDS_TARGET+=" $OPENGL"
fi

if [ "$OPENGLES" != "no" ]; then
  PKG_DEPENDS_TARGET+=" $OPENGLES"
fi

if [ "$DISPLAYSERVER" = "x11" ]; then
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET libXrender libX11 mesa"
  PKG_CAIRO_CONFIG="--x-includes="$SYSROOT_PREFIX/usr/include" \
                    --x-libraries="$SYSROOT_PREFIX/usr/lib" \
                    --enable-xlib \
                    --enable-xlib-xrender \
                    --enable-gl \
                    --enable-glx \
                    --disable-glesv2 \
                    --disable-egl \
                    --with-x"
else
  PKG_CAIRO_CONFIG="--disable-xlib \
                    --disable-xlib-xrender \
                    --disable-gl \
                    --disable-glx \
                    --enable-glesv2 \
                    --enable-egl \
                    --without-x"
fi

PKG_CONFIGURE_OPTS_TARGET="$PKG_CAIRO_CONFIG \
                           --enable-silent-rules \
                           --enable-shared \
                           --disable-static \
                           --disable-gtk-doc \
                           --enable-largefile \
                           --enable-atomic \
                           --disable-gcov \
                           --disable-valgrind \
                           --disable-xcb \
                           --disable-xlib-xcb \
                           --disable-xcb-shm \
                           --disable-qt \
                           --disable-quartz \
                           --disable-quartz-font \
                           --disable-quartz-image \
                           --disable-win32 \
                           --disable-win32-font \
                           --disable-skia \
                           --disable-os2 \
                           --disable-beos \
                           --disable-cogl \
                           --disable-drm \
                           --disable-gallium \
                           --enable-png \
                           --disable-directfb \
                           --disable-vg \
                           --disable-wgl \
                           --disable-script \
                           --enable-ft \
                           --enable-fc \
                           --enable-ps \
                           --enable-pdf \
                           --enable-svg \
                           --disable-test-surfaces \
                           --disable-tee \
                           --disable-xml \
                           --enable-pthread \
                           --enable-gobject=yes \
                           --disable-full-testing \
                           --disable-trace \
                           --enable-interpreter \
                           --disable-symbol-lookup \
                           --enable-some-floating-point \
                           --with-gnu-ld"
