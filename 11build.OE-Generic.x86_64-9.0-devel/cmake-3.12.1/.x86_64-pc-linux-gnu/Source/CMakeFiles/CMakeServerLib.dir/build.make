# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.12

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:


#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:


# Remove some rules from gmake that .SUFFIXES does not remove.
SUFFIXES =

.SUFFIXES: .hpux_make_needs_suffix_list


# Suppress display of executed commands.
$(VERBOSE).SILENT:


# A target that is always out of date.
cmake_force:

.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/cmake-3.12.1/.x86_64-pc-linux-gnu/Bootstrap.cmk/cmake

# The command to remove a file.
RM = /home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/cmake-3.12.1/.x86_64-pc-linux-gnu/Bootstrap.cmk/cmake -E remove -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/cmake-3.12.1

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/cmake-3.12.1/.x86_64-pc-linux-gnu

# Include any dependencies generated for this target.
include Source/CMakeFiles/CMakeServerLib.dir/depend.make

# Include the progress variables for this target.
include Source/CMakeFiles/CMakeServerLib.dir/progress.make

# Include the compile flags for this target's objects.
include Source/CMakeFiles/CMakeServerLib.dir/flags.make

Source/CMakeFiles/CMakeServerLib.dir/cmConnection.cxx.o: Source/CMakeFiles/CMakeServerLib.dir/flags.make
Source/CMakeFiles/CMakeServerLib.dir/cmConnection.cxx.o: ../Source/cmConnection.cxx
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/cmake-3.12.1/.x86_64-pc-linux-gnu/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object Source/CMakeFiles/CMakeServerLib.dir/cmConnection.cxx.o"
	cd /home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/cmake-3.12.1/.x86_64-pc-linux-gnu/Source && /home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/toolchain/bin/host-g++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/CMakeServerLib.dir/cmConnection.cxx.o -c /home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/cmake-3.12.1/Source/cmConnection.cxx

Source/CMakeFiles/CMakeServerLib.dir/cmConnection.cxx.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/CMakeServerLib.dir/cmConnection.cxx.i"
	cd /home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/cmake-3.12.1/.x86_64-pc-linux-gnu/Source && /home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/toolchain/bin/host-g++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/cmake-3.12.1/Source/cmConnection.cxx > CMakeFiles/CMakeServerLib.dir/cmConnection.cxx.i

Source/CMakeFiles/CMakeServerLib.dir/cmConnection.cxx.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/CMakeServerLib.dir/cmConnection.cxx.s"
	cd /home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/cmake-3.12.1/.x86_64-pc-linux-gnu/Source && /home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/toolchain/bin/host-g++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/cmake-3.12.1/Source/cmConnection.cxx -o CMakeFiles/CMakeServerLib.dir/cmConnection.cxx.s

Source/CMakeFiles/CMakeServerLib.dir/cmFileMonitor.cxx.o: Source/CMakeFiles/CMakeServerLib.dir/flags.make
Source/CMakeFiles/CMakeServerLib.dir/cmFileMonitor.cxx.o: ../Source/cmFileMonitor.cxx
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/cmake-3.12.1/.x86_64-pc-linux-gnu/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Building CXX object Source/CMakeFiles/CMakeServerLib.dir/cmFileMonitor.cxx.o"
	cd /home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/cmake-3.12.1/.x86_64-pc-linux-gnu/Source && /home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/toolchain/bin/host-g++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/CMakeServerLib.dir/cmFileMonitor.cxx.o -c /home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/cmake-3.12.1/Source/cmFileMonitor.cxx

Source/CMakeFiles/CMakeServerLib.dir/cmFileMonitor.cxx.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/CMakeServerLib.dir/cmFileMonitor.cxx.i"
	cd /home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/cmake-3.12.1/.x86_64-pc-linux-gnu/Source && /home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/toolchain/bin/host-g++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/cmake-3.12.1/Source/cmFileMonitor.cxx > CMakeFiles/CMakeServerLib.dir/cmFileMonitor.cxx.i

Source/CMakeFiles/CMakeServerLib.dir/cmFileMonitor.cxx.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/CMakeServerLib.dir/cmFileMonitor.cxx.s"
	cd /home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/cmake-3.12.1/.x86_64-pc-linux-gnu/Source && /home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/toolchain/bin/host-g++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/cmake-3.12.1/Source/cmFileMonitor.cxx -o CMakeFiles/CMakeServerLib.dir/cmFileMonitor.cxx.s

Source/CMakeFiles/CMakeServerLib.dir/cmPipeConnection.cxx.o: Source/CMakeFiles/CMakeServerLib.dir/flags.make
Source/CMakeFiles/CMakeServerLib.dir/cmPipeConnection.cxx.o: ../Source/cmPipeConnection.cxx
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/cmake-3.12.1/.x86_64-pc-linux-gnu/CMakeFiles --progress-num=$(CMAKE_PROGRESS_3) "Building CXX object Source/CMakeFiles/CMakeServerLib.dir/cmPipeConnection.cxx.o"
	cd /home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/cmake-3.12.1/.x86_64-pc-linux-gnu/Source && /home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/toolchain/bin/host-g++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/CMakeServerLib.dir/cmPipeConnection.cxx.o -c /home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/cmake-3.12.1/Source/cmPipeConnection.cxx

