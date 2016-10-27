PKG_NAME="fdkaac"
PKG_VERSION="fd2a1e7"
PKG_GIT_URL="https://github.com/nu774/fdkaac.git"
PKG_DEPENDS_TARGET="toolchain libxml2 sqlite"
PKG_PRIORITY="optional"
PKG_SECTION="tools"
PKG_SHORTDESC="aria2: lightweight multi-protocol & multi-source command-line download utility"
PKG_LONGDESC="aria2 is a lightweight multi-protocol & multi-source command-line download utility. It supports HTTP/HTTPS, FTP, BitTorrent and Metalink. aria2 can be manipulated via built-in JSON-RPC and XML-RPC interfaces"
PKG_AUTORECONF="no"

pre_configure_target() {
  cd $ROOT/$PKG_BUILD
  rm -rf .$TARGET_NAME


}

make_target() {
./configure prefix=/
}

make_install() {
 make install prefix=/
}
