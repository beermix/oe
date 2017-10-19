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

PKG_NAME="libXdamage"
PKG_VERSION="1.1.4"
PKG_SHA256="7c3fe7c657e83547f4822bfde30a90d84524efb56365448768409b77f05355ad"
PKG_ARCH="any"
PKG_LICENSE="OSS"
PKG_SITE="http://www.X.org"
PKG_URL="http://xorg.freedesktop.org/archive/individual/lib/$PKG_NAME-$PKG_VERSION.tar.bz2"
PKG_DEPENDS_TARGET="toolchain util-macros damageproto fixesproto libX11 libXfixes"
PKG_SECTION="x11/lib"
PKG_SHORTDESC="libXdamage: X11 damaged region extension library"
PKG_LONGDESC="LibXdamage provides an X Window System client interface to the DAMAGE extension to the X protocol. The Damage extension provides for notification of when on-screen regions have been 'damaged' (altered)."


PKG_AUTORECONF="no"


