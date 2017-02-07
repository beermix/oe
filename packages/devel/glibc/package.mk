PKG_NAME="glibc"
PKG_VERSION="2.24-33-ge9e69e4"
PKG_SITE="http://www.gnu.org/software/libc/"
PKG_URL="http://192.168.1.2:8887/glibc-2.24-33-ge9e69e4.tar.gz"
PKG_DEPENDS_TARGET="ccache:host autotools:host autoconf:host linux:host gcc:bootstrap localedef-eglibc:host"
PKG_DEPENDS_INIT="glibc"
PKG_PRIORITY="optional"
PKG_SECTION="toolchain/devel"
PKG_SHORTDESC="glibc: The GNU C library"
PKG_LONGDESC="The Glibc package contains the main C library. This library provides the basic routines for allocating memory, searching directories, opening and closing files, reading and writing files, string handling, pattern matching, arithmetic, and so on."

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

PKG_CONFIGURE_OPTS_TARGET="BASH_SHELL=/bin/bash \
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
                           --with-tls \
                           --with-__thread \
                           --with-binutils=$ROOT/$BUILD/toolchain/bin \
                           --with-headers=$SYSROOT_PREFIX/usr/include \
                           --enable-kernel=3.0.0 \
                           --without-cvs \
                           --without-gd \
                           --enable-obsolete-rpc \
                           --disable-build-nscd \
                           --disable-nscd \
                           --enable-lock-elision \
                           --disable-debug \
                           --disable-timezone-tools \
                           --disable-werror"


NSS_CONF_DIR="$PKG_BUILD/nss"

GLIBC_EXCLUDE_BIN="catchsegv gencat getconf iconv iconvconfig ldconfig"
GLIBC_EXCLUDE_BIN="$GLIBC_EXCLUDE_BIN localedef makedb mtrace pcprofiledump"
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

  unset LD_LIBRARY_PATH

# set some CFLAGS we need
  export CFLAGS="$CFLAGS -g -U_FORTIFY_SOURCE"
  export CXXFLAGS="$CXXFLAGS -fno-stack-protector -D_FORTIFY_SOURCE=0 -U_FORTIFY_SOURCE"
  export LDFLAGS="$LDFLAGS -fno-stack-protector -D_FORTIFY_SOURCE=0 -U_FORTIFY_SOURCE"
  export CPPFLAGS="$CPPFLAGS -fno-stack-protector -D_FORTIFY_SOURCE=0 -U_FORTIFY_SOURCE"
  
  
  export OBJDUMP_FOR_HOST=objdump

cat >config.cache <<EOF
libc_cv_forced_unwind=yes
libc_cv_c_cleanup=yes
libc_cv_ssp=no
libc_cv_ssp_strong=no
EOF

  echo "sbindir=/usr/bin" >> configparms
  echo "rootsbindir=/usr/bin" >> configparms
}

post_makeinstall_target() {
  ln -sf ld-$PKG_VERSION.so $INSTALL/lib/ld.so
  
  if [ "$TARGET_ARCH" = "arm" -a "$TARGET_FLOAT" = "hard" ]; then
    ln -sf ld-$PKG_VERSION.so $INSTALL/lib/ld-linux.so.3
  fi

# cleanup
  for i in $GLIBC_EXCLUDE_BIN; do
    rm -rf $INSTALL/usr/bin/$i
  done
   rm -rf $INSTALL/usr/lib/audit
   rm -rf $INSTALL/usr/lib/glibc
   rm -rf $INSTALL/usr/lib/*.o
   rm -rf $INSTALL/var

# remove unneeded libs
  rm -rf $INSTALL/usr/lib/libBrokenLocale*
  rm -rf $INSTALL/usr/lib/libSegFault.so
  rm -rf $INSTALL/usr/lib/libmemusage.so
  rm -rf $INSTALL/usr/lib/libpcprofile.so

# remove ldscripts
  rm -rf $INSTALL/usr/lib/libc.so
  rm -rf $INSTALL/usr/lib/libpthread.so
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
    cp $PKG_DIR/config/nsswitch.conf $INSTALL/etc
    cp $PKG_DIR/config/gai.conf $INSTALL/etc

    echo "multi on" > $INSTALL/etc/host.conf
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

    if [ "$TARGET_ARCH" = "arm" -a "$TARGET_FLOAT" = "hard" ]; then
      ln -sf ld.so $INSTALL/lib/ld-linux.so.3
    fi
}
