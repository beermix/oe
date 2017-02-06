PKG_NAME="net-snmp"
PKG_VERSION="5.7.3"
PKG_SITE="http://www.net-snmp.org/"
PKG_URL="https://master.dl.sourceforge.net/project/net-snmp/net-snmp/$PKG_VERSION/net-snmp-$PKG_VERSION.tar.gz"
PKG_BUILD_DEPENDS="toolchain lm_sensors"
PKG_AUTORECONF="no"

pre_configure_target() {
   export LDFLAGS="-ldl -lpthread"
   unset CPPFLAGS
   export modules="host misc/ipfwacc ucd-snmp/diskio tunnel ucd-snmp/dlmod"
}


PKG_CONFIGURE_OPTS_TARGET="--with-defaults \
			      --enable-static \
			      --disable-shared \
			      --with-gnu-ld \
			      --with-persistent-directory=/storage/.config/net-snmp \
			      --enable-applications \
			      --disable-debugging \
			      --without-rpm \
			      --without-zlib \
			      --disable-manuals \
			      --disable-ipv6 \
			      --with-sys-contact="root@localhost" \
			      --with-sys-location="Unknown" \
			      --with-out-transports="Unix" \
			      --disable-manual \
			      --without-openssl \
			      --enable-mini-agent \
			      --with-logfile=none \
			      --without-kmem-usage \
			      --enable-as-needed \
			      --without-perl-modules \
			      --disable-embedded-perl \
			      --disable-perl-cc-checks \
			      --disable-scripts \
			      --with-default-snmp-version="1" \
			      --enable-silent-libtool \
			      --enable-mfd-rewrites \
			      --with-mib-modules=$modules \
			      --with-endianness=little"