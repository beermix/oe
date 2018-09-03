# libcap,systemd,eudev depends on gperf and must be patched for gperf >= 3.1

PKG_NAME="gperf"
PKG_VERSION="3.1"
#PKG_VERSION="3.0.4"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="https://www.gnu.org/software/gperf/"
PKG_URL="https://ftp.gnu.org/pub/gnu/gperf/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_HOST="ccache:host"
PKG_PRIORITY="optional"
PKG_SECTION="devel"
PKG_SHORTDESC="gperf: a perfect hash function generator"
PKG_LONGDESC="GNU gperf is a perfect hash function generator. For a given list of strings, it produces a hash function and hash table, in form of C or C++ code, for looking up a value depending on the input string. The hash function is perfect, which means that the hash table has no collisions, and the hash table lookup needs a single string comparison only."



