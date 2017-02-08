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

PKG_NAME="gcc"
PKG_VERSION="620-Up"
PKG_URL="https://dl.dropboxusercontent.com/s/opz7ru3uf9k4zr2/gcc-620-Up.tar.bz2"
#PKG_VERSION="4ca53f0"
#PKG_GIT_URL="git://gcc.gnu.org/git/gcc.git"
PKG_DEPENDS_BOOTSTRAP="ccache:host autoconf:host binutils:host gmp:host mpfr:host mpc:host"
PKG_DEPENDS_TARGET="gcc:host"
PKG_DEPENDS_HOST="ccache:host autoconf:host binutils:host gmp:host mpfr:host mpc:host glibc"
PKG_PRIORITY="optional"
PKG_SECTION="lang"
PKG_SHORTDESC="gcc: The GNU Compiler Collection Version 4 (aka GNU C Compiler)"
PKG_LONGDESC="This package contains the GNU Compiler Collection. It includes compilers for the languages C, C++, Objective C, Fortran 95, Java and others ... This GCC contains the Stack-Smashing Protector Patch which can be enabled with the -fstack-protector command-line option. More information about it ca be found at http://www.research.ibm.com/trl/projects/security/ssp/."

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

GCC_COMMON_CONFIGURE_OPTS="--target=$TARGET_NAME \
                           --with-sysroot=$SYSROOT_PREFIX \
                           --with-gmp=$ROOT/$TOOLCHAIN \
                           --with-mpfr=$ROOT/$TOOLCHAIN \
                           --with-mpc=$ROOT/$TOOLCHAIN \
                           --with-gnu-as \
                           --with-gnu-ld \
                           --enable-plugin \
                           --enable-lto \
                           --enable-gold \
                           --enable-ld=default \
                           --disable-multilib \
                           --disable-nls \
                           --enable-checking=release \
                           --with-default-libstdcxx-abi=gcc4-compatible \
                           --with-system-zlib \
                           --without-ppl \
                           --without-cloog \
                           --disable-libada \
                           --disable-libmudflap \
                           --disable-libatomic \
                           --disable-libitm \
                           --disable-libquadmath \
                           --disable-libgomp \
                           --disable-libmpx \
                           --disable-libssp \
                           --with-tune=corei7 \
                           --enable-poison-system-directories"

PKG_CONFIGURE_OPTS_BOOTSTRAP="$GCC_COMMON_CONFIGURE_OPTS \
                              --enable-languages=c \
                              --disable-__cxa_atexit \
                              --disable-libsanitizer \
                              --enable-cloog-backend=isl \
                              --disable-shared \
                              --disable-threads \
                              --without-headers \
                              --with-newlib \
                              --disable-decimal-float \
                              $GCC_OPTS"

PKG_CONFIGURE_OPTS_HOST="$GCC_COMMON_CONFIGURE_OPTS \
                         --enable-languages=c,c++ \
                         --enable-__cxa_atexit \
                         --enable-decimal-float \
                         --enable-tls \
                         --enable-shared \
                         --disable-static \
                         --enable-c99 \
                         --enable-long-long \
                         --enable-threads=posix \
                         --disable-libstdcxx-pch \
                         --enable-libstdcxx-time \
                         --enable-clocale=gnu \
                         --enable-gnu-unique-object \
                         --enable-linker-build-id \
                         --with-linker-hash-style=gnu \
                         --enable-initfini-array \
                         --enable-gnu-indirect-function \
                         $GCC_OPTS"

pre_configure_host() {
  export CXXFLAGS="$CXXFLAGS -std=gnu++98"
  unset CPP
}

post_make_host() {
  # fix wrong link
  rm -rf $TARGET_NAME/libgcc/libgcc_s.so
  ln -sf libgcc_s.so.1 $TARGET_NAME/libgcc/libgcc_s.so

  if [ ! "$DEBUG" = yes ]; then
    ${TARGET_NAME}-strip $TARGET_NAME/libgcc/libgcc_s.so*
    ${TARGET_NAME}-strip $TARGET_NAME/libstdc++-v3/src/.libs/libstdc++.so*
  fi
}

post_makeinstall_host() {
  cp -PR $TARGET_NAME/libstdc++-v3/src/.libs/libstdc++.so* $SYSROOT_PREFIX/usr/lib

  mkdir -p $ROOT/$TOOLCHAIN/lib/ccache
    ln -sf $ROOT/$TOOLCHAIN/bin/ccache $ROOT/$TOOLCHAIN/lib/ccache/${TARGET_NAME}-gcc
    ln -sf $ROOT/$TOOLCHAIN/bin/ccache $ROOT/$TOOLCHAIN/lib/ccache/${TARGET_NAME}-g++
}

