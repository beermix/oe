# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)

PKG_NAME="expat"
PKG_VERSION="2.2.6"
PKG_SHA256="17b43c2716d521369f82fc2dc70f359860e90fa440bea65b3b85f0b246ea81f2"
PKG_ARCH="any"
PKG_LICENSE="OSS"
PKG_SITE="https://github.com/libexpat/libexpat/releases"
PKG_URL="https://github.com/libexpat/libexpat/releases/download/R_2_2_6/expat-$PKG_VERSION.tar.bz2"
PKG_DEPENDS_TARGET="toolchain"
PKG_DEPENDS_HOST="cmake:host"
PKG_SECTION="textproc"
PKG_SHORTDESC="expat: XML parser library"
PKG_LONGDESC="Expat is an XML parser library written in C. It is a stream-oriented parser in which an application registers handlers for things the parser might find in the XML document (like start tags). An introductory article on using Expat is available on xml.com."
PKG_TOOLCHAIN="configure"
PKG_TOOLCHAIN="cmake-make"

PKG_CMAKE_OPTS_TARGET="-BUILD_doc=OFF -DBUILD_tools=OFF -DBUILD_examples=OFF -DBUILD_tests=OFF -DBUILD_shared=ON"
PKG_CMAKE_OPTS_HOST="$PKG_CMAKE_OPTS_TARGET"
