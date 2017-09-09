################################################################################
#      This file is part of OpenELEC - http://www.openelec.tv
#      Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
#
#  OpenELEC is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 2 of the License, or
#  (at your option) any later version.
#
#  OpenELEC is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with OpenELEC.  If not, see <http://www.gnu.org/licenses/>.
################################################################################

PKG_NAME="glibc"
PKG_VERSION="2.26"
PKG_URL="https://ftp.gnu.org/gnu/glibc/glibc-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="ccache:host autotools:host autoconf:host linux:host gcc:bootstrap localedef-eglibc:host"
PKG_DEPENDS_INIT="glibc"
PKG_PRIORITY="optional"
PKG_SECTION="toolchain/devel"
PKG_SHORTDESC="glibc: The GNU C library"
PKG_LONGDESC="The Glibc package contains the main C library. This library provides the basic routines for allocating memory, searching directories, opening and closing files, reading and writing files, string handling, pattern matching, arithmetic, and so on."

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

PKG_CONFIGURE_OPTS_TARGET="BASH_SHELL=/bin/sh \
                           libc_cv_slibdir=/lib \
                           ac_cv_path_PERL= \
                           ac_cv_prog_MAKEINFO= \
                           --libexecdir=/usr/lib/glibc \
                           --cache-file=config.cache \
                           --disable-profile \
                           --disable-sanity-checks \
                           --enable-add-ons \
                           --enable-bind-now \
                           --with-elf \
                           --enable-stack-protector=strong \
                           --with-tls \
                           --with-__thread \
                           --with-binutils=$ROOT/$BUILD/toolchain/bin \
                           --with-headers=$SYSROOT_PREFIX/usr/include \
                           --enable-kernel=3.0.0 \
                           --without-cvs \
                           --without-gd \
                           --enable-obsolete-rpc \
                           --enable-obsolete-nsl \
                           --disable-build-nscd \
                           --disable-nscd \
                           --enable-lock-elision \
                           --disable-timezone-tools \
                           --disable-werror \
                           --disable-debug"

NSS_CONF_DIR="$ROOT/$PKG_BUILD/nss"

pre_build_target() {
  cd $ROOT/$PKG_BUILD
    aclocal --force --verbose
    autoconf --force --verbose
  cd -
}

pre_configure_target() {
# Fails to compile with GCC's link time optimization.
  strip_lto

# glibc dont support GOLD linker.
  strip_gold

# Filter out some problematic *FLAGS
  export CFLAGS=`echo $CFLAGS | sed -e "s|-fstack-protector-strong -D_FORTIFY_SOURCE=2||g"`
  export CFLAGS=`echo $CFLAGS | sed -e "s|-fstack-protector-strong||g"`
  export CFLAGS=`echo $CFLAGS | sed -e "s|-ffast-math||g"`
  export CFLAGS=`echo $CFLAGS | sed -e "s|-Ofast|-O2|g"`
  export CFLAGS=`echo $CFLAGS | sed -e "s|-O.|-O2|g"`
  export CFLAGS=`echo $CFLAGS | sed -e "s|-fstack-protector-strong||g"`
  export CFLAGS=`echo $CFLAGS | sed -e "s|-fstack-protector-strong -fno-plt||g"`
  export CFLAGS=`echo $CFLAGS | sed -e "s|-D_FORTIFY_SOURCE=.||g"`
  export CPPFLAGS=`echo $CPPFLAGS | sed -e "s|-D_FORTIFY_SOURCE=.||g"`

  if [ -n "$PROJECT_CFLAGS" ]; then
    export CFLAGS=`echo $CFLAGS | sed -e "s|$PROJECT_CFLAGS||g"`
  fi

  export LDFLAGS=`echo $LDFLAGS | sed -e "s|-ffast-math||g"`
  export LDFLAGS=`echo $LDFLAGS | sed -e "s|-Ofast|-O2|g"`
  export LDFLAGS=`echo $LDFLAGS | sed -e "s|-O.|-O2|g"`
  export LDFLAGS=`echo $LDFLAGS | sed -e "s|-fstack-protector-strong||g"`
  export LDFLAGS=`echo $LDFLAGS | sed -e "s|-D_FORTIFY_SOURCE=.||g"`
  export LDFLAGS=`echo $LDFLAGS | sed -e "s|-Wl,-O1,--sort-common,--as-needed,-z,relro||g"`
  export CFLAGS=`echo $CFLAGS | sed -e "s|-D_FORTIFY_SOURCE=.||g"`

  export LDFLAGS=`echo $LDFLAGS | sed -e "s|-Wl,-O1,--as-needed||g"`
  export LDFLAGS=`echo $LDFLAGS | sed -e "s|-Wl,--as-needed||"`
  export LDFLAGS=`echo $LDFLAGS | sed -e "s|-Wl,-O1,--sort-common,--as-needed,-z,relro,-z,now||"`

  unset LD_LIBRARY_PATH

# set some CFLAGS we need
  export CFLAGS="$CFLAGS -g"

  export OBJDUMP_FOR_HOST=objdump

cat >config.cache <<EOF
libc_cv_forced_unwind=yes
libc_cv_c_cleanup=yes
libc_cv_ssp=no
libc_cv_ssp_strong=no
EOF

echo "sbindir=/usr/bin" >> configparms
echo "rootsbindir=/usr/bin" >> configparms

GLIBC_INCLUDE_BIN="getent ldd locale"
}

