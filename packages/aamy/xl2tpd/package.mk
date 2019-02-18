PKG_NAME="xl2tpd"
PKG_VERSION="f9c37f4"
PKG_GIT_URL="https://github.com/xelerance/xl2tpd"
PKG_DEPENDS_TARGET="toolchain systemd pptp ppp openssl libpcap"
PKG_SECTION="network"



make_target() {
  make prefix=/usr \
  	CC="$CC" \
       LD="$LD" \
       AR="$AR" \
       XCFLAGS="$CFLAGS" \
       XLDFLAGS="$LDFLAGS" \
       KERNELSRC="$(get_pkg_build linux)" -j1
}

#PKG_MAKE_OPTS_TARGET="KERNELSRC=$kernel_path"