PKG_NAME="privoxy"
PKG_VERSION="3.0.26-stable"
PKG_URL="http://www.silvester.org.uk/privoxy/source/3.0.26%20%28stable%29/privoxy-3.0.26-stable-src.tar.gz"
PKG_DEPENDS_TARGET="toolchain openssl zlib pcre"
PKG_SECTION="security"
PKG_SHORTDESC="Privoxy"
PKG_TOOLCHAIN="autotools"

pre_configure_target() {
  cd $PKG_BUILD
  rm -rf .$TARGET_NAME
  export LDFLAGS="-static"
}

PKG_CONFIGURE_OPTS_TARGET="--disable-ipv6-support \
			      --enable-no-gifs \
			      --enable-large-file-support \
			      --enable-graceful-termination \
			      --enable-external-filters \
			      --enable-accept-filter \
			      --enable-compression \
			      --sysconfdir=/storage/.config \
			      --datadir=/storage/.config \
			      --libdir=/storage/.config \
			      --libexecdir=/storage/.config \
			      --sharedstatedir=/storage/.config \
			      --localstatedir=/storage/.config \
			      --includedir=/storage/.config \
			      --oldincludedir=/storage/.config \
			      --datarootdir=/storage/.config \
			      --infodir=/storage/.config \     
			      --localedir=/storage/.config/privoxy/locale"

makeinstall_target() {
  cd $PKG_BUILD
  mkdir -p $INSTALL/usr
  mkdir -p $INSTALL/usr/bin
  mkdir -p $INSTALL/storage/.config
  mkdir -p $INSTALL/storage/.config/privoxy
  mkdir -p $INSTALL/storage/.config/privoxy/templates
  cp privoxy $INSTALL/usr/bin/
  $STRIP $INSTALL/usr/bin/privoxy
  sed -e "s/listen-address\ \ 127.0.0.1:8118/listen-address  0.0.0.0:8118/g" -e "s/confdir\ \./confdir\ \/storage/.config\/privoxy/g" -e "s/logdir\ \./logdir\ \/var\/log\/privoxy/g" config > $INSTALL/storage/.config/privoxy/config
  echo "forward-socks5	/	127.0.0.1:1080 ." >> $INSTALL/storage/.config/privoxy/config
  echo "forward	.i2p	127.0.0.1:4444" >> $INSTALL/storage/.config/privoxy/config
  echo "forward         192.168.*.*/     ." >> $INSTALL/storage/.config/privoxy/config
  echo "forward            10.*.*.*/     ." >> $INSTALL/storage/.config/privoxy/config
  echo "forward           127.*.*.*/     ." >> $INSTALL/storage/.config/privoxy/config
  cp default.action $INSTALL/storage/.config/privoxy
  cp default.filter $INSTALL/storage/.config/privoxy
  cp match-all.action $INSTALL/storage/.config/privoxy
  cp trust $INSTALL/storage/.config/privoxy
  cp user.action $INSTALL/storage/.config/privoxy
  cp user.filter $INSTALL/storage/.config/privoxy
  cp templates/* $INSTALL/storage/.config/privoxy/templates
  cd -
}
