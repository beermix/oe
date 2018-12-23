# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)

PKG_NAME="sed"
PKG_VERSION="4.7"
PKG_SHA256="2885768cd0a29ff8d58a6280a270ff161f6a3deb5690b2be6c49f46d4c67bd6a"
PKG_LICENSE="GPL"
PKG_SITE="http://www.gnu.org/software/sed/"
PKG_URL="http://ftp.gnu.org/gnu/sed/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_HOST="ccache:host"
PKG_SECTION="sysutils"
PKG_SHORTDESC="sed: This is the GNU implementation of the POSIX stream editor"
PKG_LONGDESC="The sed (Stream EDitor) editor is a stream or batch (non-interactive) editor. Sed takes text as input, performs an operation or set of operations on the text and outputs the modified text. The operations that sed performs (substitutions, deletions, insertions, etc.) can be specified in a script file or from the command line."

PKG_CONFIGURE_OPTS_HOST="ac_cv_search_setfilecon=no \
			    ac_cv_header_selinux_context_h=no \
			    ac_cv_header_selinux_selinux_h=no \
			    --disable-acl \
			    --disable-nls"

PKG_CONFIGURE_OPTS_TARGET="-C $PKG_CONFIGURE_OPTS_HOST"
