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

PKG_NAME="iana-etc"
PKG_VERSION="2017"
PKG_ARCH="any"
PKG_LICENSE="none"
PKG_SITE="http://www.iana.org"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="network"
PKG_SHORTDESC="iana-etc: The Iana-Etc package provides data for network services and protocols."
PKG_LONGDESC="The Iana-Etc package provides data for network services and protocols."

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

unpack() {
  mkdir $PKG_BUILD
}

make_target() {
  wget -q https://www.iana.org/assignments/protocol-numbers/protocol-numbers.xml
  wget -q https://www.iana.org/assignments/service-names-port-numbers/service-names-port-numbers.xml
}

makeinstall_target() {
  mkdir -p $INSTALL/etc
  gawk '
BEGIN {
	print "# Full data: https://www.iana.org/assignments/protocol-numbers/protocol-numbers.xml\n"
	FS="[<>]"
}

{
	if (/<record/) { v=n=0 }
	if (/<value/) v=$3
	if (/<name/ && !($3~/ /)) n=$3
	if (/<\/record/ && (v || n=="HOPOPT") && n) printf "%-12s %3i %s\n", tolower(n),v,n
}
' protocol-numbers.xml > $INSTALL/etc/protocols
  gawk '
BEGIN {
        print "# Full data: https://www.iana.org/assignments/service-names-port-numbers/service-names-port-numbers.xml\n"
	FS="[<>]"
}

{
	if (/<record/) { n=u=p=c=0 }
	if (/<name/ && !/\(/) n=$3
	if (/<number/) u=$3
	if (/<protocol/) p=$3
	if (/Unassigned/ || /Reserved/ || /historic/) c=1
	if (/<\/record/ && n && u && p && !c) printf "%-15s %5i/%s\n", n,u,p
}' service-names-port-numbers.xml > $INSTALL/etc/services
}
