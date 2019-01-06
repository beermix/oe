# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2017-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="samba"
PKG_VERSION="3.6.25"
PKG_LICENSE="GPL"
PKG_SITE="https://www.samba.org"
PKG_URL="https://samba.org/samba/ftp/stable/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain zlib connman"
PKG_LONGDESC="A free SMB / CIFS fileserver and client."
PKG_BUILD_FLAGS="+pic -hardening"

configure_package() {
 if [ "$AVAHI_DAEMON" = yes ]; then
   PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET avahi"
   SMB_AVAHI="--enable-avahi"
 else
   SMB_AVAHI="--disable-avahi"
 fi

 PKG_CONFIGURE_SCRIPT="${PKG_BUILD}/source3/configure"

 PKG_CONFIGURE_OPTS_TARGET="ac_cv_file__proc_sys_kernel_core_pattern=yes \
                           libreplace_cv_HAVE_C99_VSNPRINTF=yes \
                           libreplace_cv_HAVE_GETADDRINFO=no \
                           libreplace_cv_HAVE_IFACE_IFCONF=no \
                           LINUX_LFS_SUPPORT=yes \
                           samba_cv_CC_NEGATIVE_ENUM_VALUES=yes \
                           samba_cv_HAVE_GETTIMEOFDAY_TZ=yes \
                           samba_cv_HAVE_IFACE_IFCONF=yes \
                           samba_cv_HAVE_KERNEL_OPLOCKS_LINUX=yes \
                           samba_cv_HAVE_SECURE_MKSTEMP=yes \
                           samba_cv_HAVE_WRFILE_KEYTAB=no \
                           samba_cv_USE_SETREUID=yes \
                           samba_cv_USE_SETRESUID=yes \
                           samba_cv_have_setreuid=yes \
                           samba_cv_have_setresuid=yes \
                           ac_cv_lib_attr_getxattr=no \
                           ac_cv_search_getxattr=no \
                           ac_cv_header_libunwind_h=no \
                           ac_cv_header_zlib_h=no \
                           samba_cv_zlib_1_2_3=no \
                           --with-configdir=/etc/samba \
                           --with-privatedir=/var/run \
                           --with-codepagedir=/etc/samba \
                           --with-lockdir=/var/lock \
                           --with-logfilebase=/var/log \
                           --with-nmbdsocketdir=/var/nmbd \
                           --with-piddir=/var/run \
                           --disable-shared-libs \
                           --disable-debug \
                           --with-libiconv="$SYSROOT_PREFIX/usr" \
                           --disable-krb5developer \
                           --disable-picky-developer \
                           --enable-largefile \
                           --disable-socket-wrapper \
                           --disable-nss-wrapper \
                           --disable-swat \
                           --disable-cups \
                           --disable-iprint \
                           --disable-pie \
                           --disable-relro \
                           --disable-fam \
                           --disable-dnssd \
                           $SMB_AVAHI \
                           --disable-pthreadpool \
                           --disable-dmalloc \
                           --with-fhs \
                           --without-libtalloc \
                           --disable-external-libtalloc \
                           --without-libtdb \
                           --disable-external-libtdb \
                           --without-libnetapi \
                           --with-libsmbclient \
                           --without-libsmbsharemodes \
                           --without-libaddns \
                           --without-afs \
                           --without-fake-kaserver \
                           --without-vfs-afsacl \
                           --without-ldap \
                           --without-ads \
                           --without-dnsupdate \
                           --without-automount \
                           --without-krb5 \
                           --without-pam \
                           --without-pam_smbpass \
                           --without-nisplus-home \
                           --with-syslog \
                           --without-quotas \
                           --without-sys-quotas \
                           --without-utmp \
                           --without-cluster-support \
                           --without-acl-support \
                           --without-aio-support \
                           --with-sendfile-support \
                           --without-libtevent \
                           --without-wbclient \
                           --without-winbind \
                           --with-included-popt \
                           --with-included-iniparser"
}

pre_configure_target() {
  ( cd ../source3
    sh autogen.sh
  )
  export CFLAGS="$CFLAGS -D__location__=\\\"\\\" -ffunction-sections -fdata-sections"
  export LDFLAGS="$LDFLAGS -fwhole-program -Wl,--gc-sections"
  
  export CFLAGS=`echo $CFLAGS | sed -e "s|-O.|-Os|"`
  export CXXFLAGS=`echo $CXXFLAGS | sed -e "s|-O.|-Os|"`
}

make_target() {
  make bin/libtalloc.a
  make bin/libwbclient.a
  make bin/libtdb.a
  make bin/libtevent.a
  make bin/libsmbclient.a

  if [ "$SAMBA_SERVER" = "yes" ]; then
    make bin/samba_multicall
  fi
}

post_make_target() {
  mkdir -p $SYSROOT_PREFIX/usr/lib
    cp -P bin/*.a $SYSROOT_PREFIX/usr/lib

  mkdir -p $SYSROOT_PREFIX/usr/include
    cp ../source3/include/libsmbclient.h $SYSROOT_PREFIX/usr/include

  mkdir -p $SYSROOT_PREFIX/usr/lib/pkgconfig
    # talloc/tdb/tevent/wbclient static
    sed -e "s,^Libs: -lsmbclient$,Libs: -lsmbclient -ltalloc -ltdb -ltevent -lwbclient,g" -i pkgconfig/smbclient.pc
    cp pkgconfig/smbclient.pc $SYSROOT_PREFIX/usr/lib/pkgconfig
}

makeinstall_target() {
  if [ "$SAMBA_SERVER" = "yes" ]; then
    mkdir -p $INSTALL/usr/bin
      cp bin/samba_multicall $INSTALL/usr/bin
      ln -sf samba_multicall $INSTALL/usr/bin/smbd
      ln -sf samba_multicall $INSTALL/usr/bin/nmbd
      ln -sf samba_multicall $INSTALL/usr/bin/smbpasswd

    mkdir -p $INSTALL/etc/samba
      cp ../codepages/lowcase.dat $INSTALL/etc/samba
      cp ../codepages/upcase.dat $INSTALL/etc/samba
      cp ../codepages/valid.dat $INSTALL/etc/samba

    mkdir -p $INSTALL/usr/lib/systemd/system
      cp $PKG_DIR/system.d.opt/* $INSTALL/usr/lib/systemd/system

    mkdir -p $INSTALL/usr/share/services
      cp -P $PKG_DIR/default.d/*.conf $INSTALL/usr/share/services

    mkdir -p $INSTALL/usr/lib/samba
      cp $PKG_DIR/scripts/samba-config $INSTALL/usr/lib/samba
      cp $PKG_DIR/scripts/samba-autoshare $INSTALL/usr/lib/samba

    if [ -f $PROJECT_DIR/$PROJECT/config/smb.conf ]; then
      mkdir -p $INSTALL/etc/samba
        cp $PROJECT_DIR/$PROJECT/config/smb.conf $INSTALL/etc/samba
    elif [ -f $DISTRO_DIR/$DISTRO/config/smb.conf ]; then
      mkdir -p $INSTALL/etc/samba
        cp $DISTRO_DIR/$DISTRO/config/smb.conf $INSTALL/etc/samba
    else
      mkdir -p $INSTALL/etc/samba
        cp $PKG_DIR/config/smb.conf $INSTALL/etc/samba
      mkdir -p $INSTALL/usr/config
        cp $PKG_DIR/config/smb.conf $INSTALL/usr/config/samba.conf.sample
    fi

  fi
}

post_install() {
  if [ "$SAMBA_SERVER" = "yes" ]; then
    enable_service nmbd.service
    enable_service smbd.service
  fi
}