Source/CMakeFiles/CMakeServerLib.dir/cmPipeConnection.cxx.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/CMakeServerLib.dir/cmPipeConnection.cxx.i"
	cd /home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/cmake-3.12.1/.x86_64-pc-linux-gnu/Source && /home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/toolchain/bin/host-g++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/cmake-3.12.1/Source/cmPipeConnection.cxx > CMakeFiles/CMakeServerLib.dir/cmPipeConnection.cxx.i

Source/CMakeFiles/CMakeServerLib.dir/cmPipeConnection.cxx.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/CMakeServerLib.dir/cmPipeConnection.cxx.s"
	cd /home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/cmake-3.12.1/.x86_64-pc-linux-gnu/Source && /home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/toolchain/bin/host-g++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/cmake-3.12.1/Source/cmPipeConnection.cxx -o CMakeFiles/CMakeServerLib.dir/cmPipeConnection.cxx.s

Source/CMakeFiles/CMakeServerLib.dir/cmServer.cxx.o: Source/CMakeFiles/CMakeServerLib.dir/flags.make
Source/CMakeFiles/CMakeServerLib.dir/cmServer.cxx.o: ../Source/cmServer.cxx
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/cmake-3.12.1/.x86_64-pc-linux-gnu/CMakeFiles --progress-num=$(CMAKE_PROGRESS_4) "Building CXX object Source/CMakeFiles/CMakeServerLib.dir/cmServer.cxx.o"
	cd /home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/cmake-3.12.1/.x86_64-pc-linux-gnu/Source && /home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/toolchain/bin/host-g++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/CMakeServerLib.dir/cmServer.cxx.o -c /home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/cmake-3.12.1/Source/cmServer.cxx

Source/CMakeFiles/CMakeServerLib.dir/cmServer.cxx.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/CMakeServerLib.dir/cmServer.cxx.i"
	cd /home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/cmake-3.12.1/.x86_64-pc-linux-gnu/Source && /home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/toolchain/bin/host-g++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/cmake-3.12.1/Source/cmServer.cxx > CMakeFiles/CMakeServerLib.dir/cmServer.cxx.i

Source/CMakeFiles/CMakeServerLib.dir/cmServer.cxx.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/CMakeServerLib.dir/cmServer.cxx.s"
	cd /home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/cmake-3.12.1/.x86_64-pc-linux-gnu/Source && /home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/toolchain/bin/host-g++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/cmake-3.12.1/Source/cmServer.cxx -o CMakeFiles/CMakeServerLib.dir/cmServer.cxx.s

Source/CMakeFiles/CMakeServerLib.dir/cmServerConnection.cxx.o: Source/CMakeFiles/CMakeServerLib.dir/flags.make
Source/CMakeFiles/CMakeServerLib.dir/cmServerConnection.cxx.o: ../Source/cmServerConnection.cxx
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/cmake-3.12.1/.x86_64-pc-linux-gnu/CMakeFiles --progress-num=$(CMAKE_PROGRESS_5) "Building CXX object Source/CMakeFiles/CMakeServerLib.dir/cmServerConnection.cxx.o"
	cd /home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/cmake-3.12.1/.x86_64-pc-linux-gnu/Source && /home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/toolchain/bin/host-g++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/CMakeServerLib.dir/cmServerConnection.cxx.o -c /home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/cmake-3.12.1/Source/cmServerConnection.cxx

Source/CMakeFiles/CMakeServerLib.dir/cmServerConnection.cxx.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/CMakeServerLib.dir/cmServerConnection.cxx.i"
	cd /home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/cmake-3.12.1/.x86_64-pc-linux-gnu/Source && /home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/toolchain/bin/host-g++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/cmake-3.12.1/Source/cmServerConnection.cxx > CMakeFiles/CMakeServerLib.dir/cmServerConnection.cxx.i

Source/CMakeFiles/CMakeServerLib.dir/cmServerConnection.cxx.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/CMakeServerLib.dir/cmServerConnection.cxx.s"
	cd /home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/cmake-3.12.1/.x86_64-pc-linux-gnu/Source && /home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/toolchain/bin/host-g++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/cmake-3.12.1/Source/cmServerConnection.cxx -o CMakeFiles/CMakeServerLib.dir/cmServerConnection.cxx.s

