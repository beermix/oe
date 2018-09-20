PKG_NAME="nasm"
PKG_VERSION="2.13.03"
PKG_SHA256="812ecfb0dcbc5bd409aaa8f61c7de94c5b8752a7b00c632883d15b2ed6452573"
PKG_ARCH="any"
PKG_LICENSE="BSD"
PKG_SITE="http://www.tortall.net/projects/yasm/"
PKG_URL="http://www.nasm.us/pub/nasm/releasebuilds/$PKG_VERSION/nasm-$PKG_VERSION.tar.xz"
PKG_DEPENDS_HOST="ccache:host"
PKG_SECTION="toolchain/lang"
PKG_SHORTDESC="yasm: A complete rewrite of the NASM assembler"
PKG_LONGDESC="Yasm is a complete rewrite of the NASM assembler under the new BSD License (some portions are under other licenses, see COPYING for details). It is designed from the ground up to allow for multiple assembler syntaxes to be supported (eg, NASM, TASM, GAS, etc.) in addition to multiple output object formats and even multiple instruction sets. Another primary module of the overall design is an optimizer module."
#PKG_TOOLCHAIN="autotools"

#PKG_CONFIGURE_OPTS_HOST="--enable-lto --disable-gdb"