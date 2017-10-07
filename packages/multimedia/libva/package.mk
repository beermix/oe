PKG_NAME="libva"
PKG_VERSION="2.0.0.pre2"
PKG_REV="1"
PKG_ARCH="x86_64"
PKG_LICENSE="GPL"
PKG_URL="https://github.com/01org/libva/releases/download/$PKG_VERSION/$PKG_NAME-$PKG_VERSION.tar.bz2"
PKG_DEPENDS_TARGET="toolchain libX11 libXext libXfixes libdrm mesa glu"
PKG_PRIORITY="optional"
PKG_SECTION="multimedia"
PKG_SHORTDESC="libva: The main motivation for VAAPI (Video Acceleration API) is to enable hardware accelerated video decode/encode at various entry-points (VLD, IDCT, Motion Compensation etc.) for the prevailing coding standards today (MPEG-2, MPEG-4 ASP/H.263, MPEG-4 AVC/H.264, and VC-1/VMW3)."
PKG_LONGDESC="The main motivation for VAAPI (Video Acceleration API) is to enable hardware accelerated video decode/encode at various entry-points (VLD, IDCT, Motion Compensation etc.) for the prevailing coding standards today (MPEG-2, MPEG-4 ASP/H.263, MPEG-4 AVC/H.264, and VC-1/VMW3). Extending XvMC was considered, but due to its original design for MPEG-2 MotionComp only, it made more sense to design an interface from scratch that can fully expose the video decode capabilities in today's GPUs."

PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_TARGET="--enable-silent-rules \
                           --disable-docs \
                           --enable-drm \
                           --enable-x11 \
                           --enable-glx \
                           --enable-egl \
                           --disable-wayland \
                           --with-drivers-path=/usr/lib/va"
