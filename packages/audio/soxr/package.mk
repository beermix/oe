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

PKG_NAME="soxr"
PKG_VERSION="0.1.3"
PKG_SHA256="b111c15fdc8c029989330ff559184198c161100a59312f5dc19ddeb9b5a15889"
PKG_ARCH="any"
PKG_LICENSE="LGPL"
PKG_SITE="http://sourceforge.net/p/soxr/wiki/Home/"
PKG_URL="$SOURCEFORGE_SRC/soxr/$PKG_NAME-$PKG_VERSION-Source.tar.xz"
PKG_SOURCE_DIR="$PKG_NAME-$PKG_VERSION-Source"
PKG_DEPENDS_TARGET="toolchain cmake:host"
PKG_SECTION="audio"
PKG_SHORTDESC="soxr: a library which performs one-dimensional sample-rate conversion."
PKG_LONGDESC="The SoX Resampler library performs one-dimensional sample-rate conversion. it may be used, for example, to resample PCM-encoded audio."
PKG_BUILD_FLAGS="+pic"

PKG_CMAKE_OPTS_TARGET="-DHAVE_WORDS_BIGENDIAN_EXITCODE=1 \
                       -DBUILD_TESTS=0 \
                       -DBUILD_EXAMPLES=1 \
                       -DBUILD_SHARED_LIBS=OFF"
