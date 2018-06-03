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
PKG_VERSION="2.24"
PKG_VERSION="17d5d67"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/bminor/glibc/tree/release/2.24/master"
PKG_URL="https://github.com/bminor/glibc/archive/$PKG_VERSION.tar.gz"
#PKG_URL="http://ftpmirror.gnu.org/glibc/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="ccache:host autotools:host autoconf:host linux:host gcc:bootstrap"
PKG_DEPENDS_INIT="glibc"
PKG_SECTION="toolchain/devel"
PKG_SHORTDESC="glibc: The GNU C library"
PKG_LONGDESC="The Glibc package contains the main C library. This library provides the basic routines for allocating memory, searching directories, opening and closing files, reading and writing files, string handling, pattern matching, arithmetic, and so on."
PKG_BUILD_FLAGS="-parallel -lto -gold -hardening"
PKG_BUILD_FLAGS="-lto -gold -hardening"

PKG_CONFIGURE_OPTS_TARGET="BASH_SHELL=/bin/sh \
                           ac_cv_path_PERL=no \
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
                           --with-binutils=$BUILD/toolchain/bin \
                           --with-headers=$SYSROOT_PREFIX/usr/include \
                           --enable-kernel=4.4 \
                           --without-cvs \
                           --without-gd \
                           --enable-obsolete-rpc \
                           --disable-build-nscd \
                           --disable-nscd \
                           --enable-lock-elision \
                           --disable-debug \
                           --without-selinux \
                           --disable-timezone-tools"

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
# Filter out some problematic *FLAGS
  export CFLAGS=`echo $CFLAGS | sed -e "s|-fstack-protector-strong -D_FORTIFY_SOURCE=2||g"`
  export CFLAGS=`echo $CFLAGS | sed -e "s|-fstack-protector-strong||g"`
  export CFLAGS=`echo $CFLAGS | sed -e "s|-ffast-math||g"`
  export CFLAGS=`echo $CFLAGS | sed -e "s|-Wl,--copy-dt-needed-entries -fasynchronous-unwind-tables -Wp,-D_REENTRANT -ftree-loop-distribute-patterns -malign-data=abi -fno-semantic-interposition -ftree-vectorize -ftree-loop-vectorize||g"`
  export CFLAGS=`echo $CFLAGS | sed -e "s|--param l1-cache-line-size=64 --param l1-cache-size=32 --param l2-cache-size=3072||g"`
  export CFLAGS=`echo $CFLAGS | sed -e "s|--param=l1-cache-line-size=64 --param=l1-cache-size=32 --param=l2-cache-size=3072||g"`
  export CFLAGS=`echo $CFLAGS | sed -e "s|-fno-plt||g"`
  export CFLAGS=`echo $CFLAGS | sed -e "s|-fno-caller-saves||g"`
  export CFLAGS=`echo $CFLAGS | sed -e "s|-fomit-frame-pointer||g"`
  export CFLAGS=`echo $CFLAGS | sed -e "s|-pipe -fno-caller-saves -fno-plt||g"`
  export CFLAGS=`echo $CFLAGS | sed -e "s|-Ofast|-O2|g"`
  export CFLAGS=`echo $CFLAGS | sed -e "s|-O.|-O2|g"`
  export CFLAGS=`echo $CFLAGS | sed -e "s|-g0|-O2|g"`
  export CFLAGS=`echo $CFLAGS | sed -e "s|-fstack-protector-strong||g"`
  export CFLAGS=`echo $CFLAGS | sed -e "s|-fstack-protector-strong -fno-plt||g"`
  export CFLAGS=`echo $CFLAGS | sed -e "s|-D_FORTIFY_SOURCE=.||g"`
  export CPPFLAGS=`echo $CPPFLAGS | sed -e "s|-Wp,||g"`
  export CPPFLAGS=`echo $CPPFLAGS | sed -e "s|-D_FORTIFY_SOURCE=.||g"`
  export LDFLAGS=`echo $LDFLAGS | sed -e "s|-ffast-math||g"`
  export LDFLAGS=`echo $LDFLAGS | sed -e "s|-Ofast|-O2|g"`
  export LDFLAGS=`echo $LDFLAGS | sed -e "s|-O.|-O2|g"`
  export LDFLAGS=`echo $LDFLAGS | sed -e "s|-fstack-protector-strong||g"`
  export LDFLAGS=`echo $LDFLAGS | sed -e "s|-D_FORTIFY_SOURCE=.||g"`
  export LDFLAGS=`echo $LDFLAGS | sed -e "s|-Wl,-O1,--sort-common,--as-needed,-z,relro||g"`
  export CFLAGS=`echo $CFLAGS | sed -e "s|-D_FORTIFY_SOURCE=.||g"`

  if [ -n "$PROJECT_CFLAGS" ]; then
    export CFLAGS=`echo $CFLAGS | sed -e "s|$PROJECT_CFLAGS||g"`
  fi

  export LDFLAGS=`echo $LDFLAGS | sed -e "s|-ffast-math||g"`
  export LDFLAGS=`echo $LDFLAGS | sed -e "s|-Ofast|-O2|g"`
  export LDFLAGS=`echo $LDFLAGS | sed -e "s|-O.|-O2|g"`
  export LDFLAGS=`echo $LDFLAGS | sed -e "s|-Wl,-O1,--as-needed||g"`
  export LDFLAGS=`echo $LDFLAGS | sed -e "s|-Wl,--as-needed||"`
  export LDFLAGS=`echo $LDFLAGS | sed -e "s|-Wl,-O1,--sort-common,--as-needed,-z,relro,-z,now||"`

  unset LD_LIBRARY_PATH

  export CFLAGS="--param=l1-cache-line-size=64 --param=l1-cache-size=32 --param=l2-cache-size=3072 -O2 -march=westmere -g -m64"

  export BUILD_CC=$HOST_CC
  export OBJDUMP_FOR_HOST=objdump

  cat >config.cache <<EOF
