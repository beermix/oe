# Install script for directory: /home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/cmake-3.12.1

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
    set(CMAKE_INSTALL_CONFIG_NAME "")
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
  set(CMAKE_CROSSCOMPILING "FALSE")
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/doc/cmake-3.12" TYPE FILE FILES "/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/cmake-3.12.1/Copyright.txt")
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/cmake-3.12" TYPE DIRECTORY PERMISSIONS OWNER_READ OWNER_WRITE GROUP_READ WORLD_READ DIR_PERMISSIONS OWNER_READ OWNER_EXECUTE OWNER_WRITE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE FILES
    "/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/cmake-3.12.1/Help"
    "/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/cmake-3.12.1/Modules"
    "/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/cmake-3.12.1/Templates"
    REGEX "/[^/]*\\.sh[^/]*$" PERMISSIONS OWNER_READ OWNER_EXECUTE OWNER_WRITE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE REGEX "Help/dev($|/)" EXCLUDE)
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for each subdirectory.
  include("/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/cmake-3.12.1/.x86_64-pc-linux-gnu/Source/kwsys/cmake_install.cmake")
  include("/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/cmake-3.12.1/.x86_64-pc-linux-gnu/Utilities/KWIML/cmake_install.cmake")
  include("/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/cmake-3.12.1/.x86_64-pc-linux-gnu/Utilities/cmlibrhash/cmake_install.cmake")
  include("/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/cmake-3.12.1/.x86_64-pc-linux-gnu/Utilities/cmzlib/cmake_install.cmake")
  include("/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/cmake-3.12.1/.x86_64-pc-linux-gnu/Utilities/cmcurl/cmake_install.cmake")
  include("/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/cmake-3.12.1/.x86_64-pc-linux-gnu/Utilities/cmcompress/cmake_install.cmake")
  include("/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/cmake-3.12.1/.x86_64-pc-linux-gnu/Utilities/cmexpat/cmake_install.cmake")
  include("/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/cmake-3.12.1/.x86_64-pc-linux-gnu/Utilities/cmbzip2/cmake_install.cmake")
  include("/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/cmake-3.12.1/.x86_64-pc-linux-gnu/Utilities/cmliblzma/cmake_install.cmake")
  include("/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/cmake-3.12.1/.x86_64-pc-linux-gnu/Utilities/cmlibarchive/cmake_install.cmake")
  include("/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/cmake-3.12.1/.x86_64-pc-linux-gnu/Utilities/cmjsoncpp/cmake_install.cmake")
  include("/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/cmake-3.12.1/.x86_64-pc-linux-gnu/Utilities/cmlibuv/cmake_install.cmake")
  include("/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/cmake-3.12.1/.x86_64-pc-linux-gnu/Source/cmake_install.cmake")
  include("/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/cmake-3.12.1/.x86_64-pc-linux-gnu/Utilities/cmake_install.cmake")
  include("/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/cmake-3.12.1/.x86_64-pc-linux-gnu/Tests/cmake_install.cmake")
  include("/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/cmake-3.12.1/.x86_64-pc-linux-gnu/Auxiliary/cmake_install.cmake")

endif()

if(CMAKE_INSTALL_COMPONENT)
  set(CMAKE_INSTALL_MANIFEST "install_manifest_${CMAKE_INSTALL_COMPONENT}.txt")
else()
  set(CMAKE_INSTALL_MANIFEST "install_manifest.txt")
endif()

string(REPLACE ";" "\n" CMAKE_INSTALL_MANIFEST_CONTENT
       "${CMAKE_INSTALL_MANIFEST_FILES}")
file(WRITE "/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/cmake-3.12.1/.x86_64-pc-linux-gnu/${CMAKE_INSTALL_MANIFEST}"
     "${CMAKE_INSTALL_MANIFEST_CONTENT}")
