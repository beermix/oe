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

PKG_NAME="libxml2"
PKG_VERSION="fb56f80"
PKG_ARCH="any"
PKG_SITE="http://xmlsoft.org"
PKG_GIT_URL="git://git.gnome.org/libxml2"
PKG_DEPENDS_HOST="zlib:host icu"
PKG_DEPENDS_TARGET="toolchain zlib readline icu libxml2:host"
PKG_PRIORITY="optional"
PKG_SECTION="textproc"
PKG_SHORTDESC="libxml: XML parser library for Gnome"
PKG_LONGDESC="The libxml package contains an XML library, which allows you to manipulate XML files. XML (eXtensible Markup Language) is a data format for structured document interchange via the Web."
PKG_IS_ADDON="no"

PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_ALL="ac_cv_header_ansidecl_h=no \
			  --enable-static \
			  --enable-shared \
			  --enable-silent-rules \
			  --disable-ipv6 \
			  --without-python \
			  --with-zlib=$ROOT/$TOOLCHAIN \
			  --without-lzma \
			  --with-threads \
			  --with-history"

PKG_CONFIGURE_OPTS_HOST="$PKG_CONFIGURE_OPTS_ALL --with-zlib=$ROOT/$TOOLCHAIN --with-icu=$ROOT/$TOOLCHAIN"

PKG_CONFIGURE_OPTS_TARGET="$PKG_CONFIGURE_OPTS_ALL \
			     --with-zlib=$SYSROOT_PREFIX/usr \
			     --with-sysroot=$SYSROOT_PREFIX \
			     --with-icu=$SYSROOT_PREFIX/usr"
			     
pre_configure_host() {
  export LDFLAGS=`echo $LDFLAGS | sed -e "s|-Wl,--as-needed|-Wl,-O1,--as-needed|"`
}

pre_configure_target() {
  export LDFLAGS=`echo $LDFLAGS | sed -e "s|-Wl,--as-needed|-Wl,-O1,--as-needed|"`
}

post_makeinstall_target() {
  $SED "s:\(['= ]\)/usr:\\1$SYSROOT_PREFIX/usr:g" $SYSROOT_PREFIX/usr/bin/xml2-config

  rm -rf $INSTALL/usr/bin
  rm -rf $INSTALL/usr/lib/xml2Conf.sh
}
