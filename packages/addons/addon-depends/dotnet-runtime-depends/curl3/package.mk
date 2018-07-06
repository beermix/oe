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

. $(get_pkg_directory curl)/package.mk

PKG_NAME="curl3"
PKG_URL=""
PKG_LONGDESC="curl for dotnet"

unpack() {
  mkdir -p $PKG_BUILD
  cp -r $(get_build_dir curl)/* $PKG_BUILD
  sed -i 's/CURL_@CURL_LT_SHLIB_VERSIONED_FLAVOUR@4/CURL_@CURL_LT_SHLIB_VERSIONED_FLAVOUR@3/g' $PKG_BUILD/lib/libcurl.vers.in
}

makeinstall_target() {
  :
}

post_makeinstall_target() {
  :
}
