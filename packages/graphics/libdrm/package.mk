
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

PKG_NAME="libdrm"
PKG_VERSION="2.4.91"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="http://dri.freedesktop.org"
PKG_URL="http://dri.freedesktop.org/libdrm/$PKG_NAME-$PKG_VERSION.tar.bz2"
PKG_DEPENDS_TARGET="toolchain libpciaccess"
PKG_SECTION="graphics"
PKG_SHORTDESC="libdrm: Userspace interface to kernel DRM services"
PKG_LONGDESC="The userspace interface library to kernel DRM services."

get_graphicdrivers

PKG_MESON_OPTS_TARGET="-Dlibkms=false \
			  -Dintel=true \
			  -Dradeon=false \
			  -Damdgpu=false \
			  -Dnouveau=false \
			  -Dvmwgfx=true \
			  -Domap=false \
			  -Dexynos=false \
			  -Dfreedreno=false \
			  -Dtegra=false \
			  -Dvc4=false \
			  -Detnaviv=false \
			  -Dcairo-tests=false \
			  -Dman-pages=false \
			  -Dvalgrind=false \
			  -Dfreedreno-kgsl=false \
			  -Dinstall-test-programs=false \
			  -Dudev=false"

pre_configure_target() {
  export LC_ALL=en_US.UTF-8
}
