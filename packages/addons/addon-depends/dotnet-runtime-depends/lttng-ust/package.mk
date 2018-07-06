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

PKG_NAME="lttng-ust"
PKG_VERSION="2.10.1"
PKG_SHA256="8503bb36c95fc3473eb6323b84645e9d95ff52758ad199d2fe7ca80277f81b95"
PKG_ARCH="any"
PKG_LICENSE="LGPLv2.1"
PKG_SITE="https://lttng.org/"
PKG_URL="https://github.com/lttng/lttng-ust/archive/v$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain userspace-rcu"
PKG_LONGDESC="LTTng is an open source tracing framework for Linux"
PKG_TOOLCHAIN="autotools"

PKG_CONFIGURE_OPTS_TARGET="--disable-man-pages"
