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

PKG_NAME="swig"
PKG_VERSION="3.0.12"
PKG_SITE="http://www.swig.org"
PKG_URL="https://master.dl.sourceforge.net/project/swig/swig/swig-$PKG_VERSION/swig-$PKG_VERSION.tar.gz"
PKG_DEPENDS_HOST="ccache:host pcre:host"
PKG_SECTION="devel"
PKG_SHORTDESC="SWIG: a software development tool that connects programs written in C and C++ with a variety of high-level programming languages."
PKG_LONGDESC="SWIG is a software development tool that connects programs written in C and C++ with a variety of high-level programming languages."

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

PKG_CONFIGURE_OPTS_HOST="--enable-static --disable-shared"