Source/CMakeFiles/CMakeServerLib.dir/cmServerProtocol.cxx.o: Source/CMakeFiles/CMakeServerLib.dir/flags.make
Source/CMakeFiles/CMakeServerLib.dir/cmServerProtocol.cxx.o: ../Source/cmServerProtocol.cxx
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/cmake-3.12.1/.x86_64-pc-linux-gnu/CMakeFiles --progress-num=$(CMAKE_PROGRESS_6) "Building CXX object Source/CMakeFiles/CMakeServerLib.dir/cmServerProtocol.cxx.o"
	cd /home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/cmake-3.12.1/.x86_64-pc-linux-gnu/Source && /home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/toolchain/bin/host-g++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/CMakeServerLib.dir/cmServerProtocol.cxx.o -c /home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/cmake-3.12.1/Source/cmServerProtocol.cxx

Source/CMakeFiles/CMakeServerLib.dir/cmServerProtocol.cxx.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/CMakeServerLib.dir/cmServerProtocol.cxx.i"
	cd /home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/cmake-3.12.1/.x86_64-pc-linux-gnu/Source && /home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/toolchain/bin/host-g++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/cmake-3.12.1/Source/cmServerProtocol.cxx > CMakeFiles/CMakeServerLib.dir/cmServerProtocol.cxx.i

Source/CMakeFiles/CMakeServerLib.dir/cmServerProtocol.cxx.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/CMakeServerLib.dir/cmServerProtocol.cxx.s"
	cd /home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/cmake-3.12.1/.x86_64-pc-linux-gnu/Source && /home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/toolchain/bin/host-g++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/cmake-3.12.1/Source/cmServerProtocol.cxx -o CMakeFiles/CMakeServerLib.dir/cmServerProtocol.cxx.s

# Object files for target CMakeServerLib
CMakeServerLib_OBJECTS = \
"CMakeFiles/CMakeServerLib.dir/cmConnection.cxx.o" \
"CMakeFiles/CMakeServerLib.dir/cmFileMonitor.cxx.o" \
"CMakeFiles/CMakeServerLib.dir/cmPipeConnection.cxx.o" \
"CMakeFiles/CMakeServerLib.dir/cmServer.cxx.o" \
"CMakeFiles/CMakeServerLib.dir/cmServerConnection.cxx.o" \
"CMakeFiles/CMakeServerLib.dir/cmServerProtocol.cxx.o"

# External object files for target CMakeServerLib
CMakeServerLib_EXTERNAL_OBJECTS =

Source/libCMakeServerLib.a: Source/CMakeFiles/CMakeServerLib.dir/cmConnection.cxx.o
Source/libCMakeServerLib.a: Source/CMakeFiles/CMakeServerLib.dir/cmFileMonitor.cxx.o
Source/libCMakeServerLib.a: Source/CMakeFiles/CMakeServerLib.dir/cmPipeConnection.cxx.o
Source/libCMakeServerLib.a: Source/CMakeFiles/CMakeServerLib.dir/cmServer.cxx.o
Source/libCMakeServerLib.a: Source/CMakeFiles/CMakeServerLib.dir/cmServerConnection.cxx.o
Source/libCMakeServerLib.a: Source/CMakeFiles/CMakeServerLib.dir/cmServerProtocol.cxx.o
Source/libCMakeServerLib.a: Source/CMakeFiles/CMakeServerLib.dir/build.make
Source/libCMakeServerLib.a: Source/CMakeFiles/CMakeServerLib.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/cmake-3.12.1/.x86_64-pc-linux-gnu/CMakeFiles --progress-num=$(CMAKE_PROGRESS_7) "Linking CXX static library libCMakeServerLib.a"
	cd /home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/cmake-3.12.1/.x86_64-pc-linux-gnu/Source && $(CMAKE_COMMAND) -P CMakeFiles/CMakeServerLib.dir/cmake_clean_target.cmake
	cd /home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/cmake-3.12.1/.x86_64-pc-linux-gnu/Source && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/CMakeServerLib.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
Source/CMakeFiles/CMakeServerLib.dir/build: Source/libCMakeServerLib.a

.PHONY : Source/CMakeFiles/CMakeServerLib.dir/build

Source/CMakeFiles/CMakeServerLib.dir/clean:
	cd /home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/cmake-3.12.1/.x86_64-pc-linux-gnu/Source && $(CMAKE_COMMAND) -P CMakeFiles/CMakeServerLib.dir/cmake_clean.cmake
.PHONY : Source/CMakeFiles/CMakeServerLib.dir/clean

Source/CMakeFiles/CMakeServerLib.dir/depend:
	cd /home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/cmake-3.12.1/.x86_64-pc-linux-gnu && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/cmake-3.12.1 /home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/cmake-3.12.1/Source /home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/cmake-3.12.1/.x86_64-pc-linux-gnu /home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/cmake-3.12.1/.x86_64-pc-linux-gnu/Source /home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/cmake-3.12.1/.x86_64-pc-linux-gnu/Source/CMakeFiles/CMakeServerLib.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : Source/CMakeFiles/CMakeServerLib.dir/depend

