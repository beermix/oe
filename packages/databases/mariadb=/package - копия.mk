# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2016-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="mariadb"
PKG_VERSION="10.1.35"
PKG_VERSION="10.2.16"
PKG_VERSION="10.3.8"
PKG_ARCH="any"
PKG_LICENSE="GPLv2"
PKG_SITE="https://github.com/MariaDB/server/releases"
PKG_URL="https://fossies.org/linux/misc/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_HOST=""
PKG_DEPENDS_TARGET="toolchain readline libaio openssl libxml2 mariadb:host"
PKG_PRIORITY="optional"
PKG_SECTION="database"
PKG_SHORTDESC="mariadb: A community developed branch of MySQL"
PKG_LONGDESC="MariaDB is a community-developed fork and a drop-in replacement for the MySQL relational database management system."
#PKG_TOOLCHAIN="cmake-make"

PKG_MARIADB_SERVER="no"

# MariaDB Feature set. Selection of features. Options are
# - xsmall : 
# - small: embedded
# - classic: embedded + archive + federated + blackhole 
# - large :  embedded + archive + federated + blackhole + innodb
# - xlarge:  embedded + archive + federated + blackhole + innodb + partition
# - community:  all  features (currently == xlarge)
  MARIADB_OPTS+=" -DFEATURE_SET=community"

# Build MariaDB Server support
  if [ "$PKG_MARIADB_SERVER" = "no" ]; then
    MARIADB_OPTS+=" -DWITHOUT_SERVER=ON"
  else
    MARIADB_OPTS+=" -DWITHOUT_SERVER=OFF"
  fi

# Build MariaDB Embedded Server support
  MARIADB_OPTS+=" -DWITH_EMBEDDED_SERVER=OFF"

# Set MariaDB server storage engines
  MARIADB_OPTS+=" -DWITH_INNOBASE_STORAGE_ENGINE=ON"
  MARIADB_OPTS+=" -WITH_PARTITION_STORAGE_ENGINE=OFF"
  MARIADB_OPTS+=" -WITH_PERFSCHEMA_STORAGE_ENGINE=OFF"

# According to MariaDB galera cluster documentation these options must be passed
# to CMake, set to '0' if galera cluster support is not wanted:
  MARIADB_OPTS+=" -DWITH_WSREP=0"
  MARIADB_OPTS+=" -DWITH_INNODB_DISALLOW_WRITES=0"

# We won't need unit tests:
  MARIADB_OPTS+=" -DWITH_UNIT_TESTS=0"

# msgpack causes trouble when cross-compiling:
  MARIADB_OPTS+=" -DGRN_WITH_MESSAGE_PACK=no"

# Mroonga needs libstemmer. Some work still needs to be done before it can be
# included in buildroot. Disable it for now.
  MARIADB_OPTS+=" -DWITHOUT_MROONGA=1"

# This value is determined automatically during straight compile by compiling
# and running a test code. You cannot do that during cross-compile. However the 
# stack grows downward in most if not all modern systems. The only exception I
# am aware of is PA-RISC which is not supported by OpenELEC. Therefore it makes
# sense to hardcode the value. If an arch is added the stack of which grows up
# one should expect unpredictable behavior at run time.
  MARIADB_OPTS+=" -DSTACK_DIRECTION=-1"

# XTRADB requires atomics intrinsic. MariaDB package tests for them by compiling
# and running C code which is not possible when cross-compiling. It is probably
# probably possible to use BR2_ARCH_HAS_ATOMIC_INTRINSICS instead of compiling
# and running some test code but for now we will just disable XTRADB.
  MARIADB_OPTS+=" -DWITHOUT_XTRADB=1"

# Jemalloc was added for TokuDB. Since its configure script seems somewhat broken
# when it comes to cross-compilation we shall disable it and also disable TokuDB.
  MARIADB_OPTS+=" -DWITH_JEMALLOC=no"
  MARIADB_OPTS+=" -DWITHOUT_TOKUDB=1"

# Some helpers must be compiled for host in order to crosscompile mariadb for
# the target. They are then included by import_executables.cmake which is
# generated during the build of the host helpers. It is not necessary to build
# the whole host package, only the "import_executables" target.
# -DIMPORT_EXECUTABLES=$PKG_BUILD/.$HOST_NAME/import_executables.cmake
# must then be passed to cmake during target build.
  PKG_MAKE_OPTS_HOST="import_executables"
  MARIADB_IMPORT_EXECUTABLES="-DIMPORT_EXECUTABLES=$PKG_BUILD/.$HOST_NAME/import_executables.cmake"

