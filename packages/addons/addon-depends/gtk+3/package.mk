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

PKG_NAME="gtk+"
PKG_VERSION=3.16.3"
PKG_SITE="http://www.gtk.org/"
PKG_URL="http://ftp.gnome.org/pub/gnome/sources/gtk+/3.16/gtk+-3.16.3.tar.xz"
PKG_DEPENDS_TARGET="toolchain atk libX11 libXrandr libXi glib pango cairo gdk-pixbuf graphene"
PKG_SECTION="x11/toolkits"
PKG_SHORTDESC="gtk+: The Gimp ToolKit (GTK)"
PKG_LONGDESC="This is GTK+. GTK+, which stands for the Gimp ToolKit, is a library for creating graphical user interfaces for the X Window System. It is designed to be small, efficient, and flexible. GTK+ is written in C with a very object-oriented approach."
PKG_IS_ADDON="no"

PKG_AUTORECONF="no"
mkdir bin
cat << EOF > bin/gdbus-codegen
#!/bin/sh
touch gtkdbusgenerated.h
touch gtkdbusgenerated.c
#cp gtkdbusinterfaces.xml foo.xml
#exit 1
EOF
chmod +x bin/gdbus-codegen
# patch out crap relying on dbus
cat << EOF > gtk/gtkmountoperation.c
#define GMountOperation void
#define GtkMountOperation void
#define GtkWindow void
#define GdkScreen void
#define gboolean int
#define GType unsigned long /* size_t */
#define P __attribute__ ((visibility ("default")))
extern GType g_mount_operation_get_type();
P GType gtk_mount_operation_get_type() { return g_mount_operation_get_type(); }
P GMountOperation *gtk_mount_operation_new (GtkWindow *parent) { return 0; }
P gboolean gtk_mount_operation_is_showing (GtkMountOperation *op) { return 0; }
P void gtk_mount_operation_set_parent (GtkMountOperation *op, GtkWindow *parent) {}
P GtkWindow *gtk_mount_operation_get_parent (GtkMountOperation *op) { return 0; }
P void gtk_mount_operation_set_screen (GtkMountOperation *op, GdkScreen *screen){}
P GdkScreen *gtk_mount_operation_get_screen (GtkMountOperation *op){ return 0; }
EOF
for i in tests testsuite docs examples docs/reference docs/tools docs/reference/gtk docs/reference/libgail-util ; do
printf "all:\n\ttrue\n\ninstall:\n\ttrue\n\n" > $i/Makefile.in
done

