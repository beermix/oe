PKG_NAME="wget"
PKG_VERSION="1.20.3"
PKG_SITE="https://ftp.gnu.org/gnu/wget/?C=M;O=D"
PKG_URL="https://ftp.gnu.org/gnu/wget/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain openssl libunistring libidn2 libtasn1"
PKG_DEPENDS_TARGET="toolchain openssl"
PKG_SECTION="network"

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