post_makeinstall_target() {
# xlocale.h was renamed - create symlink for compatibility
  ln -sf $SYSROOT_PREFIX/usr/include/bits/types/__locale_t.h $SYSROOT_PREFIX/usr/include/xlocale.h

# we are linking against ld.so, so symlink
  ln -sf $(basename $INSTALL/lib/ld-*.so) $INSTALL/lib/ld.so

# cleanup
# remove any programs we don't want/need, keeping only those we want
  for f in $(find $INSTALL/usr/bin -type f); do
    fb="$(basename "${f}")"
    for ib in $GLIBC_INCLUDE_BIN; do
      if [ "${ib}" == "${fb}" ]; then
        fb=
        break
      fi
    done
    [ -n "${fb}" ] && rm -rf ${f}
  done

  rm -rf $INSTALL/usr/lib/audit
  rm -rf $INSTALL/usr/lib/glibc
  rm -rf $INSTALL/usr/lib/libc_pic
  rm -rf $INSTALL/usr/lib/*.o
  rm -rf $INSTALL/usr/lib/*.map
  rm -rf $INSTALL/var

# remove locales and charmaps
  rm -rf $INSTALL/usr/share/i18n/charmaps

  if [ -n "$GLIBC_LOCALES" ]; then
    mkdir -p $INSTALL/usr/lib/locale
    for locale in $GLIBC_LOCALES; do
      echo ">>> install inputfile $(echo $locale | cut -f1 -d ".") with charmap $(echo $locale | cut -f2 -d ".") as $locale <<<"
      I18NPATH=../localedata \
      $ROOT/$TOOLCHAIN/bin/localedef \
        -i ../localedata/locales/$(echo $locale | cut -f1 -d ".") \
        -f ../localedata/charmaps/$(echo $locale | cut -f2 -d ".") \
        $locale --prefix=$INSTALL
    done
  fi

  if [ ! "$GLIBC_LOCALES" = yes ]; then
    rm -rf $INSTALL/usr/share/i18n/locales
    mkdir -p $INSTALL/usr/share/i18n/locales
      cp -PR $ROOT/$PKG_BUILD/localedata/locales/POSIX $INSTALL/usr/share/i18n/locales
  fi

# create default configs
  mkdir -p $INSTALL/etc
    cp $PKG_DIR/config/nsswitch-target.conf $INSTALL/etc/nsswitch.conf
    cp $PKG_DIR/config/host.conf $INSTALL/etc
    cp $PKG_DIR/config/gai.conf $INSTALL/etc

  if [ "$TARGET_ARCH" = "arm" -a "$TARGET_FLOAT" = "hard" ]; then
    ln -sf ld.so $INSTALL/lib/ld-linux.so.3
  fi
}

configure_init() {
  cd $ROOT/$PKG_BUILD
    rm -rf $ROOT/$PKG_BUILD/.$TARGET_NAME-init
}

make_init() {
  : # reuse make_target()
}

makeinstall_init() {
  mkdir -p $INSTALL/lib
    cp -PR $ROOT/$PKG_BUILD/.$TARGET_NAME/elf/ld*.so* $INSTALL/lib
    cp -PR $ROOT/$PKG_BUILD/.$TARGET_NAME/libc.so* $INSTALL/lib
    cp -PR $ROOT/$PKG_BUILD/.$TARGET_NAME/math/libm.so* $INSTALL/lib
    cp -PR $ROOT/$PKG_BUILD/.$TARGET_NAME/nptl/libpthread.so* $INSTALL/lib
    cp -PR $ROOT/$PKG_BUILD/.$TARGET_NAME/rt/librt.so* $INSTALL/lib
    cp -PR $ROOT/$PKG_BUILD/.$TARGET_NAME/resolv/libnss_dns.so* $INSTALL/lib
    cp -PR $ROOT/$PKG_BUILD/.$TARGET_NAME/resolv/libresolv.so* $INSTALL/lib

    if [ "$TARGET_ARCH" = "arm" -a "$TARGET_FLOAT" = "hard" ]; then
      ln -sf ld.so $INSTALL/lib/ld-linux.so.3
    fi
}

post_makeinstall_init() {
# create default configs
  mkdir -p $INSTALL/etc
    cp $PKG_DIR/config/nsswitch-init.conf $INSTALL/etc/nsswitch.conf
}
