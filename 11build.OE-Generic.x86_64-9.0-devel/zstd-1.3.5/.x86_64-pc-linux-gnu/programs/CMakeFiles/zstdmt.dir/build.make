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
CMAKE_COMMAND = /home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/toolchain/bin/cmake

# The command to remove a file.
RM = /home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/toolchain/bin/cmake -E remove -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/zstd-1.3.5/build/cmake

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/zstd-1.3.5/.x86_64-pc-linux-gnu

# Utility rule file for zstdmt.

# Include the progress variables for this target.
include programs/CMakeFiles/zstdmt.dir/progress.make

programs/CMakeFiles/zstdmt: programs/zstd
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --blue --bold --progress-dir=/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/zstd-1.3.5/.x86_64-pc-linux-gnu/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Creating zstdmt symlink"
	cd /home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/zstd-1.3.5/.x86_64-pc-linux-gnu/programs && /home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/toolchain/bin/cmake -E create_symlink zstd zstdmt

zstdmt: programs/CMakeFiles/zstdmt
zstdmt: programs/CMakeFiles/zstdmt.dir/build.make

.PHONY : zstdmt

# Rule to build all files generated by this target.
programs/CMakeFiles/zstdmt.dir/build: zstdmt

.PHONY : programs/CMakeFiles/zstdmt.dir/build

programs/CMakeFiles/zstdmt.dir/clean:
	cd /home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/zstd-1.3.5/.x86_64-pc-linux-gnu/programs && $(CMAKE_COMMAND) -P CMakeFiles/zstdmt.dir/cmake_clean.cmake
.PHONY : programs/CMakeFiles/zstdmt.dir/clean

programs/CMakeFiles/zstdmt.dir/depend:
	cd /home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/zstd-1.3.5/.x86_64-pc-linux-gnu && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/zstd-1.3.5/build/cmake /home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/zstd-1.3.5/build/cmake/programs /home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/zstd-1.3.5/.x86_64-pc-linux-gnu /home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/zstd-1.3.5/.x86_64-pc-linux-gnu/programs /home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/zstd-1.3.5/.x86_64-pc-linux-gnu/programs/CMakeFiles/zstdmt.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : programs/CMakeFiles/zstdmt.dir/depend

