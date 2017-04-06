################################################################################
#      This file is part of OpenELEC - http://www.openelec.tv
#      Copyright (C) 2009-2017 Stephan Raue (stephan@openelec.tv)
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

PKG_NAME="Python"
PKG_VERSION="2.7.13"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="OSS"
PKG_SITE="http://www.python.org/"
PKG_URL="http://www.python.org/ftp/python/$PKG_VERSION/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_HOST="zlib:host bzip2:host gdbm:host libffi:host"
PKG_DEPENDS_TARGET="toolchain Python:host sqlite expat zlib bzip2 pcre openssl libffi readline gdbm"
PKG_PRIORITY="optional"
PKG_SECTION="lang"
PKG_SHORTDESC="python: The Python programming language"
PKG_LONGDESC="Python is an interpreted object-oriented programming language, and is often compared with Tcl, Perl, Java or Scheme."

PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"


PKG_CONFIGURE_OPTS_HOST="--cache-file=config.cache \
                         --without-cxx-main \
                         --with-threads \
                         --enable-unicode=ucs4"

PKG_CONFIGURE_OPTS_TARGET="ac_cv_file__dev_ptmx=no \
			      ac_cv_file__dev_ptc=no \
			      --enable-shared \
			      --with-threads \
			      --disable-ipv6 \
			      --with-system-ffi \
			      --with-system-expat \
			      --with-system-zlib \
			      --enable-unicode=ucs4"
post_patch() {
    touch $PKG_BUILD/Include/graminit.h
    touch $PKG_BUILD/Python/graminit.c
}

make_host() {
  make -j1 PYTHON_MODULES_INCLUDE="$HOST_INCDIR" \
       PYTHON_MODULES_LIB="$HOST_LIBDIR"

  # python distutils per default adds -L$LIBDIR when linking binary extensions
    sed -e "s|^ 'LIBDIR':.*| 'LIBDIR': '/usr/lib',|g" -i $(cat pybuilddir.txt)/_sysconfigdata.py
}

makeinstall_host() {
  make -j1 PYTHON_MODULES_INCLUDE="$HOST_INCDIR" \
       PYTHON_MODULES_LIB="$HOST_LIBDIR" \
       install
}

pre_configure_target() {
  export PYTHON_FOR_BUILD=$ROOT/$TOOLCHAIN/bin/python
  export CFLAGS="$CFLAGS -fno-inline"
  #export CPPFLAGS="$CPPFLAGS -D_DEFAULT_SOURCE"
  #strip_gold
}

make_target() {
  make -j1  CC="$CC" LDFLAGS="$TARGET_LDFLAGS -L." \
        PYTHON_MODULES_INCLUDE="$TARGET_INCDIR" \
        PYTHON_MODULES_LIB="$TARGET_LIBDIR"
}

makeinstall_target() {
  make -j1  CC="$CC" DESTDIR=$SYSROOT_PREFIX \
        PYTHON_MODULES_INCLUDE="$TARGET_INCDIR" \
        PYTHON_MODULES_LIB="$TARGET_LIBDIR" \
        install

  make -j1  CC="$CC" DESTDIR=$INSTALL \
        PYTHON_MODULES_INCLUDE="$TARGET_INCDIR" \
        PYTHON_MODULES_LIB="$TARGET_LIBDIR" \
        install
}

post_makeinstall_target() {

  rm -rf $INSTALL/usr/lib/python*/config
  rm -rf $INSTALL/usr/bin/pydoc
  rm -rf $INSTALL/usr/bin/smtpd.py
  rm -rf $INSTALL/usr/bin/python*-config

  python -Wi -t -B $ROOT/$PKG_BUILD/Lib/compileall.py -d /usr/lib/python2.7 -f .
  find $INSTALL/usr/lib/python2.7 -name "*.py" -exec rm -f {} \; &>/dev/null

  chmod u+w $INSTALL/usr/lib/libpython2.7.so*
}
