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
PKG_SHA256="e54e0a934cd2bc94429be79da5e9385898d2306b9eaf3c92d5a77af96190f6bd"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="http://www.gnu.org/software/libc/"
PKG_URL="http://ftp.gnu.org/pub/gnu/glibc/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="ccache:host autotools:host autoconf:host linux:host gcc:bootstrap"
PKG_DEPENDS_INIT="glibc"
PKG_SECTION="toolchain/devel"
PKG_SHORTDESC="glibc: The GNU C library"
PKG_LONGDESC="The Glibc package contains the main C library. This library provides the basic routines for allocating memory, searching directories, opening and closing files, reading and writing files, string handling, pattern matching, arithmetic, and so on."
PKG_AUTORECONF="no"

PKG_CONFIGURE_OPTS_TARGET="BASH_SHELL=/bin/sh \
                           ac_cv_path_PERL= \
                           ac_cv_prog_MAKEINFO= \
                           --libexecdir=/usr/lib/glibc \
                           --cache-file=config.cache \
                           --disable-profile \
                           --disable-sanity-checks \
                           --enable-add-ons \
                           --enable-bind-now \
                           --with-elf \
                           --with-tls \
                           --with-__thread \
                           --enable-stack-protector=strong \
                           --with-binutils=$BUILD/toolchain/bin \
                           --with-headers=$SYSROOT_PREFIX/usr/include \
                           --enable-kernel=3.0.0 \
                           --without-cvs \
                           --without-gd \
                           --enable-obsolete-rpc \
                           --enable-obsolete-nsl \
                           --disable-build-nscd \
                           --disable-nscd \
                           --enable-lock-elision \
                           --disable-timezone-tools"

if [ "$DEBUG" = yes ]; then
  PKG_CONFIGURE_OPTS_TARGET="$PKG_CONFIGURE_OPTS_TARGET --enable-debug"
else
  PKG_CONFIGURE_OPTS_TARGET="$PKG_CONFIGURE_OPTS_TARGET --disable-debug"
fi

NSS_CONF_DIR="$PKG_BUILD/nss"
GLIBC_EXCLUDE_BIN="catchsegv gencat getconf iconv iconvconfig ldconfig"
GLIBC_EXCLUDE_BIN="$GLIBC_EXCLUDE_BIN makedb mtrace pcprofiledump"
GLIBC_EXCLUDE_BIN="$GLIBC_EXCLUDE_BIN pldd rpcgen sln sotruss sprof xtrace"

pre_build_target() {
  cd $PKG_BUILD
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
  export CFLAGS=`echo $CFLAGS | sed -e "s|-fno-plt||g"`
  export CFLAGS=`echo $CFLAGS | sed -e "s|-fno-caller-saves||g"`
  export CFLAGS=`echo $CFLAGS | sed -e "s|-Ofast|-O2|g"`
  export CFLAGS=`echo $CFLAGS | sed -e "s|-O.|-O2|g"`
  export CFLAGS=`echo $CFLAGS | sed -e "s|-fstack-protector-strong||g"`
  export CFLAGS=`echo $CFLAGS | sed -e "s|-fstack-protector-strong -fno-plt||g"`
  export CFLAGS=`echo $CFLAGS | sed -e "s|-D_FORTIFY_SOURCE=.||g"`
  export CPPFLAGS=`echo $CPPFLAGS | sed -e "s|-Wp,||g"`
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
  export CFLAGS="$CFLAGS"

  export BUILD_CC=$HOST_CC
  export OBJDUMP_FOR_HOST=objdump

cat >config.cache <<EOF
libc_cv_forced_unwind=yes
libc_cv_c_cleanup=yes
libc_cv_ssp=no
libc_cv_ssp_strong=no
libc_cv_slibdir=/usr/lib
EOF

echo "libdir=/usr/lib" >> configparms
echo "slibdir=/usr/lib" >> configparms
echo "sbindir=/usr/bin" >> configparms
echo "rootsbindir=/usr/bin" >> configparms
}

