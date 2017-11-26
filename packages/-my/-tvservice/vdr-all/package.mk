################################################################################
#      This file is part of Alex@ELEC - http://www.alexelec.in.ua
#      Copyright (C) 2011-2016 Alexandr Zuyev (alex@alexelec.in.ua)
################################################################################

PKG_NAME="vdr-all"
PKG_VERSION="2.2.0"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="http://www.alexelec.in.ua"
PKG_URL=""
PKG_DEPENDS_TARGET="toolchain vdr"
PKG_PRIORITY="optional"
PKG_SECTION="virtual"
PKG_SHORTDESC="vdr-all: Metapackage for installing VDR package"
PKG_LONGDESC="vdr-all is a Metapackage for installing VDR package"



PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET vdr-plugin-dvbapi"
PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET vdr-plugin-softhddevice"
PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET vdr-plugin-vnsiserver"
PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET vdr-plugin-xvdr"
PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET vdr-skin-nopacity"
PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET vdr-plugin-skindesigner"
PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET vdr-plugin-weatherforecast"
PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET vdr-plugin-tvguideng"
PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET vdr-plugin-epgsearch"
PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET vdr-plugin-live"
PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET vdr-plugin-streamdev"
PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET vdr-svdrpservice"
PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET vdr-epgsync"
PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET vdr-iptv"
PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET vdr-satip"
PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET vdr-plugin-femon"
PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET vdr-systeminfo"
PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET vdr-plugin-zaphistory"
PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET vdr-plugin-tvscraper"
PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET vdr-plugin-sleeptimer"
PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET vdr-plugin-channelscan"
PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET vdr-plugin-lcdproc"
PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET vdr-plugin-eepg"
PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET vdr-plugin-boblight"
