# Made by github.com/escalade
PKG_NAME="nfs-utils"
PKG_VERSION="2.3.1"
PKG_ARCH="any"
PKG_LICENSE="GPLv2"
PKG_SITE="https://sourceforge.net/projects/nfs"
PKG_URL="http://downloads.sf.net/sourceforge/nfs/$PKG_NAME-$PKG_VERSION.tar.bz2"
PKG_DEPENDS_TARGET="toolchain libnfsidmap libtirpc libevent"
PKG_SECTION="escalade"
PKG_SHORTDESC="Support programs for Network File Systems"

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

PKG_CONFIGURE_OPTS_TARGET="--without-tcp-wrappers \
			   --disable-nfsv41 \
			   --disable-gss \
			   --with-systemd"

pre_configure_target() {
  cd ..
  rm -rf .$TARGET_NAME
}

post_makeinstall_target() {
  mkdir -p $INSTALL/etc
  mkdir -p $INSTALL/usr/config
  ln -sf /storage/.config/nfs.conf $INSTALL/etc/
  ln -sf /storage/.config/nfsmount.conf $INSTALL/etc/
  ln -sf /storage/.config/exports $INSTALL/etc/
  ln -sf /storage/.config/idmapd.conf $INSTALL/etc/
  cp nfs.conf $INSTALL/usr/config/
  cp utils/mount/nfsmount.conf $INSTALL/usr/config/
  cp $PKG_DIR/config/* $INSTALL/usr/config/
}
