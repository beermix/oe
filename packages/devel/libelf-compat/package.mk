PKG_NAME="libelf-compat"
PKG_VERSION="328643b"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="http://www.gnu.org/s/gettext/"
PKG_GIT_URL="https://github.com/sabotage-linux/libelf-compat"
PKG_DEPENDS_HOST="ccache:host"
PKG_PRIORITY="optional"
PKG_SECTION="toolchain/devel"
PKG_SHORTDESC="gettext: A program internationalization library and tools"
PKG_LONGDESC="This is the GNU gettext package. It is interesting for authors or maintainers of other packages or programs which they want to see internationalized. As one step the handling of messages in different languages should be implemented. For this task GNU gettext provides the needed tools and library functions."

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

make_host() {
  make prefix=$ROOT/$TOOLCHAIN install
}

makeinstall_host() {
  make prefix=$ROOT/$TOOLCHAIN install
}

make_target() {
  make -C CC=$CC prefix=$SYSROOT_PREFIX/usr install
}

makeinstall_target() {
  make -C CC=$CC prefix=$SYSROOT_PREFIX/usr install
}



