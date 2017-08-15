PKG_NAME="zsh"
PKG_VERSION="5.4.1"
PKG_GIT_URL="https://github.com/zsh-users/zsh"
PKG_DEPENDS_TARGET="toolchain netbsd-curses pcre readline libcap"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

#pre_configure_target() {
#  strip_lto
#}

PKG_CONFIGURE_OPTS_TARGET="--prefix=/usr \
			      --bindir=/bin \
			      --disable-cap \
			      --enable-pcre \
			      --enable-multibyte \
			      --disable-ansi2knr \
			      --disable-shared \
			      --enable-static \
			      --disable-gdbm" 