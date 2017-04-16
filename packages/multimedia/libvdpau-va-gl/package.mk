################################################################################
#      This file is part of OpenELEC - http://www.openelec.tv
#      Copyright (C) 2009-2017 Stephan Raue (stephan@openelec.tv)
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

PKG_NAME="libvdpau-va-gl"
PKG_VERSION="ade4c75"
PKG_REV="1"
PKG_ARCH="x86_64"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/01org/libva"
PKG_GIT_URL="https://github.com/i-rinat/libvdpau-va-gl"
PKG_DEPENDS_TARGET="toolchain intel-vaapi-driver libva"
PKG_PRIORITY="optional"
PKG_SECTION="multimedia"
PKG_SHORTDESC="libva: The main motivation for VAAPI (Video Acceleration API) is to enable hardware accelerated video decode/encode at various entry-points (VLD, IDCT, Motion Compensation etc.) for the prevailing coding standards today (MPEG-2, MPEG-4 ASP/H.263, MPEG-4 AVC/H.264, and VC-1/VMW3)."
PKG_LONGDESC="The main motivation for VAAPI (Video Acceleration API) is to enable hardware accelerated video decode/encode at various entry-points (VLD, IDCT, Motion Compensation etc.) for the prevailing coding standards today (MPEG-2, MPEG-4 ASP/H.263, MPEG-4 AVC/H.264, and VC-1/VMW3). Extending XvMC was considered, but due to its original design for MPEG-2 MotionComp only, it made more sense to design an interface from scratch that can fully expose the video decode capabilities in today's GPUs."

PKG_IS_ADDON="no"
PKG_USE_CMAKE="yes"
PKG_AUTORECONF="no"