libc_cv_forced_unwind=yes
libc_cv_c_cleanup=yes
libc_cv_ssp=no
libc_cv_ssp_strong=no
libc_cv_slibdir=/usr/lib
EOF

  cat >configparms <<EOF
libdir=/usr/lib
slibdir=/usr/lib
sbindir=/usr/bin
rootsbindir=/usr/bin
build-programs=yes
EOF

  # binaries to install into target
  GLIBC_INCLUDE_BIN="getent ldd locale"

  # Generic "installer" needs localedef to define drawing chars
  if [ "$PROJECT" = "Generic" ]; then
    GLIBC_INCLUDE_BIN+=" localedef"
  fi
}

post_makeinstall_target() {
# we are linking against ld.so, so symlink
  ln -sf $(basename $INSTALL/usr/lib/ld-*.so) $INSTALL/usr/lib/ld.so

# cleanup
# remove any programs we don't want/need, keeping only those we want
  for f in $(find $INSTALL/usr/bin -type f); do
    listcontains "${GLIBC_INCLUDE_BIN}" "$(basename "${f}")" || rm -fr "${f}"
  done

  rm -rf $INSTALL/usr/lib/audit
  rm -rf $INSTALL/usr/lib/glibc
  rm -rf $INSTALL/usr/lib/libc_pic
  rm -rf $INSTALL/usr/lib/*.o
  rm -rf $INSTALL/usr/lib/*.map
  rm -rf $INSTALL/var

# remove locales and charmaps
  rm -rf $INSTALL/usr/share/i18n/charmaps

# add UTF-8 charmap for Generic (charmap is needed for installer)
  if [ "$PROJECT" = "Generic" ]; then
    mkdir -p $INSTALL/usr/share/i18n/charmaps
    cp -PR $PKG_BUILD/localedata/charmaps/UTF-8 $INSTALL/usr/share/i18n/charmaps
    gzip $INSTALL/usr/share/i18n/charmaps/UTF-8
  fi

  if [ ! "$GLIBC_LOCALES" = yes ]; then
    rm -rf $INSTALL/usr/share/i18n/locales

    mkdir -p $INSTALL/usr/share/i18n/locales
      cp -PR $PKG_BUILD/localedata/locales/POSIX $INSTALL/usr/share/i18n/locales
  fi

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
