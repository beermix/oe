
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

PKG_NAME="readline"
PKG_VERSION="6c32f81"
#PKG_VERSION="7d5c553"
PKG_SITE="http://www.gnu.org/software/readline/"
PKG_GIT_URL="git://git.savannah.gnu.org/readline.git"
PKG_DEPENDS_TARGET="toolchain ncurses"
PKG_SECTION="devel"
PKG_SHORTDESC="readline: The GNU Readline library provides a set of functions for use by applications that allow users to edit command lines as they are typed in."
PKG_LONGDESC="The GNU Readline library provides a set of functions for use by applications that allow users to edit command lines as they are typed in."
PKG_IS_ADDON="no"

PKG_AUTORECONF="no"

pre_configure_target() {
  CFLAGS=`echo $CFLAGS | sed -e "s|-O.|-Os|"`
  CXXFLAGS=`echo $CXXFLAGS | sed -e "s|-O.|-Os|"`
}

PKG_CONFIGURE_OPTS_TARGET="bash_cv_wcwidth_broken=no \
                           --with-curses \
                           --without-purify"

post_makeinstall_target() {
  rm -rf $INSTALL/usr/share/readline
}
