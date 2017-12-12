PKG_NAME="xbacklight"
PKG_VERSION="1.2.1"
PKG_URL="https://dl.dropboxusercontent.com/s/hx0mdm6c96jrvmr/xbacklight_1.2.1.orig.tar.gz"
PKG_DEPENDS_TARGET="toolchain readline ncurses"
PKG_SECTION="tools"
PKG_TOOLCHAIN="autotools"


#pre_configure_target() {
#export CXX='g++ -static -static-libgcc -fno-exceptions'
#export LDFLAGS='-Wl,-static -static -lc'
#export LIBS='-lc'
#cd $PKG_BUILD
#}

