# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)

PKG_NAME="readline"
PKG_VERSION="8.0"
PKG_SITE="http://www.gnu.org/software/readline/"
PKG_URL="http://git.savannah.gnu.org/cgit/readline.git/snapshot/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_URL="https://fossies.org/linux/misc/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain ncurses"

PKG_CONFIGURE_OPTS_TARGET="bash_cv_wcwidth_broken=no --with-curses"

PKG_CONFIGURE_OPTS_HOST="$PKG_CONFIGURE_OPTS_TARGET"

post_makeinstall_target() {
  rm -rf $INSTALL/usr/share/readline
}
