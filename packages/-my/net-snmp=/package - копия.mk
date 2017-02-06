PKG_NAME="net-snmp"
PKG_VERSION="5.7.3"
PKG_SITE="http://www.net-snmp.org/"
PKG_URL="https://master.dl.sourceforge.net/project/net-snmp/net-snmp/$PKG_VERSION/net-snmp-$PKG_VERSION.tar.gz"
PKG_BUILD_DEPENDS="toolchain"
PKG_AUTORECONF="no"

pre_configure_target() {
   export LDFLAGS="-ldl -lpthread"
   export CPPFLAGS="$CPPFLAGS -O2"
   export modules="host misc/ipfwacc ucd-snmp/diskio tunnel ucd-snmp/dlmod"
}

PKG_CONFIGURE_OPTS_TARGET="ac_cv_NETSNMP_CAN_USE_SYSCTL=no \
			      --with-persistent-directory=/var/lib/snmp \
			      --with-defaults \
			      --enable-mini-agent \
			      --without-rpm \
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
			      --with-sys-contact="root@localhost" \
			      --with-sys-location="Unknown" \
			      --with-mib-modules=$modules \
			      --with-out-transports="Unix" \
			      --disable-manuals \
			      --with-endianness=little"