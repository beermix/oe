PKG_NAME="xterm"
PKG_VERSION="325"
PKG_URL="ftp://invisible-island.net/xterm/xterm-$PKG_VERSION.tgz"
PKG_DEPENDS_TARGET="toolchain libXft libXaw libXext libpng"
PKG_PRIORITY="optional"
PKG_SECTION="tools"
PKG_AUTORECONF="no"

configure_target() {
cd $ROOT/$PKG_BUILD
CFLAGS="-include termcap.h -DUSE_TERMCAP -DOK=0 -g -D__GNU__ -D__GLIBC__=2 -D__GLIBC_MINOR__=10 -D_POSIX_SOURCE -D_GNU_SOURCE $optcflags" \
LDFLAGS="$optldflags -Wl,-rpath-link=$butch_root_dir$butch_prefix/lib" \
  ./configure -C \
  --prefix="$butch_prefix" \
  --enable-256-color \
  --enable-wide-chars \
  --disable-tek4014 \
  --disable-active-icon \
  --disable-builtin-xpms \
  --without-xpm \
  ac_cv_header_lastlog_h=no cf_cv_path_lastlog=no \
  ac_cv_header_termcap_h=yes $xconfflags

 
}