# Install script for directory: /home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/lzo-2.10

# Set the install prefix
if(NOT DEFINED CMAKE_INSTALL_PREFIX)
  set(CMAKE_INSTALL_PREFIX "/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/toolchain")
endif()
string(REGEX REPLACE "/$" "" CMAKE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")

# Set the install configuration name.
if(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)
  if(BUILD_TYPE)
    string(REGEX REPLACE "^[^A-Za-z0-9_]+" ""
           CMAKE_INSTALL_CONFIG_NAME "${BUILD_TYPE}")
  else()
    set(CMAKE_INSTALL_CONFIG_NAME "Release")
  endif()
  message(STATUS "Install configuration: \"${CMAKE_INSTALL_CONFIG_NAME}\"")
endif()

# Set the component getting installed.
if(NOT CMAKE_INSTALL_COMPONENT)
  if(COMPONENT)
    message(STATUS "Install component: \"${COMPONENT}\"")
    set(CMAKE_INSTALL_COMPONENT "${COMPONENT}")
  else()
    set(CMAKE_INSTALL_COMPONENT)
  endif()
endif()

# Install shared libraries without execute permission?
if(NOT DEFINED CMAKE_INSTALL_SO_NO_EXE)
  set(CMAKE_INSTALL_SO_NO_EXE "0")
endif()

# Is this installation the result of a crosscompile?
if(NOT DEFINED CMAKE_CROSSCOMPILING)
  set(CMAKE_CROSSCOMPILING "TRUE")
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
   "/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/toolchain/share/doc/lzo/AUTHORS;/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/toolchain/share/doc/lzo/COPYING;/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/toolchain/share/doc/lzo/NEWS;/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/toolchain/share/doc/lzo/THANKS;/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/toolchain/share/doc/lzo/LZO.FAQ;/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/toolchain/share/doc/lzo/LZO.TXT;/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/toolchain/share/doc/lzo/LZOAPI.TXT")
  if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
file(INSTALL DESTINATION "/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/toolchain/share/doc/lzo" TYPE FILE FILES
    "/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/lzo-2.10/AUTHORS"
    "/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/lzo-2.10/COPYING"
    "/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/lzo-2.10/NEWS"
    "/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/lzo-2.10/THANKS"
    "/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/lzo-2.10/doc/LZO.FAQ"
    "/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/lzo-2.10/doc/LZO.TXT"
    "/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/lzo-2.10/doc/LZOAPI.TXT"
    )
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
   "/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/toolchain/include/lzo/lzo1.h;/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/toolchain/include/lzo/lzo1a.h;/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/toolchain/include/lzo/lzo1b.h;/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/toolchain/include/lzo/lzo1c.h;/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/toolchain/include/lzo/lzo1f.h;/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/toolchain/include/lzo/lzo1x.h;/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/toolchain/include/lzo/lzo1y.h;/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/toolchain/include/lzo/lzo1z.h;/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/toolchain/include/lzo/lzo2a.h;/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/toolchain/include/lzo/lzo_asm.h;/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/toolchain/include/lzo/lzoconf.h;/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/toolchain/include/lzo/lzodefs.h;/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/toolchain/include/lzo/lzoutil.h")
  if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
file(INSTALL DESTINATION "/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/toolchain/include/lzo" TYPE FILE FILES
    "/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/lzo-2.10/include/lzo/lzo1.h"
    "/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/lzo-2.10/include/lzo/lzo1a.h"
    "/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/lzo-2.10/include/lzo/lzo1b.h"
    "/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/lzo-2.10/include/lzo/lzo1c.h"
    "/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/lzo-2.10/include/lzo/lzo1f.h"
    "/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/lzo-2.10/include/lzo/lzo1x.h"
    "/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/lzo-2.10/include/lzo/lzo1y.h"
    "/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/lzo-2.10/include/lzo/lzo1z.h"
    "/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/lzo-2.10/include/lzo/lzo2a.h"
    "/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/lzo-2.10/include/lzo/lzo_asm.h"
    "/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/lzo-2.10/include/lzo/lzoconf.h"
    "/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/lzo-2.10/include/lzo/lzodefs.h"
    "/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/lzo-2.10/include/lzo/lzoutil.h"
    )
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
   "/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/toolchain/lib/liblzo2.a")
  if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
