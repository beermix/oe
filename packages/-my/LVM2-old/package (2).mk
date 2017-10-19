################################################################################
#      This file is part of OpenELEC - http://www.openelec.tv
#      Copyright (C) 2009-2013 Stephan Raue (stephan@openelec.tv)
#
#  This Program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2, or (at your option)
#  any later version.
#
#  This Program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with OpenELEC.tv; see the file COPYING.  If not, write to
#  the Free Software Foundation, 51 Franklin Street, Suite 500, Boston, MA 02110, USA.
#  http://www.gnu.org/copyleft/gpl.html
################################################################################

PKG_NAME="LVM2"
PKG_VERSION="2.02.139"
PKG_SITE="http://sources.redhat.com/lvm2/"
PKG_URL="ftp://sources.redhat.com/pub/lvm2/${PKG_NAME}.${PKG_VERSION}.tgz"
PKG_SOURCE_DIR="${PKG_NAME}.${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain"

PKG_SECTION="system"
PKG_SHORTDESC="lvm2: Logical Volume Management (Version 2)"
PKG_LONGDESC="LVM includes all of the support for handling read/write operations on physical volumes (hard disks, RAID-Systems, magneto optical, etc., multiple devices (MD), see mdadd(8) or even loop devices, see losetup(8)), creating volume groups (kind of virtual disks) from one or more physical volumes and creating one or more logical volumes (kind of logical partitions) in volume groups. This 2nd version is based on device-mapper available in linux-2.6."


PKG_AUTORECONF="yes"

PKG_MAINTAINER="vpeter4 (peter.vicman@gmail.com)"

PKG_CONFIGURE_OPTS_TARGET="ac_cv_func_malloc_0_nonnull=yes \
            ac_cv_func_realloc_0_nonnull=yes \
            --disable-lvm1_fallback \
            --disable-static_link \
            --disable-readline \
            --enable-realtime \
            --enable-debug \
            --disable-profiling \
            --enable-devmapper \
            --disable-compat \
            --enable-o_direct \
            --enable-applib \
            --enable-cmdlib \
            --enable-pkgconfig \
            --enable-fsadm \
            --disable-dmeventd \
            --disable-selinux \
            --disable-nls"
