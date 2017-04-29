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

PKG_NAME="pcre"
PKG_VERSION="8.40"
PKG_SITE="http://www.pcre.org/"
PKG_URL="http://ftp.csx.cam.ac.uk/pub/software/programming/pcre/$PKG_NAME-$PKG_VERSION.tar.bz2"
PKG_DEPENDS_HOST="pcre2:host"
PKG_DEPENDS_TARGET="toolchain pcre2 libedit bzip2 libz"
PKG_SECTION="devel"
PKG_SHORTDESC="pcre: Perl Compatible Regulat Expressions"
PKG_LONGDESC="The PCRE library is a set of functions that implement regular expression pattern matching using the same syntax and semantics as Perl 5. PCRE has its own native API, as well as a set of wrapper functions that correspond to the POSIX regular expression API. The PCRE library is free, even for building commercial software."

PKG_IS_ADDON="no"
PKG_USE_CMAKE="no"
PKG_AUTORECONF="no"

PKG_CONFIGURE_OPTS_TARGET="--disable-shared \
			      --enable-static \
			      --enable-utf8 \
			      --enable-pcregrep-libz \
			      --enable-pcregrep-libbz2 \
			      --enable-pcretest-libedit=$SYSROOT_PREFIX/usr \
			      --enable-pcre16 \
			      --enable-unicode-properties \
			      --with-gnu-ld \
			      --disable-stack-for-recursion \
			      --enable-pcre8 \
			      --disable-pcre32 \
			      --enable-jit \
			      --with-pic \
			      --enable-cpp \
			      --enable-unicode-properties \
			      --enable-newline-is-anycrlf"
			      
PKG_CONFIGURE_OPTS_HOST="--prefix=$ROOT/$TOOLCHAIN $PKG_CONFIGURE_OPTS_TARGET"

post_makeinstall_target() {
  rm -rf $INSTALL/usr/bin
  sed -e "s:\(['= ]\)/usr:\\1$SYSROOT_PREFIX/usr:g" -i $SYSROOT_PREFIX/usr/bin/$PKG_NAME-config
}