configure_target() {
 : # reuse configure_host()
}

make_target() {
 : # reuse make_host()
}

makeinstall_target() {
  mkdir -p $INSTALL/lib
    cp -P $ROOT/$PKG_BUILD/.$HOST_NAME/$TARGET_NAME/libgcc/libgcc_s.so* $INSTALL/lib
  mkdir -p $INSTALL/usr/lib
    cp -P $ROOT/$PKG_BUILD/.$HOST_NAME/$TARGET_NAME/libstdc++-v3/src/.libs/libstdc++.so* $INSTALL/usr/lib
}

configure_init() {
 : # reuse configure_host()
}

make_init() {
 : # reuse make_host()
}

makeinstall_init() {
  mkdir -p $INSTALL/lib
    cp -P $ROOT/$PKG_BUILD/.$HOST_NAME/$TARGET_NAME/libgcc/libgcc_s.so* $INSTALL/lib
}

post_unpack() {
cd $ROOT/$PKG_BUILD
patch <  $PKG_DIR/pat/svn-updates.patch
patch <  $PKG_DIR/pat/rename-info-files.patch
patch <  $PKG_DIR/pat/gcc-SOURCE_DATE_EPOCH-doc.patch
patch <  $PKG_DIR/pat/gcc-SOURCE_DATE_EPOCH-2-doc.patch
patch <  $PKG_DIR/pat/vulcan-cpu-doc.patch
patch <  $PKG_DIR/pat/gcc-gfdl-build.patch
patch <  $PKG_DIR/pat/gcc-textdomain.patch
patch <  $PKG_DIR/pat/gcc-driver-extra-langs.patch
patch <  $PKG_DIR/pat/gcc-hash-style-gnu.patch
patch <  $PKG_DIR/pat/libstdc++-pic.patch
patch <  $PKG_DIR/pat/libstdc++-doclink.patch
patch <  $PKG_DIR/pat/libstdc++-man-3cxx.patch
patch <  $PKG_DIR/pat/libstdc++-test-installed.patch
patch <  $PKG_DIR/pat/libjava-stacktrace.patch
patch <  $PKG_DIR/pat/libjava-jnipath.patch
patch <  $PKG_DIR/pat/libjava-sjlj.patch
patch <  $PKG_DIR/pat/libjava-disable-plugin.patch
patch <  $PKG_DIR/pat/alpha-no-ev4-directive.patch
patch <  $PKG_DIR/pat/boehm-gc-getnprocs.patch
patch <  $PKG_DIR/pat/note-gnu-stack.patch
patch <  $PKG_DIR/pat/libgomp-omp_h-multilib.patch
patch <  $PKG_DIR/pat/gccgo-version.patch
patch <  $PKG_DIR/pat/pr47818.patch
patch <  $PKG_DIR/pat/gcc-base-version.patch
patch <  $PKG_DIR/pat/libgo-testsuite.patch
patch <  $PKG_DIR/pat/gcc-target-include-asm.patch
patch <  $PKG_DIR/pat/libgo-revert-timeout-exp.patch
patch <  $PKG_DIR/pat/libgo-setcontext-config.patch
patch <  $PKG_DIR/pat/gcc-auto-build.patch
patch <  $PKG_DIR/pat/kfreebsd-unwind.patch
patch <  $PKG_DIR/pat/libitm-no-fortify-source.patch
patch <  $PKG_DIR/pat/sparc64-biarch-long-double-128.patch
patch <  $PKG_DIR/pat/gcc-ia64-bootstrap-ignore.patch
patch <  $PKG_DIR/pat/gotools-configury.patch
patch <  $PKG_DIR/pat/pr66368.patch
patch <  $PKG_DIR/pat/pr67590.patch
patch <  $PKG_DIR/pat/ada-gnattools-ldflags.patch
patch <  $PKG_DIR/pat/libjit-ldflags.patch
patch <  $PKG_DIR/pat/gcc-SOURCE_DATE_EPOCH.patch
patch <  $PKG_DIR/pat/gcc-SOURCE_DATE_EPOCH-2.patch
patch <  $PKG_DIR/pat/cmd-go-combine-gccgo-s-ld-and-ldShared-methods.patch
patch <  $PKG_DIR/pat/libjava-mips64el.patch
patch <  $PKG_DIR/pat/PR55947-revert.patch
patch <  $PKG_DIR/pat/gccgo-issue16780.patch
patch <  $PKG_DIR/pat/pr77379.patch
patch <  $PKG_DIR/pat/vulcan-cpu.patch
patch <  $PKG_DIR/pat/vulcan-costs.patch
patch <  $PKG_DIR/pat/libffi-pax.patch
patch <  $PKG_DIR/pat/libffi-race-condition.patch
patch <  $PKG_DIR/pat/pr77686-workaround.patch
patch <  $PKG_DIR/pat/libstdc++-functexcept.patch
patch <  $PKG_DIR/pat/ada-arm.patch
patch <  $PKG_DIR/pat/ada-kfreebsd.patch
patch <  $PKG_DIR/pat/ada-revert-pr63225.patch
patch <  $PKG_DIR/pat/ada-driver-check.patch
patch <  $PKG_DIR/pat/ada-gcc-name.patch
patch <  $PKG_DIR/pat/ada-default-project-path.patch
patch <  $PKG_DIR/pat/ada-library-project-files-soname.patch
patch <  $PKG_DIR/pat/ada-link-lib.patch
patch <  $PKG_DIR/pat/ada-libgnatvsn.patch
patch <  $PKG_DIR/pat/ada-libgnatprj.patch
patch <  $PKG_DIR/pat/ada-gnattools-cross.patch
patch <  $PKG_DIR/pat/ada-acats.patch
patch <  $PKG_DIR/pat/libgnatprj-cross-hack.patch
patch <  $PKG_DIR/pat/ada-sjlj.patch
patch <  $PKG_DIR/pat/ada-link-shlib.patch
patch <  $PKG_DIR/pat/gdc-6.patch
patch <  $PKG_DIR/pat/gdc-updates.patch
patch <  $PKG_DIR/pat/gdc-versym-cpu.patch
patch <  $PKG_DIR/pat/gdc-versym-os.patch
patch <  $PKG_DIR/pat/gdc-frontend-posix.patch
patch <  $PKG_DIR/pat/gdc-base-version.patch
patch <  $PKG_DIR/pat/gdc-profiledbuild.patch
patch <  $PKG_DIR/pat/gdc-libphobos-link.patch
patch <  $PKG_DIR/pat/gdc-symbol-mangling.patch
patch <  $PKG_DIR/pat/gdc-6-doc.patch
patch <  $PKG_DIR/pat/gdc-libphobos-build.patch
patch <  $PKG_DIR/pat/sys-auxv-header.patch
patch <  $PKG_DIR/pat/libcilkrts-targets.patch
patch <  $PKG_DIR/pat/arm-multilib-soft.patch
patch <  $PKG_DIR/pat/arm-multilib-defaults.patch
patch <  $PKG_DIR/pat/gcc-ice-dump.patch
patch <  $PKG_DIR/pat/gcc-ice-apport.patch
patch <  $PKG_DIR/pat/skip-bootstrap-multilib.patch
patch <  $PKG_DIR/pat/libjava-fixed-symlinks.patch
patch  <  $PKG_DIR/pat/libffi-ro-eh_frame_sect.patch
patch <  $PKG_DIR/pat/pr67899.patch
patch <  $PKG_DIR/pat/gcc-multiarch.patch
patch <  $PKG_DIR/pat/libjava-multiarch.patch
patch <  $PKG_DIR/pat/libjava-nobiarch-check.patch
patch <  $PKG_DIR/pat/config-ml.patch
patch <  $PKG_DIR/pat/g++-multiarch-incdir.patch
patch <  $PKG_DIR/pat/canonical-cpppath.patch
patch <  $PKG_DIR/pat/gcc-multilib-multiarch.patch
patch <  $PKG_DIR/pat/gcc-as-needed.patch
patch <  $PKG_DIR/pat/libgomp-kfreebsd-testsuite.patch
patch <  $PKG_DIR/pat/go-testsuite.patch
patch <  $PKG_DIR/pat/ada-749574.patch
patch <  $PKG_DIR/pat/ada-mips.patch
patch <  $PKG_DIR/pat/ada-bootstrap-compare.patch
patch <  $PKG_DIR/pat/gcc-default-ssp.patch
patch <  $PKG_DIR/pat/gcc-default-format-security.patch
patch <  $PKG_DIR/pat/gcc-default-ssp-strong.patch
patch <  $PKG_DIR/pat/gcc-default-fortify-source.patch
patch <  $PKG_DIR/pat/gcc-default-relro.patch
patch <  $PKG_DIR/pat/testsuite-hardening-format.patch
patch <  $PKG_DIR/pat/testsuite-hardening-printf-types.patch
patch <  $PKG_DIR/pat/testsuite-hardening-updates.patch
patch <  $PKG_DIR/pat/testsuite-glibc-warnings.patch
patch <  $PKG_DIR/pat/bind_now_when_pie-ubuntu.patch
}