################################################################################
#      This file is part of LibreELEC - https://libreelec.tv
#      Copyright (C) 2016-present Team LibreELEC
#
#  LibreELEC is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 2 of the License, or
#  (at your option) any later version.
#
#  LibreELEC is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with LibreELEC.  If not, see <http://www.gnu.org/licenses/>.
################################################################################

PKG_NAME="mysqld"
PKG_VERSION="5.7.18"
PKG_SHA256="0b5d71ed608656cd8181d3bb0434d3e36bac192899038dbdddf5a7594aaea1a2"
PKG_ARCH="any"
PKG_LICENSE="LGPL"
PKG_SITE="http://www.mysql.com"
PKG_URL="http://ftp.gwdg.de/pub/misc/mysql/Downloads/MySQL-5.7/mysql-$PKG_VERSION.tar.gz"
PKG_DEPENDS_HOST="toolchain zlib:host"
PKG_DEPENDS_TARGET="toolchain zlib openssl boost mysqld:host"

if [ -f $SYSROOT_PREFIX/usr/lib/libterminfo.a ]; then
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET netbsd-curses"
  HAVE_LIBAIO_ARG="-DHAVE_LIBAIO=0"
  # HAVE_LIBAIO=0 for innobase plugin which doesn't build without this on old le build
else
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET ncurses"
  HAVE_LIBAIO_ARG=""
fi

PKG_SECTION="database"
PKG_SHORTDESC="mysql: A database server"
PKG_LONGDESC="MySQL is a SQL (Structured Query Language) database server. SQL is the most popular database language in the world. MySQL is a client server implementation that consists of a server daemon mysqld and many different client programs/libraries."
PKG_AUTORECONF="no"

# officialy supported and required version (for server)
BOOST_1_59_0="$BUILD/boost_1_59_0"

