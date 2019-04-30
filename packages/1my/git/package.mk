################################################################################
#      This file is part of Alex@ELEC - http://www.alexelec.in.ua
#      Copyright (C) 2011-present Alexandr Zuyev (alex@alexelec.in.ua)
################################################################################

PKG_NAME="git"
PKG_VERSION="2.9.5"
PKG_LICENSE="GPL"
PKG_SITE="http://git-scm.com/"
PKG_URL="https://www.kernel.org/pub/software/scm/git/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain curl openssl"
PKG_SHORTDESC="git: the fast distributed version control system"
PKG_TOOLCHAIN="autotools"

pre_build_target() {
  mkdir -p $PKG_BUILD/.$TARGET_NAME
  cp -RP $PKG_BUILD/* $PKG_BUILD/.$TARGET_NAME

  export NO_EXPAT="YesPlease"
  export NO_ICONV="YesPlease"
  export NO_PYTHON="YesPlease"
  export NO_UNIX_SOCKETS="YesPlease"
  export NO_GETTEXT="YesPlease"
  export NO_MKSTEMPS="YesPlease"
  export NO_PERL="YesPlease"
  export NO_NSEC="YesPlease"
  export NO_TCLTK="YesPlease"
  export NO_INSTALL_HARDLINKS="yes"
}

configure_target() {
ac_cv_fread_reads_directories=no \
ac_cv_snprintf_returns_bogus=no \
  ./configure --host=$TARGET_NAME \
              --build=$HOST_NAME \
              --prefix=/usr \
			  --libexecdir=/usr/lib \
              --with-gitconfig=/etc/gitconfig
}

post_makeinstall_target() {
  rm -rf $INSTALL/usr/lib/x86_64-linux-gnu
  rm -rf $INSTALL/usr/share/perl
}
