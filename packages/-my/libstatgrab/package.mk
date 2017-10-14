PKG_NAME="libstatgrab"
PKG_VERSION="897fedb"
#PKG_GIT_URL="https://github.com/tdb/libstatgrab"
PKG_URL="https://github.com/tdb/libstatgrab/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_SHORTDESC="provides cross platform access to statistics about the system on which it's run"
PKG_LONGDESC="libstatgrab is a library that provides cross platform access to statistics about the system on which it's run. It's written in C and presents a selection of useful interfaces which can be used to access key system statistics. The current list of statistics includes CPU usage, memory utilisation, disk usage, process counts, network traffic, disk I/O, and more."
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_TARGET="ac_cv_func_malloc_0_nonnull=yes \
                           --enable-static \
                           --disable-shared \
                           --disable-saidar \
                           --disable-examples \
                           --disable-manpages \
                           --disable-setuid-binaries \
                           --disable-man-build \
                           --disable-tests \
                           --with-pic \
                           --with-gnu-ld"