configure_host() {
  cmake -G Ninja -DCMAKE_PREFIX_PATH=$TOOLCHAIN/ \
        -DCMAKE_BUILD_TYPE=Release \
        -DFEATURE_SET=xsmall \
        -DWITHOUT_SERVER=OFF \
        -DWITH_EMBEDDED_SERVER=OFF \
        -DWITH_INNOBASE_STORAGE_ENGINE=OFF \
        -DWITH_PARTITION_STORAGE_ENGINE=OFF \
        -DWITH_PERFSCHEMA_STORAGE_ENGINE=OFF \
        -DWITH_EXTRA_CHARSETS=none \
        -DWITH_UNIT_TESTS=OFF \
        -DTOKUDB_OK=0 \
        -DDISABLE_LIBMYSQLCLIENT_SYMBOL_VERSIONING=TRUE \
        -DENABLE_DTRACE=OFF \
        -DWITH_READLINE=OFF \
        -DWITH_PCRE=bundled \
        -DWITH_ZLIB=bundled \
        -DWITH_SYSTEMD=no \
        -DWITH_LIBWRAP=OFF \
        -DWITH_WSREP=OFF \
        -DSECURITY_HARDENED=0 \
        ..
}

makeinstall_host() {
 : # nothing todo
}

configure_target() {
  cmake -G Ninja -DCMAKE_TOOLCHAIN_FILE=$CMAKE_CONF \
        -DDISABLE_SHARED=ON \
        -DCMAKE_C_FLAGS="${TARGET_CFLAGS} -fPIC -DPIC -fno-strict-aliasing -DBIG_JOINS=1 -fomit-frame-pointer -fno-delete-null-pointer-checks" \
        -DCMAKE_CXX_FLAGS="${TARGET_CXXFLAGS} -fPIC -DPIC -fno-strict-aliasing -DBIG_JOINS=1 -felide-constructors -fno-delete-null-pointer-checks" \
        -DWITH_MYSQLD_LDFLAGS="-pie ${TARGET_LDFLAGS}" \
        -DCMAKE_BUILD_TYPE=Release \
        $MARIADB_IMPORT_EXECUTABLES \
        -DCMAKE_PREFIX_PATH=$SYSROOT_PREFIX/usr \
        -DCMAKE_INSTALL_PREFIX=/usr \
        -DINSTALL_DOCDIR=share/doc/mariadb \
        -DINSTALL_DOCREADMEDIR=share/doc/mariadb \
        -DINSTALL_INCLUDEDIR=include/mysql \
        -DINSTALL_MANDIR=share/man \
        -DINSTALL_MYSQLSHAREDIR=share/mysql \
        -DINSTALL_MYSQLTESTDIR=share/mysql/test \
        -DINSTALL_PLUGINDIR=lib/mysql/plugin \
        -DINSTALL_SBINDIR=bin \
        -DINSTALL_SCRIPTDIR=share/mysql/scripts \
        -DINSTALL_SQLBENCHDIR=share/mysql/bench \
        -DINSTALL_SUPPORTFILESDIR=share/mysql/support-files \
        -DMYSQL_DATADIR=/storage/mysql \
        -DMYSQL_UNIX_ADDR=/run/mysqld/mysqld.sock \
        -DWITH_EXTRA_CHARSETS=all \
        -DTOKUDB_OK=0 \
        -DDISABLE_LIBMYSQLCLIENT_SYMBOL_VERSIONING=TRUE \
        -DENABLE_DTRACE=OFF \
        -DWITH_READLINE=OFF \
        -DWITH_PCRE=bundled \
        -DWITH_ZLIB=bundled \
        -DWITH_SYSTEMD=no \
        -DWITH_LIBWRAP=OFF \
        -DSECURITY_HARDENED=1 \
        -DWITH_SSL=$SYSROOT_PREFIX/usr \
        $MARIADB_OPTS \
        ..
}

post_makeinstall_target() {
  sed -i "s|pkgincludedir=.*|pkgincludedir=\'$SYSROOT_PREFIX/usr/include/mysql\'|" scripts/mysql_config
  sed -i "s|pkglibdir=.*|pkglibdir=\'$SYSROOT_PREFIX/usr/lib/mysql\'|" scripts/mysql_config
  cp scripts/mysql_config $SYSROOT_PREFIX/usr/bin
  ln -sf $SYSROOT_PREFIX/usr/bin/mysql_config $TOOLCHAIN/bin/mysql_config

  rm -rf $INSTALL/usr/share/mysql/support-files
  rm -rf $INSTALL/usr/share/mysql/test
  rm -rf $INSTALL/usr/share/mysql/bench
  rm -rf $INSTALL/usr/data

  if [ "$PKG_MARIADB_SERVER" = "no" ]; then
    rm -rf $INSTALL/usr/bin
    rm -rf $INSTALL/usr/lib
    rm -rf $INSTALL/usr/share/mysql/*.sql

  fi
}
