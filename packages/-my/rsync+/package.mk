PKG_NAME="rsync"
PKG_VERSION="master"
PKG_GIT_URL="git://git.samba.org/rsync.git"
PKG_DEPENDS_TARGET="toolchain"
PKG_PRIORITY="optional"
PKG_SECTION="network/backup"
PKG_IS_ADDON="yes"
PKG_ADDON_PROVIDES=""
PKG_AUTORECONF="no"


PKG_CONFIGURE_OPTS_TARGET="--disable-acl-support --disable-option-checking"
            
make_target() {
make install
}