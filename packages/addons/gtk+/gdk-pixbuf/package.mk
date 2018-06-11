################################################################################
#      This file is part of OpenELEC - http://www.openelec.tv
#      Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
#
#  This Program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2, or (at your option)
#  any later version.
#
#  This Program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with OpenELEC.tv; see the file COPYING.  If not, write to
#  the Free Software Foundation, 51 Franklin Street, Suite 500, Boston, MA 02110, USA.
#  http://www.gnu.org/copyleft/gpl.html
################################################################################

PKG_NAME="gdk-pixbuf"
PKG_VERSION="2.35.5"
#PKG_SHA256="fff85cf48223ab60e3c3c8318e2087131b590fd6f1737e42cb3759a3b427a334"
PKG_ARCH="any"
PKG_LICENSE="OSS"
PKG_SITE="http://ftp.acc.umu.se/pub/gnome/sources/gdk-pixbuf/2.35/?C=M;O=D"
PKG_URL="http://ftp.acc.umu.se/pub/gnome/sources/gdk-pixbuf/2.35/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain libiconv glib libjpeg-turbo libpng jasper"
PKG_DEPENDS_HOST="glib:host libpng:host tiff:host libjpeg-turbo:host jasper:host"
PKG_SECTION="x11/toolkits"
PKG_SHORTDESC="gdk-pixbuf: a GNOME library for image loading and manipulation."
PKG_LONGDESC="gdk-pixbuf (GdkPixbuf) is a GNOME library for image loading and manipulation. The GdkPixbuf documentation contains both the programmer's guide and the API reference."
PKG_TOOLCHAIN="autotools"

PKG_MESON_OPTS_TARGET="-Dpng=true \
			  -Dtiff=true \
			  -Djpeg=true \
			  -Djasper=true \
			  -Dx11=true \
			  -Dbuiltin_loaders=all \
			  -Ddocs=false \
			  -Dman=false \
			  -Dnative_windows_loaders=false"
			  
PKG_CONFIGURE_OPTS_TARGET="gio_can_sniff=no \
			      --disable-installed-tests \
			      --enable-nls \
			      --disable-glibtest \
			      --disable-gio-sniffing \
			      --with-libjpeg \
			      --with-libjasper \
			      --with-libpng \
			      --with-libtiff \
			      --with-x11"

PKG_CONFIGURE_OPTS_HOST="gio_can_sniff=no \
			    --disable-glibtest \
			    --with-libpng=$TOOLCHAIN \
			    --with-libjpeg=no \
			    --with-libjasper=$TOOLCHAIN \
			    --with-libtiff=$TOOLCHAIN"