post_makeinstall_target() {
# xlocale.h was renamed - create symlink for compatibility
  ln -sf $SYSROOT_PREFIX/usr/include/bits/types/__locale_t.h $SYSROOT_PREFIX/usr/include/xlocale.h

# we are linking against ld.so, so symlink
  ln -sf $(basename $INSTALL/usr/lib/ld-*.so) $INSTALL/usr/lib/ld.so

# cleanup
  for i in $GLIBC_EXCLUDE_BIN; do
    rm -rf $INSTALL/usr/bin/$i
  done

  rm -rf $INSTALL/usr/lib/audit
  rm -rf $INSTALL/usr/lib/glibc
  rm -rf $INSTALL/usr/lib/libc_pic
  rm -rf $INSTALL/usr/lib/*.o
  rm -rf $INSTALL/usr/lib/*.map
  rm -rf $INSTALL/var

# remove locales and charmaps
  rm -rf $INSTALL/usr/share/i18n/charmaps
  rm -rf $INSTALL/usr/share/i18n/locales

# add default locale
  mkdir -p $INSTALL/usr/lib/locale
  mkdir -p $INSTALL/etc/profile.d
  I18NPATH=../localedata 
  localedef -i ../localedata/locales/en_US -f ../localedata/charmaps/UTF-8 en_US.UTF-8 --prefix=$INSTALL
  localedef -i ../localedata/locales/ru_RU -f ../localedata/charmaps/UTF-8 ru_RU.UTF-8 --prefix=$INSTALL
  echo "export LANG=en_US.UTF-8" > $INSTALL/etc/profile.d/01-locale.conf
  echo "export LANG=ru_RU.UTF-8" > $INSTALL/etc/profile.d/01-locale.conf

# create default configs
  mkdir -p $INSTALL/etc
    cp $PKG_DIR/config/nsswitch-target.conf $INSTALL/etc/nsswitch.conf
    cp $PKG_DIR/config/host.conf $INSTALL/etc
    cp $PKG_DIR/config/gai.conf $INSTALL/etc

  if [ "$TARGET_ARCH" = "arm" -a "$TARGET_FLOAT" = "hard" ]; then
    ln -sf ld.so $INSTALL/usr/lib/ld-linux.so.3
  fi
}

configure_init() {
  cd $PKG_BUILD
    rm -rf $PKG_BUILD/.$TARGET_NAME-init
}

make_init() {
  : # reuse make_target()
}

makeinstall_init() {
  mkdir -p $INSTALL/usr/lib
    cp -PR $PKG_BUILD/.$TARGET_NAME/elf/ld*.so* $INSTALL/usr/lib
    cp -PR $PKG_BUILD/.$TARGET_NAME/libc.so* $INSTALL/usr/lib
    cp -PR $PKG_BUILD/.$TARGET_NAME/math/libm.so* $INSTALL/usr/lib
    cp -PR $PKG_BUILD/.$TARGET_NAME/nptl/libpthread.so* $INSTALL/usr/lib
    cp -PR $PKG_BUILD/.$TARGET_NAME/rt/librt.so* $INSTALL/usr/lib
    cp -PR $PKG_BUILD/.$TARGET_NAME/resolv/libnss_dns.so* $INSTALL/usr/lib
    cp -PR $PKG_BUILD/.$TARGET_NAME/resolv/libresolv.so* $INSTALL/usr/lib

    if [ "$TARGET_ARCH" = "arm" -a "$TARGET_FLOAT" = "hard" ]; then
      ln -sf ld.so $INSTALL/usr/lib/ld-linux.so.3
    fi
}

post_makeinstall_init() {
# create default configs
  mkdir -p $INSTALL/etc
    cp $PKG_DIR/config/nsswitch-init.conf $INSTALL/etc/nsswitch.conf
}
