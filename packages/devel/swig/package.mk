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

PKG_NAME="swig"
PKG_VERSION="3.0.12"
PKG_SITE="https://github.com/swig/swig/releases"
PKG_URL="$SOURCEFORGE_SRC/swig/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_PRIORITY="optional"
PKG_DEPENDS_HOST="ccache:host pcre:host"
PKG_SECTION="devel"
PKG_SHORTDESC="SWIG: a software development tool that connects programs written in C and C++ with a variety of high-level programming languages."
PKG_LONGDESC="SWIG is a software development tool that connects programs written in C and C++ with a variety of high-level programming languages."

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

#PKG_CONFIGURE_OPTS_HOST="--with-pcre-prefix=$ROOT/$TOOLCHAIN"

PKG_CONFIGURE_OPTS_HOST="--without-x \
                         --without-tcl \
                         --without-python3 \
                         --without-perl5 \
                         --without-octave \
                         --without-java \
                         --without-gcj \
                         --without-android \
                         --without-guile \
                         --without-mzscheme \
                         --without-ruby \
                         --without-php \
                         --without-ocaml \
                         --without-pike \
                         --without-chicken \
                         --without-csharp \
                         --without-allegrocl \
                         --without-clisp \
                         --without-r \
                         --without-d"
