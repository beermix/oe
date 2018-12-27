# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="mariadb"
PKG_VERSION="10.3.11"
PKG_REV="100"
PKG_SHA256="211655b794c9d5397ba3be6c90737eac02e882f296268299239db47ba328f1b2"
PKG_LICENSE="GPL2"
PKG_SITE="https://mariadb.org/"
PKG_URL="https://downloads.mariadb.org/interstitial/${PKG_NAME}-${PKG_VERSION}/source/${PKG_NAME}-${PKG_VERSION}.tar.gz"
PKG_DEPENDS_HOST="toolchain ncurses:host"
PKG_DEPENDS_TARGET="toolchain ncurses libaio openssl zlib bzip2 lzo binutils systemd libxml2 mariadb:host"
PKG_SHORTDESC="MariaDB is a community-developed fork of the MySQL."
PKG_LONGDESC="${PKG_SHORTDESC}"
PKG_BUILD_FLAGS="-gold"

PKG_IS_ADDON="yes"
PKG_SECTION="service"
PKG_ADDON_NAME="MariaDB"
PKG_ADDON_TYPE="xbmc.service"

PKG_CMAKE_OPTS_HOST=" \
  -DCMAKE_INSTALL_MESSAGE=NEVER \
  -DSTACK_DIRECTION=-1 \
  -DHAVE_IB_GCC_ATOMIC_BUILTINS=1 \
  -DCMAKE_CROSSCOMPILING=OFF \
  -DCMAKE_SYSTEM_PROCESSOR=${TARGET_GCC_ARCH} \
    import_executables"

make_host() {
  ninja ${NINJA_OPTS} import_executables
}

makeinstall_host() {
  : #
}

PKG_CMAKE_OPTS_TARGET=" \
  -DCMAKE_INSTALL_MESSAGE=NEVER \
  -DCMAKE_BUILD_TYPE=Release \
  -DBUILD_CONFIG=mysql_release \
  -DFEATURE_SET=classic \
  -DSTACK_DIRECTION=1 \
  -DDISABLE_LIBMYSQLCLIENT_SYMBOL_VERSIONING=ON \
  -DCMAKE_CROSSCOMPILING=ON \
  -DIMPORT_EXECUTABLES=${PKG_BUILD}/.${HOST_NAME}/import_executables.cmake \
  -DWITHOUT_AWS_KEY_MANAGEMENT=ON \
  -DWITH_EXTRA_CHARSETS=complex \
  -DWITH_SSL=system \
  -DWITH_SSL=${SYSROOT_PREFIX}/usr \
  -DWITH_JEMALLOC=OFF \
  -DWITH_PCRE=bundled \
  -DWITH_ZLIB=bundled \
  -DWITH_EDITLINE=bundled \
  -DWITH_LIBEVENT=bundled \
  -DCONNECT_WITH_LIBXML2=bundled \
  -DSKIP_TESTS=ON \
  -DWITH_DEBUG=OFF \
  -DWITH_UNIT_TESTS=OFF \
  -DENABLE_DTRACE=OFF \
  -DSECURITY_HARDENED=OFF \
  -DWITH_EMBEDDED_SERVER=OFF \
  -DWITHOUT_SERVER=OFF \
  -DPLUGIN_AUTH_SOCKET=STATIC \
  -DaCONNECT_WITH_JDBC=NO \
  -DaCONNECT_WITH_MONGO=NO \
  -DaCONNECT_WITH_ODBC=NO \
  -DDISABLE_SHARED=NO \
  -DENABLED_PROFILING=OFF \
  -DENABLE_STATIC_LIBS=OFF \
  -DMYSQL_UNIX_ADDR=/var/run/mysqld/mysqld.sock \
  -DWITH_SAFEMALLOC=OFF \
  -DWITHOUT_AUTH_EXAMPLES=ON"

makeinstall_target() {
  # use only for addon
  local INSTALL_ADDON="${PKG_BUILD}/.install_addon"

  DESTDIR=${INSTALL_ADDON} ninja ${NINJA_OPTS} install
  rm -rf "${INSTALL_ADDON}/usr/mysql-test"
}

addon() {
  local ADDON="${ADDON_BUILD}/${PKG_ADDON_ID}"
  local MARIADB="${PKG_BUILD}/.install_addon/usr"

  mkdir -p ${ADDON}/bin
  mkdir -p ${ADDON}/config

  cp ${MARIADB}/bin/mysql \
     ${MARIADB}/bin/mysqld \
     ${MARIADB}/bin/mysqladmin \
     ${MARIADB}/bin/mysql_secure_installation \
     ${MARIADB}/bin/my_print_defaults \
     ${MARIADB}/bin/resolveip \
     ${MARIADB}/scripts/mysql_install_db \
     ${ADDON}/bin

  cp ${PKG_DIR}/config/my.cnf ${ADDON}/config
  cp ${PKG_DIR}/config/prepare_kodi.sql ${ADDON}/config

  cp -PR ${MARIADB}/share ${ADDON}
}
