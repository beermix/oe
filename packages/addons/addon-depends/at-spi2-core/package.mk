PKG_NAME="at-spi2-core"
PKG_VERSION="2.26.0"
PKG_ARCH="any"
PKG_LICENSE="OSS"
PKG_SITE="http://ftp.gnome.org/pub/gnome/sources/at-spi2-core/?C=M;O=D"
PKG_URL="http://ftp.gnome.org/pub/gnome/sources/$PKG_NAME/2.26/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain dbus glib libXtst"
PKG_SECTION="escalade/depends"
PKG_SHORTDESC="Protocol definitions and daemon for D-Bus at-spi"
PKG_IS_ADDON="no"

PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_TARGET="ac_cv_alignof_char=1 \
			      ac_cv_alignof_dbind_pointer=8 \
			      ac_cv_alignof_dbind_struct=1 \
			      ac_cv_alignof_dbus_bool_t=4 \
			      ac_cv_alignof_dbus_int16_t=2 \
			      ac_cv_alignof_dbus_int32_t=4 \
			      ac_cv_alignof_dbus_int64_t=8 \
			      ac_cv_alignof_double=8 \
			      --disable-shared \
			      --with-pic"

