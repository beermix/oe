PKG_NAME="xl2tpd"
PKG_VERSION="cec1ebe"
PKG_GIT_URL="https://github.com/xelerance/xl2tpd"
PKG_DEPENDS_TARGET="toolchain systemd pptp ppp openssl libpcap"

PKG_SECTION="network"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

make_target() {
make prefix=/usr \
       CC="$CC" \
       LD="$LD" \
       AR="$AR" \
       XCFLAGS="$CFLAGS" \
       XLDFLAGS="$LDFLAGS" \
       KERNELSRC="$(get_pkg_build linux)"
}

#PKG_MAKE_OPTS_TARGET="KERNELSRC=$kernel_path"