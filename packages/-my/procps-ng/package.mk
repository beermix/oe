################################################################################
#      This file is part of LibreELEC - https://libreelec.tv
#      Copyright (C) 2016 Team LibreELEC
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

PKG_NAME="procps-ng"
PKG_VERSION="3.3.12"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPL"
#PKG_GIT_URL="https://gitlab.com/procps-ng"
PKG_URL="$SOURCEFORGE_SRC/$PKG_NAME/Production/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain netbsd-curses"
PKG_SECTION="tools"
PKG_SHORTDESC="Command line and full screen utilities for browsing procfs"
PKG_LONGDESC="Command line and full screen utilities for browsing procfs, a "pseudo" file system dynamically generated by the kernel to provide information about the status of entries in its process table."
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_TARGET="ac_cv_func_malloc_0_nonnull=yes \
                           ac_cv_func_realloc_0_nonnull=yes \
                           --disable-shared \
                           --disable-modern-top \
                           --enable-static \
                           --disable-kill \
                           --with-systemd"