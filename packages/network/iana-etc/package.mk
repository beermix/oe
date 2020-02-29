PKG_NAME="iana-etc"
PKG_VERSION="2020"
PKG_LICENSE="none"
PKG_SITE="http://www.iana.org"
PKG_SHORTDESC="iana-etc: The Iana-Etc package provides data for network services and protocols."
PKG_TOOLCHAIN="manual"

unpack() {
  mkdir $PKG_BUILD
}

make_target() {
  wget --tries=5 --timeout=20 --no-check-certificate https://www.iana.org/assignments/protocol-numbers/protocol-numbers.xml
  wget --tries=5 --timeout=20 --no-check-certificate https://www.iana.org/assignments/service-names-port-numbers/service-names-port-numbers.xml
}

makeinstall_target() {
  mkdir -p $INSTALL/etc
  gawk '
BEGIN {
	print "# Full data: https://www.iana.org/assignments/protocol-numbers/protocol-numbers.xml\n"
	FS="[<>]"
}

{
	if (/<record/) { v=n=0 }
	if (/<value/) v=$3
	if (/<name/ && !($3~/ /)) n=$3
	if (/<\/record/ && (v || n=="HOPOPT") && n) printf "%-12s %3i %s\n", tolower(n),v,n
}
' protocol-numbers.xml > $INSTALL/etc/protocols
  gawk '
BEGIN {
        print "# Full data: https://www.iana.org/assignments/service-names-port-numbers/service-names-port-numbers.xml\n"
	FS="[<>]"
}

{
	if (/<record/) { n=u=p=c=0 }
	if (/<name/ && !/\(/) n=$3
	if (/<number/) u=$3
	if (/<protocol/) p=$3
	if (/Unassigned/ || /Reserved/ || /historic/) c=1
	if (/<\/record/ && n && u && p && !c) printf "%-15s %5i/%s\n", n,u,p
}' service-names-port-numbers.xml > $INSTALL/etc/services
}