file(INSTALL DESTINATION "/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/toolchain/lib" TYPE STATIC_LIBRARY FILES "/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/lzo-2.10/.x86_64-pc-linux-gnu/liblzo2.a")
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  if(EXISTS "$ENV{DESTDIR}/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/toolchain/libexec/lzo/examples/lzopack" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/toolchain/libexec/lzo/examples/lzopack")
    file(RPATH_CHECK
         FILE "$ENV{DESTDIR}/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/toolchain/libexec/lzo/examples/lzopack"
         RPATH "")
  endif()
  list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
   "/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/toolchain/libexec/lzo/examples/lzopack")
  if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
file(INSTALL DESTINATION "/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/toolchain/libexec/lzo/examples" TYPE EXECUTABLE FILES "/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/lzo-2.10/.x86_64-pc-linux-gnu/lzopack")
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  if(EXISTS "$ENV{DESTDIR}/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/toolchain/libexec/lzo/examples/lzotest" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/toolchain/libexec/lzo/examples/lzotest")
    file(RPATH_CHECK
         FILE "$ENV{DESTDIR}/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/toolchain/libexec/lzo/examples/lzotest"
         RPATH "")
  endif()
  list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
   "/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/toolchain/libexec/lzo/examples/lzotest")
  if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
file(INSTALL DESTINATION "/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/toolchain/libexec/lzo/examples" TYPE EXECUTABLE FILES "/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/lzo-2.10/.x86_64-pc-linux-gnu/lzotest")
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  if(EXISTS "$ENV{DESTDIR}/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/toolchain/libexec/lzo/examples/simple" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/toolchain/libexec/lzo/examples/simple")
    file(RPATH_CHECK
         FILE "$ENV{DESTDIR}/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/toolchain/libexec/lzo/examples/simple"
         RPATH "")
  endif()
  list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
   "/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/toolchain/libexec/lzo/examples/simple")
  if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
file(INSTALL DESTINATION "/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/toolchain/libexec/lzo/examples" TYPE EXECUTABLE FILES "/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/lzo-2.10/.x86_64-pc-linux-gnu/simple")
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  if(EXISTS "$ENV{DESTDIR}/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/toolchain/libexec/lzo/examples/testmini" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/toolchain/libexec/lzo/examples/testmini")
    file(RPATH_CHECK
         FILE "$ENV{DESTDIR}/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/toolchain/libexec/lzo/examples/testmini"
         RPATH "")
  endif()
  list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
   "/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/toolchain/libexec/lzo/examples/testmini")
  if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
file(INSTALL DESTINATION "/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/toolchain/libexec/lzo/examples" TYPE EXECUTABLE FILES "/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/lzo-2.10/.x86_64-pc-linux-gnu/testmini")
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
   "/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/toolchain/lib/pkgconfig/lzo2.pc")
  if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
file(INSTALL DESTINATION "/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/toolchain/lib/pkgconfig" TYPE FILE FILES "/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/lzo-2.10/.x86_64-pc-linux-gnu/lzo2.pc")
endif()

if(CMAKE_INSTALL_COMPONENT)
  set(CMAKE_INSTALL_MANIFEST "install_manifest_${CMAKE_INSTALL_COMPONENT}.txt")
else()
  set(CMAKE_INSTALL_MANIFEST "install_manifest.txt")
endif()

string(REPLACE ";" "\n" CMAKE_INSTALL_MANIFEST_CONTENT
       "${CMAKE_INSTALL_MANIFEST_FILES}")
file(WRITE "/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/lzo-2.10/.x86_64-pc-linux-gnu/${CMAKE_INSTALL_MANIFEST}"
     "${CMAKE_INSTALL_MANIFEST_CONTENT}")
