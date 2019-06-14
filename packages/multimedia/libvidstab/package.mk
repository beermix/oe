PKG_NAME="libvidstab"
PKG_VERSION="git"
PKG_URL="https://johnvansickle.com/ffmpeg/release-source/libvidstab-git.tar.xz"
PKG_DEPENDS_TARGET="toolchain intel-vaapi-driver libva"
PKG_PRIORITY="optional"
PKG_SECTION="multimedia"
PKG_USE_CMAKE="yes"

PKG_USE_NINJA="no"

PKG_CMAKE_OPTS_TARGET="-DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=1"