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
include Tests/RunCMake/CMakeFiles/pseudo_cpplint.dir/depend.make

# Include the progress variables for this target.
include Tests/RunCMake/CMakeFiles/pseudo_cpplint.dir/progress.make

# Include the compile flags for this target's objects.
include Tests/RunCMake/CMakeFiles/pseudo_cpplint.dir/flags.make

Tests/RunCMake/CMakeFiles/pseudo_cpplint.dir/pseudo_cpplint.c.o: Tests/RunCMake/CMakeFiles/pseudo_cpplint.dir/flags.make
Tests/RunCMake/CMakeFiles/pseudo_cpplint.dir/pseudo_cpplint.c.o: ../Tests/RunCMake/pseudo_cpplint.c
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/cmake-3.12.1/.x86_64-pc-linux-gnu/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building C object Tests/RunCMake/CMakeFiles/pseudo_cpplint.dir/pseudo_cpplint.c.o"
	cd /home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/cmake-3.12.1/.x86_64-pc-linux-gnu/Tests/RunCMake && /home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/toolchain/bin/host-gcc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -o CMakeFiles/pseudo_cpplint.dir/pseudo_cpplint.c.o   -c /home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/cmake-3.12.1/Tests/RunCMake/pseudo_cpplint.c

Tests/RunCMake/CMakeFiles/pseudo_cpplint.dir/pseudo_cpplint.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/pseudo_cpplint.dir/pseudo_cpplint.c.i"
	cd /home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/cmake-3.12.1/.x86_64-pc-linux-gnu/Tests/RunCMake && /home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/toolchain/bin/host-gcc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -E /home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/cmake-3.12.1/Tests/RunCMake/pseudo_cpplint.c > CMakeFiles/pseudo_cpplint.dir/pseudo_cpplint.c.i

Tests/RunCMake/CMakeFiles/pseudo_cpplint.dir/pseudo_cpplint.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/pseudo_cpplint.dir/pseudo_cpplint.c.s"
	cd /home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/cmake-3.12.1/.x86_64-pc-linux-gnu/Tests/RunCMake && /home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/toolchain/bin/host-gcc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -S /home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/cmake-3.12.1/Tests/RunCMake/pseudo_cpplint.c -o CMakeFiles/pseudo_cpplint.dir/pseudo_cpplint.c.s

# Object files for target pseudo_cpplint
pseudo_cpplint_OBJECTS = \
"CMakeFiles/pseudo_cpplint.dir/pseudo_cpplint.c.o"

# External object files for target pseudo_cpplint
pseudo_cpplint_EXTERNAL_OBJECTS =

Tests/RunCMake/pseudo_cpplint: Tests/RunCMake/CMakeFiles/pseudo_cpplint.dir/pseudo_cpplint.c.o
Tests/RunCMake/pseudo_cpplint: Tests/RunCMake/CMakeFiles/pseudo_cpplint.dir/build.make
Tests/RunCMake/pseudo_cpplint: Tests/RunCMake/CMakeFiles/pseudo_cpplint.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/cmake-3.12.1/.x86_64-pc-linux-gnu/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Linking C executable pseudo_cpplint"
	cd /home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/cmake-3.12.1/.x86_64-pc-linux-gnu/Tests/RunCMake && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/pseudo_cpplint.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
Tests/RunCMake/CMakeFiles/pseudo_cpplint.dir/build: Tests/RunCMake/pseudo_cpplint

.PHONY : Tests/RunCMake/CMakeFiles/pseudo_cpplint.dir/build

Tests/RunCMake/CMakeFiles/pseudo_cpplint.dir/clean:
	cd /home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/cmake-3.12.1/.x86_64-pc-linux-gnu/Tests/RunCMake && $(CMAKE_COMMAND) -P CMakeFiles/pseudo_cpplint.dir/cmake_clean.cmake
.PHONY : Tests/RunCMake/CMakeFiles/pseudo_cpplint.dir/clean

Tests/RunCMake/CMakeFiles/pseudo_cpplint.dir/depend:
	cd /home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/cmake-3.12.1/.x86_64-pc-linux-gnu && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/cmake-3.12.1 /home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/cmake-3.12.1/Tests/RunCMake /home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/cmake-3.12.1/.x86_64-pc-linux-gnu /home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/cmake-3.12.1/.x86_64-pc-linux-gnu/Tests/RunCMake /home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/cmake-3.12.1/.x86_64-pc-linux-gnu/Tests/RunCMake/CMakeFiles/pseudo_cpplint.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : Tests/RunCMake/CMakeFiles/pseudo_cpplint.dir/depend

