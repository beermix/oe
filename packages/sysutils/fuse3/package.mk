PKG_NAME="fuse3"
PKG_VERSION="3.1.1"
PKG_SITE="https://github.com/libfuse/libfuse/"
PKG_URL="https://dl.dropboxusercontent.com/s/e874n5xcuqfwt2u/fuse3-3.1.1.tar.xz"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="system"
PKG_SHORTDESC="fuse: A simple user-space filesystem interface for Linux"
PKG_LONGDESC="FUSE provides a simple interface for userspace programs to export a virtual filesystem to the Linux kernel. FUSE also aims to provide a secure method for non privileged users to create and mount their own filesystem implementations."




PKG_CONFIGURE_OPTS_TARGET="--enable-lib \
                           --enable-util \
                           --disable-example \
                           --enable-mtab \
                           --disable-rpath \
                           --with-gnu-ld"

post_makeinstall_target() {
  rm -rf $INSTALL/etc/init.d
  rm -rf $INSTALL/etc/udev
}
