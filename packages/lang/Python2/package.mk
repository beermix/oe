# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)

PKG_NAME="Python2"
PKG_VERSION="2.7.15"
PKG_SHA256="22d9b1ac5b26135ad2b8c2901a9413537e08749a753356ee913c84dbd2df5574"
PKG_ARCH="any"
PKG_LICENSE="OSS"
PKG_SITE="http://www.python.org/"
PKG_URL="http://www.python.org/ftp/python/$PKG_VERSION/${PKG_NAME::-1}-$PKG_VERSION.tar.xz"
PKG_SOURCE_DIR="${PKG_NAME::-1}-$PKG_VERSION*"
PKG_DEPENDS_HOST="zlib:host bzip2:host expat:host sqlite:host"
PKG_DEPENDS_TARGET="toolchain sqlite expat zlib bzip2 openssl libffi Python2:host"
PKG_SECTION="lang"
PKG_SHORTDESC="python2: The Python2 programming language"
PKG_LONGDESC="Python2 is an interpreted object-oriented programming language, and is often compared with Tcl, Perl, Java or Scheme."

PKG_TOOLCHAIN="autotools"
PKG_BUILD_FLAGS="-parallel +lto-parallel"

PKG_PY_DISABLED_MODULES="_tkinter nis gdbm bsddb ossaudiodev"

PKG_CONFIGURE_OPTS_HOST="--cache-file=config.cache \
                         ac_cv_prog_HAS_HG=/bin/false \
                         ac_cv_prog_SVNVERSION=/bin/false \
                         --without-cxx-main \
                         --with-threads \
                         --disable-ipv6 \
                         --enable-unicode=ucs4 \
                         --with-expat=system"

PKG_CONFIGURE_OPTS_TARGET="ac_cv_file_dev_ptc=no \
                           ac_cv_file_dev_ptmx=yes \
                           ac_cv_func_lchflags_works=no \
                           ac_cv_func_chflags_works=no \
                           ac_cv_func_printf_zd=yes \
                           ac_cv_buggy_getaddrinfo=no \
                           ac_cv_header_bluetooth_bluetooth_h=no \
                           ac_cv_header_bluetooth_h=no \
                           ac_cv_file__dev_ptmx=no \
                           ac_cv_file__dev_ptc=no \
                           ac_cv_have_long_long_format=yes \
                           --with-threads \
                           --enable-unicode=ucs4 \
                           --disable-ipv6 \
                           --disable-profiling \
                           --without-pydebug \
                           --without-doc-strings \
                           --without-tsc \
                           --with-pymalloc \
                           --without-fpectl \
                           --without-cxx-main \
                           --with-system-ffi \
                           --with-expat=system"
post_patch() {
  # This is needed to make sure the Python build process doesn't try to
  # regenerate those files with the pgen program. Otherwise, it builds
  # pgen for the target, and tries to run it on the host.
    touch $PKG_BUILD/Include/graminit.h
    touch $PKG_BUILD/Python/graminit.c
}

pre_configure_host() {
  export LDFLAGS="$HOST_LDFLAGS -Wl,--enable-new-dtags"
}

make_host() {
  make PYTHON_MODULES_INCLUDE="$HOST_INCDIR" \
       PYTHON_MODULES_LIB="$HOST_LIBDIR" \
       PYTHON_DISABLE_MODULES="readline _curses _curses_panel $PKG_PY_DISABLED_MODULES"

  # python distutils per default adds -L$LIBDIR when linking binary extensions
    sed -e "s|^ 'LIBDIR':.*| 'LIBDIR': '/usr/lib',|g" -i $(cat pybuilddir.txt)/_sysconfigdata.py
}

makeinstall_host() {
  make PYTHON_MODULES_INCLUDE="$HOST_INCDIR" \
       PYTHON_MODULES_LIB="$HOST_LIBDIR" \
       PYTHON_DISABLE_MODULES="readline _curses _curses_panel $PKG_PY_DISABLED_MODULES" \
       install
}

post_makeinstall_host() {
  rm -fr $PKG_BUILD/.$HOST_NAME/build/temp.*
}

pre_configure_target() {
  export PYTHON_FOR_BUILD=$TOOLCHAIN/bin/python
}

make_target() {
  make  CC="$CC" LDFLAGS="$TARGET_LDFLAGS -L." \
        PYTHON_DISABLE_MODULES="$PKG_PY_DISABLED_MODULES" \
        PYTHON_MODULES_INCLUDE="$TARGET_INCDIR" \
        PYTHON_MODULES_LIB="$TARGET_LIBDIR"
}

makeinstall_target() {
  make  CC="$CC" DESTDIR=$SYSROOT_PREFIX \
        PYTHON_DISABLE_MODULES="$PKG_PY_DISABLED_MODULES" \
        PYTHON_MODULES_INCLUDE="$TARGET_INCDIR" \
        PYTHON_MODULES_LIB="$TARGET_LIBDIR" \
        install

  make  CC="$CC" DESTDIR=$INSTALL \
        PYTHON_DISABLE_MODULES="$PKG_PY_DISABLED_MODULES" \
        PYTHON_MODULES_INCLUDE="$TARGET_INCDIR" \
        PYTHON_MODULES_LIB="$TARGET_LIBDIR" \
        install
}

post_makeinstall_target() {
  rm -fr $PKG_BUILD/.$TARGET_NAME/build/temp.*

  for dir in bsddb idlelib lib-tk lib2to3 msilib pydoc_data test unittest; do
    rm -rf $INSTALL/usr/lib/python*/$dir
  done

  rm -rf $INSTALL/usr/lib/python*/config
  rm -rf $INSTALL/usr/bin/2to3
  rm -rf $INSTALL/usr/bin/idle
  rm -rf $INSTALL/usr/bin/pydoc
  rm -rf $INSTALL/usr/bin/smtpd.py
  rm -rf $INSTALL/usr/bin/python*-config

  cd $INSTALL/usr/lib/$PKG_PYTHON_VERSION
  $TOOLCHAIN/bin/python -Wi -t -B $PKG_BUILD/Lib/compileall.py -d /usr/lib/$PKG_PYTHON_VERSION -f .
  find $INSTALL/usr/lib/$PKG_PYTHON_VERSION -name "*.py" -exec rm -f {} \; &>/dev/null

  # strip
  chmod u+w $INSTALL/usr/lib/libpython*.so.*
  debug_strip $INSTALL/usr
}
