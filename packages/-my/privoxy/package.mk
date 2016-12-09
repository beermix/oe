PKG_NAME="privoxy"
PKG_VERSION="3.0.26-stable"
PKG_URL="http://www.silvester.org.uk/privoxy/source/3.0.26%20%28stable%29/privoxy-3.0.26-stable-src.tar.gz"
PKG_DEPENDS_TARGET="toolchain pcre"

PKG_SECTION="security"
PKG_SHORTDESC="Privoxy"
PKG_LONGDESC=""
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

pre_configure_target() {
  export LDFLAGS="-Wl,-static -static -static-libgcc -s"
  export MAKEFLAGS=-j1
  cd $ROOT/$PKG_BUILD
  autoreconf --verbose --install --force -I m4
}

PKG_CONFIGURE_TARGET="--enable-compression \
		      --disable-ipv6-support \
		      --disable-dynamic-pcre \
		      --enable-accept-filter \
		      --enable-external-filters \
		      --enable-extended-host-patterns \
		      --enable-graceful-termination \
		      --enable-large-file-support \
		      --disable-silent-rules \
		      --sysconfdir=/storage/.config \
		      --datadir=/storage/.config \
		      --libdir=/storage/.config \
		      --libexecdir=/storage/.config \
		      --sharedstatedir=/storage/.config \
		      --includedir=/storage/.config \
		      --datarootdir=/storage/.config \
		      --infodir=/storage/.config \
		      --localedir=/storage/.config"


makeinstall_target() {
  cd $ROOT/$PKG_BUILD
  mkdir -p $INSTALL/usr
  mkdir -p $INSTALL/usr/bin
  mkdir -p $INSTALL/etc
  mkdir -p $INSTALL/etc/privoxy
  mkdir -p $INSTALL/etc/privoxy/templates
  cp privoxy $INSTALL/usr/bin/
  $STRIP $INSTALL/usr/bin/privoxy
  sed -e "s/listen-address\ \ 127.0.0.1:8118/listen-address  0.0.0.0:8118/g" -e "s/confdir\ \./confdir\ \/etc\/privoxy/g" -e "s/logdir\ \./logdir\ \/var\/log\/privoxy/g" config > $INSTALL/etc/privoxy/config
  echo "forward-socks5	/	127.0.0.1:1080 ." >> $INSTALL/etc/privoxy/config
  echo "forward	.i2p	127.0.0.1:4444" >> $INSTALL/etc/privoxy/config
  echo "forward         192.168.*.*/     ." >> $INSTALL/etc/privoxy/config
  echo "forward            10.*.*.*/     ." >> $INSTALL/etc/privoxy/config
  echo "forward           127.*.*.*/     ." >> $INSTALL/etc/privoxy/config
  cp default.action $INSTALL/etc/privoxy
  cp default.filter $INSTALL/etc/privoxy
  cp match-all.action $INSTALL/etc/privoxy
  cp trust $INSTALL/etc/privoxy
  cp user.action $INSTALL/etc/privoxy
  cp user.filter $INSTALL/etc/privoxy
  cp templates/* $INSTALL/etc/privoxy/templates
  cd -
}


