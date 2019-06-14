PKG_NAME="openssh"
PKG_VERSION="7.6p1"
PKG_SHA256="a323caeeddfe145baaa0db16e98d784b1fbc7dd436a6bf1f479dfd5cd1d21723"
PKG_LICENSE="OSS"
PKG_SITE="http://www.openssh.com/"
PKG_URL="http://ftp.openbsd.org/pub/OpenBSD/OpenSSH/portable/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain zlib openssl"
PKG_SECTION="network"
PKG_SHORTDESC="openssh: An open re-implementation of the SSH package"
PKG_TOOLCHAIN="autotools"

PKG_CONFIGURE_OPTS_TARGET="--sysconfdir=/etc/ssh \
                           --libexecdir=/usr/lib/openssh \
                           --disable-strip \
                           --disable-lastlog \
                           --with-sandbox=no \
                           --disable-utmp \
                           --disable-utmpx \
                           --disable-wtmp \
                           --disable-wtmpx \
                           --without-rpath \
                           --with-ssl-engine \
                           --with-privsep-user=nobody \
                           --disable-pututline \
                           --disable-pututxline \
                           --disable-etc-default-login \
                           --with-keydir=/storage/.cache/ssh \
                           --without-pam"

pre_configure_target() {
  export LD="$CC"
  export LDFLAGS="$TARGET_CFLAGS $TARGET_LDFLAGS"
}

post_makeinstall_target() {
  rm -rf $INSTALL/usr/lib/openssh/ssh-keysign
  rm -rf $INSTALL/usr/lib/openssh/ssh-pkcs11-helper
  if [ ! $SFTP_SERVER = "yes" ]; then
    rm -rf $INSTALL/usr/lib/openssh/sftp-server
  fi
  rm -rf $INSTALL/usr/bin/ssh-add
  rm -rf $INSTALL/usr/bin/ssh-agent
  rm -rf $INSTALL/usr/bin/ssh-keyscan

  sed -e "s|^#PermitRootLogin.*|PermitRootLogin yes|g" \
      -e "s|^#StrictModes.*|StrictModes no|g" \
      -e "s|^#X11Forwarding.*|X11Forwarding yes|g" \
      -i $INSTALL/etc/ssh/sshd_config

  echo "PubkeyAcceptedKeyTypes +ssh-dss" >> $INSTALL/etc/ssh/sshd_config

  debug_strip $INSTALL/usr
}

post_install() {
  enable_service sshd.service
}
