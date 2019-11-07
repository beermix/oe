# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="mariadb"
PKG_VERSION="10.4.9"
PKG_REV="105"
PKG_SHA256=""
PKG_LICENSE="GPL2"
PKG_SITE="https://github.com/MariaDB/server/releases"
PKG_URL="https://downloads.mariadb.org/interstitial/${PKG_NAME}-${PKG_VERSION}/source/${PKG_NAME}-${PKG_VERSION}.tar.gz"
PKG_DEPENDS_HOST="toolchain:host ncurses:host"
PKG_DEPENDS_TARGET="toolchain binutils bzip2 libaio libxml2 lzo ncurses openssl systemd zlib xz jemalloc mariadb:host"
PKG_SHORTDESC="MariaDB is a community-developed fork of the MySQL."
PKG_LONGDESC="MariaDB (${PKG_VERSION}) is a fast SQL database server and a drop-in replacement for MySQL."
PKG_TOOLCHAIN="cmake"
PKG_BUILD_FLAGS="-gold"

PKG_IS_ADDON="yes"
PKG_SECTION="service"
PKG_ADDON_NAME="MariaDB SQL database server"
PKG_ADDON_TYPE="xbmc.service"

configure_package() {
  PKG_CMAKE_OPTS_HOST=" \
    -DCMAKE_INSTALL_MESSAGE=NEVER \
    -DSTACK_DIRECTION=-1 \
    -DHAVE_IB_GCC_ATOMIC_BUILTINS=1 \
    -DCMAKE_CROSSCOMPILING=OFF \
    import_executables"

  PKG_CMAKE_OPTS_TARGET=" \
    -DDISABLE_LIBMYSQLCLIENT_SYMBOL_VERSIONING=ON \
    -DCMAKE_CROSSCOMPILING=ON \
    -DIMPORT_EXECUTABLES=${PKG_BUILD}/.${HOST_NAME}/import_executables.cmake \
    -DWITHOUT_AWS_KEY_MANAGEMENT=ON \
    -DWITH_EDITLINE=bundled \
    -DWITH_LIBEVENT=bundled \
    -DCONNECT_WITH_LIBXML2=bundled \
    -DCMAKE_BUILD_TYPE=RelWithDebInfo \
    -DDEFAULT_CHARSET=utf8mb4 \
    -DDEFAULT_COLLATION=utf8mb4_unicode_ci \
    -DENABLED_LOCAL_INFILE=ON \
    -DPLUGIN_EXAMPLE=NO \ 
    -DPLUGIN_FEDERATED=NO \
    -DPLUGIN_FEEDBACK=NO \
    -DWITH_EMBEDDED_SERVER=ON \
    -DWITH_EXTRA_CHARSETS=complex \
    -DWITH_JEMALLOC=ON \
    -DWITH_LIBWRAP=OFF \
    -DWITH_PCRE=bundled \
    -DWITH_READLINE=ON \
    -DWITH_SSL=system \
    -DWITH_SYSTEMD=yes \
    -DWITH_UNIT_TESTS=OFF \
    -DWITH_ZLIB=system \
    -DSTACK_DIRECTION=-1 \
    -Dhave_CXX__D_FORTIFY_SOURCE_2=0 \
    -DMYSQLD_STATIC_PLUGIN_LIBS=1 \
    -DMYSQL_UNIX_ADDR=/var/run/mysqld/mysqld.sock"
}

make_host() {
  ninja ${NINJA_OPTS}
}

makeinstall_host() {
  :
}

makeinstall_target() {
  # use only for addon
ninja ${NINJA_OPTS} install -j8
  rm -rf "${PKG_BUILD}/.install_addon/usr/mysql-test"
}

addon() {
  local ADDON="${ADDON_BUILD}/${PKG_ADDON_ID}"
  local MARIADB="${PKG_BUILD}/.install_addon/usr"

  mkdir -p ${ADDON}/bin
  mkdir -p ${ADDON}/config

  cp ${MARIADB}/bin/mysql \
     ${MARIADB}/bin/mysqld \
     ${MARIADB}/bin/mysqladmin \
     ${MARIADB}/bin/mysqldump \
     ${MARIADB}/bin/mysql_secure_installation \
     ${MARIADB}/bin/my_print_defaults \
     ${MARIADB}/bin/resolveip \
     ${MARIADB}/scripts/mysql_install_db \
     ${ADDON}/bin

  cp -PR ${MARIADB}/share ${ADDON}
}
