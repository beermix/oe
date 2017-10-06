PKG_NAME="gobject-introspection"
PKG_VERSION="230b258"
PKG_SHA256=""
PKG_ARCH="any"
PKG_LICENSE="LGPL"
PKG_SITE="http://www.gtk.org/"
PKG_GIT_URL="https://git.gnome.org/browse/gobject-introspection"
PKG_DEPENDS_TARGET="toolchain glib qemu:host"
PKG_DEPENDS_HOST="glib:host"
PKG_SECTION="devel"
PKG_SHORTDESC="glib: C support library"
PKG_LONGDESC="GLib is a library which includes support routines for C such as lists, trees, hashes, memory allocation, and many other things."

PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_HOST="--disable-static --disable-doctool --disable-gtk-doc"

PKG_CONFIGURE_OPTS_TARGET="$PKG_CONFIGURE_OPTS_HOST"

post_unpack() {
  rm -f $ROOT/$PKG_BUILD/gtk-doc.make
  cat > $ROOT/$PKG_BUILD/gtk-doc.make <<EOF
EXTRA_DIST =
CLEANFILES =
EOF
}

pre_configure_host() {
  CFLAGS="$CFLAGS -fPIC"
}

pre_configure_target() {
  PYTHON_INCLUDES="-I$SYSROOT_PREFIX/usr/include/python2.7"
  CPPFLAGS="-I$SYSROOT_PREFIX/usr/include/python2.7"
  CFLAGS="$CFLAGS -fPIC"
#  LDFLAGS="$LDFLAGS -Wl,--dynamic-linker=/usr/lib/ld-$(get_pkg_build glibc).so"

cat > $ROOT/$TOOLCHAIN/bin/g-ir-scanner-wrapper << EOF
#!/bin/sh
env LD_LIBRARY_PATH=$ROOT/$PKG_BUILD/.$TARGET_NAME/.libs:$SYSROOT_PREFIX/usr/lib:$SYSROOT_PREFIX/../lib \
    GI_CROSS_LAUNCHER="$ROOT/$TOOLCHAIN/bin/qemu-$TARGET_ARCH -L $SYSROOT_PREFIX" \
    GI_LDD=$ROOT/$TOOLCHAIN/bin/ldd-cross \
    $ROOT/$TOOLCHAIN/bin/g-ir-scanner "\$@"
EOF

  chmod +x $ROOT/$TOOLCHAIN/bin/g-ir-scanner-wrapper

cat > $ROOT/$TOOLCHAIN/bin/g-ir-compiler-wrapper << EOF
#!/bin/sh
env LD_LIBRARY_PATH=$ROOT/$PKG_BUILD/.$TARGET_NAME/.libs:$SYSROOT_PREFIX/usr/lib:$SYSROOT_PREFIX/../lib \
    GI_CROSS_LAUNCHER="$ROOT/$TOOLCHAIN/bin/qemu-$TARGET_ARCH -L $SYSROOT_PREFIX" \
    GI_LDD=$ROOT/$TOOLCHAIN/bin/ldd-cross \
    $ROOT/$TOOLCHAIN/bin/g-ir-compiler "\$@"
EOF

  chmod +x $ROOT/$TOOLCHAIN/bin/g-ir-compiler-wrapper

cat > $ROOT/$TOOLCHAIN/bin/ldd-cross << EOF
#!/bin/sh
$ROOT/$TOOLCHAIN/bin/qemu-$TARGET_ARCH $SYSROOT_PREFIX/lib/ld-$(get_pkg_build glibc).so --list "\$1"
EOF

  chmod +x $ROOT/$TOOLCHAIN/bin/ldd-cross
}


post_makeinstall_target() {
  rm -rf $INSTALL/usr/bin
  rm -rf $INSTALL/usr/lib/gobject-introspection
  rm -rf $INSTALL/usr/share
}
