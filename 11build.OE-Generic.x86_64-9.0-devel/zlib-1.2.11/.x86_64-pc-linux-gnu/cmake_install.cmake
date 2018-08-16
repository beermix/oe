# Install script for directory: /home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/zlib-1.2.11

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
  foreach(file
      "$ENV{DESTDIR}/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/toolchain/lib/libz.so.1.2.11"
      "$ENV{DESTDIR}/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/toolchain/lib/libz.so.1"
      )
    if(EXISTS "${file}" AND
       NOT IS_SYMLINK "${file}")
      file(RPATH_CHECK
           FILE "${file}"
           RPATH "")
    endif()
  endforeach()
  list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
   "/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/toolchain/lib/libz.so.1.2.11;/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/toolchain/lib/libz.so.1")
  if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
file(INSTALL DESTINATION "/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/toolchain/lib" TYPE SHARED_LIBRARY FILES
    "/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/zlib-1.2.11/.x86_64-pc-linux-gnu/libz.so.1.2.11"
    "/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/zlib-1.2.11/.x86_64-pc-linux-gnu/libz.so.1"
    )
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  if(EXISTS "$ENV{DESTDIR}/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/toolchain/lib/libz.so" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/toolchain/lib/libz.so")
    file(RPATH_CHECK
         FILE "$ENV{DESTDIR}/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/toolchain/lib/libz.so"
         RPATH "")
  endif()
  list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
   "/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/toolchain/lib/libz.so")
  if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
file(INSTALL DESTINATION "/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/toolchain/lib" TYPE SHARED_LIBRARY FILES "/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/zlib-1.2.11/.x86_64-pc-linux-gnu/libz.so")
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
   "/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/toolchain/lib/libz.a")
  if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
file(INSTALL DESTINATION "/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/toolchain/lib" TYPE STATIC_LIBRARY FILES "/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/zlib-1.2.11/.x86_64-pc-linux-gnu/libz.a")
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
   "/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/toolchain/include/zconf.h;/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/toolchain/include/zlib.h")
  if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
file(INSTALL DESTINATION "/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/toolchain/include" TYPE FILE FILES
    "/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/zlib-1.2.11/.x86_64-pc-linux-gnu/zconf.h"
    "/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/zlib-1.2.11/zlib.h"
    )
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
   "/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/toolchain/share/man/man3/zlib.3")
  if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
file(INSTALL DESTINATION "/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/toolchain/share/man/man3" TYPE FILE FILES "/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/zlib-1.2.11/zlib.3")
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
   "/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/toolchain/lib/pkgconfig/zlib.pc")
  if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
file(INSTALL DESTINATION "/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/toolchain/lib/pkgconfig" TYPE FILE FILES "/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/zlib-1.2.11/.x86_64-pc-linux-gnu/zlib.pc")
endif()

if(CMAKE_INSTALL_COMPONENT)
  set(CMAKE_INSTALL_MANIFEST "install_manifest_${CMAKE_INSTALL_COMPONENT}.txt")
else()
  set(CMAKE_INSTALL_MANIFEST "install_manifest.txt")
endif()

string(REPLACE ";" "\n" CMAKE_INSTALL_MANIFEST_CONTENT
       "${CMAKE_INSTALL_MANIFEST_FILES}")
file(WRITE "/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/zlib-1.2.11/.x86_64-pc-linux-gnu/${CMAKE_INSTALL_MANIFEST}"
     "${CMAKE_INSTALL_MANIFEST_CONTENT}")