# need to unpack in different folder
unpack() {
  SRC_ARCHIVE="$SOURCES/$PKG_NAME/mysqld-$PKG_VERSION.tar.gz"
  mkdir $PKG_BUILD
  tar xzf "$SRC_ARCHIVE" -C $PKG_BUILD
  mv $PKG_BUILD/mysql-$PKG_VERSION/* $PKG_BUILD
  rm -fr $PKG_BUILD/mysql-$PKG_VERSION

(
  mkdir -p $BOOST_1_59_0
  cd $BOOST_1_59_0
  if [ ! -f boost_1_59_0.tar.gz ]; then
    #wget -O boost_1_59_0.tar.gz http://mirror.nienbo.com/boost/1.59.0/boost_1_59_0.tar.gz
    wget -O boost_1_59_0.tar.gz wget http://sourceforge.net/projects/boost/files/boost/1.59.0/boost_1_59_0.tar.gz
  fi
  rm -fr boost_1_59_0
  tar xzf boost_1_59_0.tar.gz
)
}

post_unpack() {
  # for libressl
  #sed -i 's|OPENSSL_MAJOR_VERSION STREQUAL "1"|OPENSSL_MAJOR_VERSION STREQUAL "2"|' $PKG_BUILD/cmake/ssl.cmake

  sed -i 's|GET_TARGET_PROPERTY(LIBMYSQL_OS_OUTPUT_NAME libmysql OUTPUT_NAME)|SET(LIBMYSQL_OS_OUTPUT_NAME "mysqlclient")|' $PKG_BUILD/scripts/CMakeLists.txt
  sed -i "s|COMMAND comp_err|COMMAND $PKG_BUILD/.$HOST_NAME/extra/comp_err|" $PKG_BUILD/extra/CMakeLists.txt
  sed -i "s|COMMAND comp_sql|COMMAND $PKG_BUILD/scripts/comp_sql|" $PKG_BUILD/scripts/CMakeLists.txt
  sed -i "s|COMMAND gen_lex_hash|COMMAND $PKG_BUILD/.$HOST_NAME/sql/gen_lex_hash|" $PKG_BUILD/sql/CMakeLists.txt
  sed -i "s|COMMAND gen_lex_token|COMMAND $PKG_BUILD/.$HOST_NAME/sql/gen_lex_token|" $PKG_BUILD/sql/CMakeLists.txt

  #sed -i '/^IF(NOT BOOST_MINOR_VERSION.*$/,/^ENDIF()$/d' $PKG_BUILD/cmake/boost.cmake
  # ^^^ we are using local boost with correct version

  # doesn't link without libmysqlclient
  #sed -i "s|TARGET_LINK_LIBRARIES(libmysql_api_test|TARGET_LINK_LIBRARIES(libmysql_api_test mysqlclient|g" $PKG_BUILD/libmysql/CMakeLists.txt
}
                    
PKG_CMAKE_OPTS_HOST="-DCMAKE_BUILD_TYPE=Release \
                     -DSTACK_DIRECTION=-1 \
                     -DHAVE_LLVM_LIBCPP_EXITCODE=0 \
                     -DHAVE_FALLOC_PUNCH_HOLE_AND_KEEP_SIZE_EXITCODE=0 \
                     -DWITHOUT_SERVER=OFF \
                     -DWITH_EMBEDDED_SERVER=OFF \
                     -DWITH_INNOBASE_STORAGE_ENGINE=OFF \
                     -DWITH_PARTITION_STORAGE_ENGINE=OFF \
                     -DWITH_PERFSCHEMA_STORAGE_ENGINE=OFF \
                     -DWITH_EXTRA_CHARSETS=none \
                     -DWITH_EDITLINE=bundled \
                     -DWITH_LIBEVENT=bundled \
                     -DDOWNLOAD_BOOST=0 \
                     -DWITH_BOOST=$BOOST_1_59_0/boost_1_59_0.tar.gz \
                     -DWITH_UNIT_TESTS=OFF \
                     -DWITH_PROTOBUF=bundled \
                     -DWITH_ZLIB=bundled"

pre_configure_target() {
  strip_lto		# need for server
}

post_configure_target() {
  # hack for kszaq's build
  if [ -f $SYSROOT_PREFIX/usr/lib/libterminfo.a ]; then
    sed -i 's|-lcurses|-lcurses -lterminfo|' client/CMakeFiles/mysql.dir/link.txt
  fi
}

make_host() {
  make comp_err
  make gen_lex_hash
  make gen_lex_token
  make comp_sql
  make protoc
}

post_make_host() {
  # needed so the binary isn't built for target
  cp scripts/comp_sql ../scripts/comp_sql
}

makeinstall_host() {
  : # nothing
}

PKG_CMAKE_OPTS_TARGET="-DINSTALL_INCLUDEDIR=include/mysql \
                       -DCMAKE_BUILD_TYPE=Release \
                       -DFEATURE_SET=classic \
                       -DDISABLE_SHARED=OFF \
                       -DENABLE_DTRACE=OFF \
                       -DWITH_EMBEDDED_SERVER=OFF \
                       -DWITH_INNOBASE_STORAGE_ENGINE=ON \
                       -DWITH_PARTITION_STORAGE_ENGINE=ON \
                       -DWITH_PERFSCHEMA_STORAGE_ENGINE=ON \
                       -DWITH_EXTRA_CHARSETS=all \
                       -DWITH_UNIT_TESTS=OFF \
                       -DWITHOUT_SERVER=OFF \
                       -DWITH_EDITLINE=bundled \
                       -DWITH_LIBEVENT=bundled \
                       -DWITH_ZLIB=system \
                       -DWITH_SSL=$SYSROOT_PREFIX/usr \
\
                       -DHAVE_FALLOC_PUNCH_HOLE_AND_KEEP_SIZE=1 \
                       -DHAVE_IB_GCC_SYNC_SYNCHRONISE=1 \
                       -DHAVE_IB_GCC_ATOMIC_THREAD_FENCE=1 \
                       -DHAVE_IB_GCC_ATOMIC_COMPARE_EXCHANGE=1 \
                       -DHAVE_IB_ATOMIC_PTHREAD_T_GCC=1 \
                       -DHAVE_IB_LINUX_FUTEX=1 \
\
                       -DWITH_INNODB=1 \
                       -DDOWNLOAD_BOOST=0 \
                       -DWITH_BOOST=$BOOST_1_59_0/boost_1_59_0.tar.gz \
                       -DBOOST_INCLUDE_DIR=$BOOST_1_59_0/boost_1_59_0 \
                       -DLOCAL_BOOST_DIR=$BOOST_1_59_0/boost_1_59_0 \
                       -DWITH_PROTOBUF=bundled \
                       -DPROTOBUF_PROTOC_EXECUTABLE=$PKG_BUILD/.$HOST_NAME/extra/protobuf/protoc \
                       -DMYSQL_UNIX_ADDR=/tmp/mysql.sock \
\
                       -DSTACK_DIRECTION=1 \
                       -DHAVE_LLVM_LIBCPP=1 \
                       $HAVE_LIBAIO_ARG"

#                       -DHAVE_FALLOC_PUNCH_HOLE_AND_KEEP_SIZE_EXITCODE=0 \
#                       -DHAVE_FUNC_IN_CXX_EXITCODE=0 \
#                       -DHAVE___BUILTIN_FFS_EXITCODE=0 \
#                       -DMUTEX_FUTEX=1 \
                                                                                        
# --with-plugins=innobase,innodb_plugin,myisam,myisammrg,csv"
#  -DWITH_<PLUGIN>=1

makeinstall_target() {
  # use this version only for addon (don't install it to a system)
  make -j1 install DESTDIR=$INSTALL $PKG_MAKEINSTALL_OPTS_TARGET
}

# https://dev.mysql.com/doc/refman/5.7/en/show-plugins.html
# https://dev.mysql.com/doc/refman/5.7/en/csv-storage-engine.html
