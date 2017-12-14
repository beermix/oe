PKG_NAME="mtr"
PKG_VERSION="1"
PKG_URL="https://dl.dropboxusercontent.com/s/ri1jx1jhzfzjmre/mtr-1.tar.xz"
PKG_DEPENDS_TARGET="toolchain readline"
PKG_SECTION="tools"
PKG_TOOLCHAIN="autotools"

configure_target(){
cd $PKG_BUILD
LIBS="-lcurses -lterminfo" \
./configure --without-gtk
make LDFLAGS="-lcurses -lterminfo"
}
