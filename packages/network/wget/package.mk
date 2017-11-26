PKG_NAME="wget"
PKG_VERSION="1.19.2"
PKG_SITE="http://www.wget-editor.org/"
PKG_URL="https://ftp.gnu.org/gnu/wget/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain openssl libunistring libevent libidn2 libtasn1"
PKG_SECTION="tools"


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
