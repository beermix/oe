# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2017-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="netbase"
PKG_VERSION="5.6"
PKG_SHA256="5d93a099deb28869b7306e914700fafbd293b55bdb5df05a5aa6effd0af5930c"
PKG_LICENSE="GPL"
PKG_SITE="https://anonscm.debian.org/cgit/users/md/netbase.git/"
PKG_URL="http://ftp.debian.org/debian/pool/main/n/netbase/netbase_$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="The netbase package provides data for network services and protocols from the iana db."
PKG_TOOLCHAIN="manual"

makeinstall_target() {
  mkdir -p $INSTALL/etc
    cp etc-protocols $INSTALL/etc/protocols
    cp etc-services $INSTALL/etc/services
}
