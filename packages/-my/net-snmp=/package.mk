PKG_NAME="net-snmp"
PKG_VERSION="5.7.3"
PKG_REV="100"
PKG_ARCH="any"
PKG_LICENSE="BSD"
PKG_SITE="http://www.net-snmp.org"
PKG_URL="http://sourceforge.net/projects/net-snmp/files/$PKG_NAME/$PKG_VERSION/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="service"
PKG_SHORTDESC="Simple Network Management Protocol utilities."
PKG_AUTORECONF="no"

configure_target() {
  cd $PKG_BUILD
  ./configure --host=$TARGET_NAME \
  		--build=$HOST_NAME \
  		--prefix=/usr \
  		--with-defaults \
  		--enable-static \
  		--disable-shared \
  		--with-gnu-ld \
  		--enable-applications \
  		--disable-debugging \
  		--without-rpm \
  		--disable-manuals \
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
  		--without-python-modules \
  		--with-default-snmp-version="2" \
  		--with-sys-contact="root@localhost" \
  		--with-sys-location="Unknown" \
  		--with-mib-modules="host misc/ipfwacc ucd-snmp/diskio tunnel ucd-snmp/dlmod"
}
