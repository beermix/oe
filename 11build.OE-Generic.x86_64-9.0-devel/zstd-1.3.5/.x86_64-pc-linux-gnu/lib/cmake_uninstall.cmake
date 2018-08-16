 
if(NOT EXISTS "/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/zstd-1.3.5/.x86_64-pc-linux-gnu/install_manifest.txt")
  message(FATAL_ERROR "Cannot find install manifest: /home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/zstd-1.3.5/.x86_64-pc-linux-gnu/install_manifest.txt")
endif(NOT EXISTS "/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/zstd-1.3.5/.x86_64-pc-linux-gnu/install_manifest.txt")

file(READ "/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/zstd-1.3.5/.x86_64-pc-linux-gnu/install_manifest.txt" files)
string(REGEX REPLACE "\n" ";" files "${files}")
foreach(file ${files})
  message(STATUS "Uninstalling $ENV{DESTDIR}${file}")
  if(IS_SYMLINK "$ENV{DESTDIR}${file}" OR EXISTS "$ENV{DESTDIR}${file}")
    exec_program(
      "/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/toolchain/bin/cmake" ARGS "-E remove \"$ENV{DESTDIR}${file}\""
      OUTPUT_VARIABLE rm_out
      RETURN_VALUE rm_retval
      )
    if(NOT "${rm_retval}" STREQUAL 0)
      message(FATAL_ERROR "Problem when removing $ENV{DESTDIR}${file}")
    endif(NOT "${rm_retval}" STREQUAL 0)
  else(IS_SYMLINK "$ENV{DESTDIR}${file}" OR EXISTS "$ENV{DESTDIR}${file}")
    message(STATUS "File $ENV{DESTDIR}${file} does not exist.")
  endif(IS_SYMLINK "$ENV{DESTDIR}${file}" OR EXISTS "$ENV{DESTDIR}${file}")
endforeach(file)
