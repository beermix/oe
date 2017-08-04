PKG_NAME="mrxvt"
PKG_VERSION="0.5.4"
PKG_ARCH="i386 x86_64"
PKG_SITE="http://materm.sourceforge.net/"
PKG_URL="https://dl.dropboxusercontent.com/s/2k2ffh22yi1rmkp/mrxvt-0.5.4.tar.gz"
PKG_DEPENDS_TARGET="toolchain libX11 libXpm libXrender libXau fontconfig freetype libICE"
PKG_SECTION="tools"
PKG_SHORTDESC="mrxvt: Lightweight Xterm replacement"
PKG_LONGDESC="Mrxvt (previously named as materm) is a lightweight and powerful multi-tabbed X terminal emulator based on the popular rxvt and aterm. It implements many useful features seen in some modern X terminal emulators, like gnome-terminal and konsole, but keep to be lightweight and independent from the GNOME and KDE desktop environment."
PKG_AUTORECONF="yes"


PKG_CONFIGURE_OPTS_TARGET="ac_cv_func_setpgrp_void=no \
			      --disable-minimal \
			      --disable-frills \
			      --enable-keepscrolling \
			      --disable-selectionscrolling \
			      --enable-mousewheel \
			      --disable-mouseslipwheel \
			      --enable-rxvt-scroll \
			      --enable-half-shadow \
			      --enable-lastlog \
			      --enable-sessionmgr \
			      --enable-linespace \
			      --enable-24bits \
			      --enable-256colors \
			      --enable-cursor-blink \
			      --enable-pointer-blank \
			      --enable-text-shadow \
			      --enable-menubar \
			      --disable-transparency \
			      --disable-tinting \
			      --enable-xrender \
			      --enable-xpm \
			      --enable-jpeg \
			      --enable-png \
			      --disable-xft \
			      --enable-ttygid \
			      --enable-backspace-key \
			      --enable-delete-key \
			      --disable-resources \
			      --disable-swapscreen \
			      --disable-use-fifo \
			      --disable-greek \
			      --disable-xim \
			      --disable-utempter\
			      --with-term=xterm"
