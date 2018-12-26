# libcap,systemd,eudev depends on gperf and must be patched for gperf >= 3.1

PKG_NAME="gperf"
PKG_VERSION="3.1"
#PKG_VERSION="3.0.4"
PKG_REV="1"
PKG_LICENSE="GPL"
PKG_SITE="https://www.gnu.org/software/gperf/"
PKG_URL="https://ftp.gnu.org/pub/gnu/gperf/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_HOST="ccache:host"