PKG_NAME="bwm-ng"
PKG_VERSION="0.6.1"
PKG_SITE="http://www.gropp.org/?id=projects&sub=bwm-ng"
PKG_URL="http://www.gropp.org/bwm-ng/bwm-ng-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain libstatgrab"

PKG_SECTION="network/analyzer"




configure_target() {
cd $PKG_BUILD
LIBS="-lcurses -lterminfo" ./configure --with-libstatgrab --with-time --enable-64bit --with-ncurses --with-sysctl --with-procnetdev --with-strip --with-procnetdev --enable-html --enable-extendedstats --with-getopt_long
make LDFLAGS="-lcurses -lterminfo" install
}




addon() {
  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/bin
  cp $PKG_BUILD/.$TARGET_NAME/src/bwm-ng $ADDON_BUILD/$PKG_ADDON_ID/bin
}
