# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)
# Copyright (C) 2019-present vpeter

. $(get_pkg_directory libbluray)/package.mk

PKG_NAME="jre-libbluray"
PKG_DEPENDS_TARGET+=" jdk-x86_64-zulu apache-ant:host"
PKG_LONGDESC="libbluray jar for BD-J menus"
PKG_URL=""

unpack() {
  mkdir -p $PKG_BUILD
  tar --strip-components=1 -xf $SOURCES/${PKG_NAME:4}/${PKG_NAME:4}-$PKG_VERSION.tar.bz2 -C $PKG_BUILD

  # use patches from original package folder
  local pkg_orig=$(get_pkg_directory libbluray)
  local pkg_copy=$(get_pkg_directory ${PKG_NAME})

  pkg_orig=${pkg_orig#"${ROOT}/"}
  pkg_copy=${pkg_copy#"${ROOT}/"}
  pkg_copy=$(echo "${pkg_copy}" | sed 's|[a-zA-Z0-9_\-]*|..|g')

  PKG_PATCH_DIRS="${pkg_copy}/../${pkg_orig}/patches"
}

pre_configure_target() {
  # build also jar
  PKG_CONFIGURE_OPTS_TARGET="${PKG_CONFIGURE_OPTS_TARGET/disable-bdjava-jar/enable-bdjava-jar}"
}

make_target() {
  # use our ant and jdk and build only jar
  export PATH="$(get_build_dir apache-ant)/binary/bin:$PATH"
  export JAVA_HOME="$(get_build_dir jdk-x86_64-zulu)"

  make all-local
}

makeinstall_target() {
  :
}
