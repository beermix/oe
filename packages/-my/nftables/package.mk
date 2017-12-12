PKG_NAME="nftables"
PKG_VERSION="master"
PKG_GIT_URL="git://git.netfilter.org/nftables"
PKG_DEPENDS_TARGET="toolchain libnfnetlink libnl libmnl libmnl libnftnl jansson"

PKG_SECTION="my"

PKG_TOOLCHAIN="autotools"

pre_configure_target() {
   export LIBS="-lterminfo"
}

PKG_CONFIGURE_OPTS_TARGET="ac_cv_prog_CONFIG_PDF=no DBLATEX=no DOCBOOK2X_MAN=no DOCBOOK2MAN=no DB2X_DOCBOOK2MAN=no --sysconfdir=/storage/.config/nftables"

post_makeinstall_target() {
  rm -rf $INSTALL/storage
}
			   