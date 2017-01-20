PKG_NAME="ncurses"
PKG_VERSION="6.0"
PKG_SITE="http://www.gnu.org/software/ncurses/"
PKG_URL="http://ftp.gnu.org/pub/gnu/ncurses/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain zlib termcap"
#PKG_DEPENDS_HOST="toolchain zlib termcap"

PKG_SECTION="devel"
PKG_SHORTDESC="ncurses: The ncurses (new curses) library"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

PKG_CONFIGURE_OPTS_TARGET="--enable-echo \
			  --enable-const \
			  --enable-overwrite \
			  --enable-pc-files \
			  --disable-rpath \
			  --without-ada \
			  --without-debug \
			  --without-manpages \
			  --without-profile \
			  --without-progs \
			  --without-tests \
			  --disable-big-core \
			  --disable-home-terminfo \
			  --with-normal \
			  --without-shared \
			  --with-terminfo-dirs=/usr/share/terminfo \
			  --with-default-terminfo-dir=/usr/share/terminfo \
			  --with-fallbacks=linux,screen,xterm,xterm-256color \
			  --enable-widec"
	

pre_configure_target() {
  strip_lto
  #strip_gold
  cd $ROOT/$PKG_BUILD
  #cp include/termcap_internal.h.in include/termcap_internal.h termcap
  #ln -s include/termcap.h.in termcap_internal.h
  cp /root/oe/ncurses-fallback.c ncurses/fallback.c
 # t=ncurses/tinfo
#for culprit in progs/tset.c $t/lib_baudrate.c $t/lib_cur_term.c $t/lib_termcap.c $t/lib_tgoto.c $t/lib_tputs.c ; do
#	sed -i 's@termcap\.h@termcap_internal.h@' $culprit
#done
 
}

pre_configure_target() {
  # causes some segmentation fault's (dialog) when compiled with gcc's link time optimization.
  strip_lto
}

post_makeinstall_target() {
  cp misc/ncurses-config $ROOT/$TOOLCHAIN/bin
    chmod +x $ROOT/$TOOLCHAIN/bin/ncurses-config
    $SED "s:\(['=\" ]\)/usr:\\1$SYSROOT_PREFIX/usr:g" $ROOT/$TOOLCHAIN/bin/ncurses-config
}