################################################################################
#      This file is part of LibreELEC - https://libreelec.tv
#      Copyright (C) 2018-present Team LibreELEC
#
#  LibreELEC is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 2 of the License, or
#  (at your option) any later version.
#
#  LibreELEC is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with LibreELEC.  If not, see <http://www.gnu.org/licenses/>.
################################################################################

PKG_NAME="krb5"
PKG_VERSION="1.16.1-final"
PKG_SHA256="d46a676bd6cfe58b8684ffd881bc7ed2c9c90cb43ccfa45a9500530e84aa262b"
PKG_ARCH="any"
PKG_LICENSE="MIT"
PKG_SITE="http://web.mit.edu/kerberos/"
PKG_URL="https://github.com/krb5/krb5/archive/krb5-$PKG_VERSION.tar.gz"
PKG_SOURCE_DIR="krb5-krb5-$PKG_VERSION"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="The Kerberos network authentication protocol"
PKG_TOOLCHAIN="autotools"

PKG_CONFIGURE_OPTS_TARGET="ac_cv_func_regcomp=yes \
                           ac_cv_printf_positional=yes \
                           krb5_cv_attr_constructor_destructor=yes,yes"

post_unpack() {
  rm -rf $PKG_BUILD/doc
  mv $PKG_BUILD/src/* $PKG_BUILD
}
