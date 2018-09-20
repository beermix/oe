# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="libssh"
PKG_VERSION="0.8.1"
PKG_SHA256="d17f1267b4a5e46c0fbe66d39a3e702b8cefe788928f2eb6e339a18bb00b1924"
PKG_ARCH="any"
PKG_LICENSE="LGPL"
PKG_SITE="http://www.libssh.org/"
PKG_URL="https://www.libssh.org/files/${PKG_VERSION:0:3}/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain zlib openssl"
PKG_SECTION="network"
PKG_SHORTDESC="libssh: A working SSH implementation by means of a library"
PKG_LONGDESC="The ssh library was designed to be used by programmers needing a working SSH implementation by the mean of a library. The complete control of the client is made by the programmer. With libssh, you can remotely execute programs, transfer files, use a secure and transparent tunnel for your remote programs. With its Secure FTP implementation, you can play with remote files easily, without third-party programs others than libcrypto (from openssl)."

PKG_CMAKE_OPTS_TARGET="-DWITH_SHARED_LIB=OFF \
                       -DWITH_STATIC_LIB=ON \
                       -DWITH_SERVER=OFF \
                       -DWITH_GCRYPT=OFF \
                       -DWITH_GSSAPI=OFF \
                       -DWITH_EXAMPLES=OFF"
