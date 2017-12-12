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
PKG_SHA256="7cf9f447ae7ed1c51722efc45e7f14418d15d7a1e143ac9f09a668999f4fc94d"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="http://www.swig.org"
PKG_URL="$SOURCEFORGE_SRC/swig/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_HOST="ccache:host"
PKG_SECTION="devel"
PKG_SHORTDESC="SWIG: a software development tool that connects programs written in C and C++ with a variety of high-level programming languages."
PKG_LONGDESC="SWIG is a software development tool that connects programs written in C and C++ with a variety of high-level programming languages."

PKG_CONFIGURE_OPTS_HOST="--program-suffix=3.0 \
                         --with-pcre-prefix=$TOOLCHAIN \
                         --with-boost=no \
                         --without-pcre \
                         --without-x \
                         --without-tcl \
                         --without-python \
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
                         --without-lua \
                         --without-allegrocl \
                         --without-clisp \
                         --without-r \
                         --without-go \
                         --without-d"

post_makeinstall_host() {
  ln -sf swig3.0 $TOOLCHAIN/bin/swig
}
