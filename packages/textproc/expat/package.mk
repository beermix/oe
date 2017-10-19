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

PKG_NAME="expat"
PKG_VERSION="2.2.4"
PKG_URL="http://sources.lede-project.org/expat-$PKG_VERSION.tar.bz2"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="textproc"
PKG_SHORTDESC="expat: XML parser library"
PKG_LONGDESC="Expat is an XML parser library written in C. It is a stream-oriented parser in which an application registers handlers for things the parser might find in the XML document (like start tags). An introductory article on using Expat is available on xml.com."


PKG_AUTORECONF="no"

PKG_CMAKE_OPTS_TARGET="-DBUILD_tools=ON -DBUILD_examples=OFF -DBUILD_tests=OFF -DBUILD_shared=ON"

pre_make_target() {
  # fix builderror when building in subdirs
  cp -r ../doc .
}
