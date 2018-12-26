# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)
# --enable-stack-protector=strong --enable-static-pie \
                          
PKG_NAME="glibc"
PKG_VERSION="a0bc5dd"
PKG_SHA256=""
PKG_LICENSE="GPL"
PKG_SITE="https://sourceware.org/git/gitweb.cgi?p=glibc.git;a=shortlog"
PKG_SITE="https://github.com/bminor/glibc/tree/release/2.28/master"
PKG_SITE="https://github.com/bminor/glibc"
PKG_URL="https://github.com/bminor/glibc/archive/$PKG_VERSION.tar.gz"
#PKG_URL="http://ftp.gnu.org/pub/gnu/glibc/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="ccache:host autotools:host autoconf:host linux:host gcc:bootstrap"
PKG_DEPENDS_INIT="glibc"
PKG_BUILD_FLAGS="-lto -gold -hardening"

PKG_CONFIGURE_OPTS_TARGET="BASH_SHELL=/bin/bash \
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
                           --enable-kernel=4.19 \
                           --without-cvs \
                           --without-gd \
                           --disable-build-nscd \
                           --disable-nscd \
                           --enable-lock-elision \
                           --disable-timezone-tools"

# busybox:init needs it  \ --disable-werror
# testcase: boot with /storage as nfs-share (set cmdline.txt -> "ip=dhcp boot=UUID=2407-5145 disk=NFS=[nfs-share] quiet")
PKG_CONFIGURE_OPTS_TARGET+=" --enable-obsolete-rpc"

if build_with_debug; then
  PKG_CONFIGURE_OPTS_TARGET="$PKG_CONFIGURE_OPTS_TARGET --enable-debug"
else
  PKG_CONFIGURE_OPTS_TARGET="$PKG_CONFIGURE_OPTS_TARGET --disable-debug"
fi

NSS_CONF_DIR="$PKG_BUILD/nss"

pre_build_target() {
  cd $PKG_BUILD
    aclocal --force --verbose
    autoconf --force --verbose
  cd -
}

pre_configure_target() {
#  export CCACHE_DISABLE=true
# Filter out some problematic *FLAGS
  export CFLAGS=`echo $CFLAGS | sed -e "s|-fstack-protector-strong -D_FORTIFY_SOURCE=2||g"`
  export CFLAGS=`echo $CFLAGS | sed -e "s|-fstack-protector-strong||g"`
  export CFLAGS=`echo $CFLAGS | sed -e "s|-ffast-math||g"`
  export CFLAGS=`echo $CFLAGS | sed -e "s|-Wl,--copy-dt-needed-entries -fasynchronous-unwind-tables -Wp,-D_REENTRANT -ftree-loop-distribute-patterns -malign-data=abi -fno-semantic-interposition -ftree-vectorize -ftree-loop-vectorize||g"`
  export CFLAGS=`echo $CFLAGS | sed -e "s|--param l1-cache-line-size=64 --param l1-cache-size=32 --param l2-cache-size=3072||g"`
  export CFLAGS=`echo $CFLAGS | sed -e "s|-fgraphite-identity -floop-nest-optimize -ftree-loop-distribution||g"`
  export CFLAGS=`echo $CFLAGS | sed -e "s|-fno-plt||g"`
  export CFLAGS=`echo $CFLAGS | sed -e "s|-fno-caller-saves||g"`
  export CFLAGS=`echo $CFLAGS | sed -e "s|-fomit-frame-pointer||g"`
  export CFLAGS=`echo $CFLAGS | sed -e "s|-pipe -fno-caller-saves||g"`
  export CFLAGS=`echo $CFLAGS | sed -e "s|-Ofast|-O2|g"`
  export CFLAGS=`echo $CFLAGS | sed -e "s|-O.|-O2|g"`
  export CFLAGS=`echo $CFLAGS | sed -e "s|-g0|-O2|g"`
  export CFLAGS=`echo $CFLAGS | sed -e "s|-fstack-protector-strong||g"`
  export CFLAGS=`echo $CFLAGS | sed -e "s|-fstack-protector-strong||g"`
  export CFLAGS=`echo $CFLAGS | sed -e "s|-D_FORTIFY_SOURCE=.||g"`
  export CPPFLAGS=`echo $CPPFLAGS | sed -e "s|-Wp,||g"`
  export CPPFLAGS=`echo $CPPFLAGS | sed -e "s|-D_FORTIFY_SOURCE=.||g"`
  export LDFLAGS=`echo $LDFLAGS | sed -e "s|-ffast-math||g"`
  export LDFLAGS=`echo $LDFLAGS | sed -e "s|-Ofast|-O2|g"`
  export LDFLAGS=`echo $LDFLAGS | sed -e "s|-O.|-O2|g"`
  export LDFLAGS=`echo $LDFLAGS | sed -e "s|-fstack-protector-strong||g"`
  export LDFLAGS=`echo $LDFLAGS | sed -e "s|-D_FORTIFY_SOURCE=.||g"`
  export LDFLAGS=`echo $LDFLAGS | sed -e "s|-Wl,-O1,--sort-common,--as-needed,-z,relro||g"`
  export LDFLAGS=`echo $LDFLAGS | sed -e "s|,-z,relro,-z,now||g"`
  export CFLAGS=`echo $CFLAGS | sed -e "s|-D_FORTIFY_SOURCE=.||g"`

  if [ -n "$PROJECT_CFLAGS" ]; then
    export CFLAGS=`echo $CFLAGS | sed -e "s|$PROJECT_CFLAGS||g"`
  fi

  export LDFLAGS=`echo $LDFLAGS | sed -e "s|-ffast-math||g"`
  export LDFLAGS=`echo $LDFLAGS | sed -e "s|-Ofast|-O2|g"`
  export LDFLAGS=`echo $LDFLAGS | sed -e "s|-O.|-O2|g"`

  export LDFLAGS=`echo $LDFLAGS | sed -e "s|-Wl,--as-needed||"`
  export LDFLAGS=`echo $LDFLAGS | sed -e "s|-Wl,-O1,--as-needed||"`

  unset LD_LIBRARY_PATH

  # set some CFLAGS we need
  # export CFLAGS="$CFLAGS -g"

  export CFLAGS="$CFLAGS -g2  -Wl,-z,max-page-size=0x1000 "
  unset LDFLAGS
  export LDFLAGS="-Wl,-z,max-page-size=0x1000 "

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
# xlocale.h was renamed - create symlink for compatibility
# ln -sf $SYSROOT_PREFIX/usr/include/bits/types/__locale_t.h $SYSROOT_PREFIX/usr/include/xlocale.h

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

  mkdir -p $INSTALL/usr/config/locale
    [ -e $PKG_DIR/config/locale-archive ] && cp $PKG_DIR/config/locale-archive $INSTALL/usr/config/locale
    ln -s /storage/.config/locale $INSTALL/usr/lib/locale

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
