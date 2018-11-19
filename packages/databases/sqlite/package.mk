# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="sqlite"
PKG_VERSION="autoconf-3250300"
PKG_SHA256="00ebf97be13928941940cc71de3d67e9f852698233cd98ce2d178fd08092f3dd"
PKG_LICENSE="PublicDomain"
PKG_SITE="https://www.sqlite.org/"
PKG_URL="https://www.sqlite.org/2018/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain zlib sqlite:host"
PKG_DEPENDS_HOST="zlib:host"
PKG_SHORTDESC="sqlite: An Embeddable SQL Database Engine"
# libsqlite3.a(sqlite3.o): requires dynamic R_X86_64_PC32 reloc against 'sqlite3_stricmp' which may overflow at runtime
#PKG_TOOLCHAIN="autotools"
PKG_BUILD_FLAGS="-parallel +hardening"

# sqlite fails to compile with fast-math link time optimization.
  CFLAGS=`echo $CFLAGS | sed -e "s|-Ofast|-O3|g"`
  CFLAGS=`echo $CFLAGS | sed -e "s|-ffast-math||g"`

# This option adds additional logic to the ANALYZE command and to the query planner
# that can help SQLite to chose a better query plan under certain situations. The
# ANALYZE command is enhanced to collect histogram data from each index and store
# that data in the sqlite_stat3 table. The query planner will then use the histogram
# data to help it make better index choices.
  CFLAGS="$CFLAGS -DSQLITE_ENABLE_STAT3"

# When this C-preprocessor macro is defined, SQLite includes some additional APIs
# that provide convenient access to meta-data about tables and queries. The APIs that
# are enabled by this option are:
#  - sqlite3_column_database_name()
#  - sqlite3_column_database_name16()
#  - sqlite3_column_table_name()
#  - sqlite3_column_table_name16()
#  - sqlite3_column_origin_name()
#  - sqlite3_column_origin_name16()
#  - sqlite3_table_column_metadata()
  CFLAGS="$CFLAGS -DSQLITE_ENABLE_COLUMN_METADATA=1"

# This macro sets the default limit on the amount of memory that will be used for
# memory-mapped I/O for each open database file. If the N is zero, then memory
# mapped I/O is disabled by default. This compile-time limit and the
# SQLITE_MAX_MMAP_SIZE can be modified at start-time using the
# sqlite3_config(SQLITE_CONFIG_MMAP_SIZE) call, or at run-time using the
# mmap_size pragma.
  CFLAGS="$CFLAGS -DSQLITE_TEMP_STORE=3 -DSQLITE_DEFAULT_MMAP_SIZE=268435456"

PKG_CONFIGURE_OPTS_TARGET="--enable-threadsafe --enable-dynamic-extensions --disable-silent-rules"

PKG_CONFIGURE_OPTS_HOST="$PKG_CONFIGURE_OPTS_TARGET"
