################################################################################
#      This file is part of OpenELEC - http://www.openelec.tv
#      Copyright (C) 2009-2014 Stephan Raue (stephan@openelec.tv)
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

PKG_NAME="smbclient"
PKG_VERSION="1.0"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="http://www.samba.org"
PKG_URL=""
PKG_DEPENDS_TARGET="toolchain samba"
PKG_PRIORITY="optional"
PKG_SECTION="network"
PKG_SHORTDESC="samba: The free SMB / CIFS fileserver and client"
PKG_LONGDESC="Samba is a SMB server that runs on Unix and other operating systems. It allows these operating systems (currently Unix, Netware, OS/2 and AmigaDOS) to act as a file and print server for SMB and CIFS clients. There are many Lan-Manager compatible clients such as LanManager for DOS, Windows for Workgroups, Windows NT, Windows 95, Linux smbfs, OS/2, Pathworks and more."



configure_target() {
	: # nothing
}

make_target() {
	SAMBA_DIR=$(get_build_dir samba)/.$TARGET_NAME
  make -C $SAMBA_DIR bin/smbclient
}

makeinstall_target() {
  $STRIP $SAMBA_DIR/bin/smbclient
}
