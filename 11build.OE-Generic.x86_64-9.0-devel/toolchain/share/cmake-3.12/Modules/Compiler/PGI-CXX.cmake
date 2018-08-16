include(Compiler/PGI)
__compiler_pgi(CXX)
string(APPEND CMAKE_CXX_FLAGS_MINSIZEREL_INIT " -DNDEBUG")
string(APPEND CMAKE_CXX_FLAGS_RELEASE_INIT " -DNDEBUG")

if(CMAKE_CXX_COMPILER_VERSION VERSION_GREATER_EQUAL 12.10)
  set(CMAKE_CXX98_STANDARD_COMPILE_OPTION  -A)
  set(CMAKE_CXX98_EXTENSION_COMPILE_OPTION --gnu_extensions)
  if(CMAKE_CXX_COMPILER_VERSION VERSION_GREATER_EQUAL 13.10)
    set(CMAKE_CXX11_STANDARD_COMPILE_OPTION  --c++11 -A)
    set(CMAKE_CXX11_EXTENSION_COMPILE_OPTION --c++11 --gnu_extensions)
    if(CMAKE_CXX_COMPILER_VERSION VERSION_GREATER_EQUAL 15.7)
      set(CMAKE_CXX14_STANDARD_COMPILE_OPTION  --c++14 -A)
      set(CMAKE_CXX14_EXTENSION_COMPILE_OPTION --c++14 --gnu_extensions)
      if(CMAKE_CXX_COMPILER_VERSION VERSION_GREATER_EQUAL 17.1)
        set(CMAKE_CXX17_STANDARD_COMPILE_OPTION  --c++17 -A)
        set(CMAKE_CXX17_EXTENSION_COMPILE_OPTION --c++17 --gnu_extensions)
      endif()
    endif()
  endif()
endif()

__compiler_check_default_language_standard(CXX 12.10 98)
