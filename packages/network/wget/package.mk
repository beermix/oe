PKG_NAME="wget"
PKG_VERSION="1.19.1"
PKG_SITE="http://www.wget-editor.org/"
PKG_URL="http://ftpmirror.gnu.org/wget/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain openssl libunistring"
PKG_SECTION="tools"
PKG_AUTORECONF="no"

PKG_CONFIGURE_OPTS_TARGET="--with-ssl=openssl \
                           --enable-largefile \
                           --disable-ipv6 \
                           --disable-rpath \
                           --with-metalink \
                           --sysconfdir=/storage/.config \
			      --datadir=/storage/.config \
			      --libdir=/storage/.config \
			      --libexecdir=/storage/.config \
			      --sharedstatedir=/storage/.config \
			      --localstatedir=/storage/.config \
			      --includedir=/storage/.config \
			      --oldincludedir=/storage/.config \
			      --datarootdir=/storage/.config \
			      --infodir=/storage/.config \     
			      --localedir=/storage/.config"
