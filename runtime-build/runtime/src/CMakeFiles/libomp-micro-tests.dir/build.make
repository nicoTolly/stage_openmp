# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.2

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
CMAKE_COMMAND = /usr/bin/cmake

# The command to remove a file.
RM = /usr/bin/cmake -E remove -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /home/nico/stage/llvm/projects/openmp

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /home/nico/stage/runtime-build

# Utility rule file for libomp-micro-tests.

# Include the progress variables for this target.
include runtime/src/CMakeFiles/libomp-micro-tests.dir/progress.make

libomp-micro-tests: runtime/src/CMakeFiles/libomp-micro-tests.dir/build.make
.PHONY : libomp-micro-tests

# Rule to build all files generated by this target.
runtime/src/CMakeFiles/libomp-micro-tests.dir/build: libomp-micro-tests
.PHONY : runtime/src/CMakeFiles/libomp-micro-tests.dir/build

runtime/src/CMakeFiles/libomp-micro-tests.dir/clean:
	cd /home/nico/stage/runtime-build/runtime/src && $(CMAKE_COMMAND) -P CMakeFiles/libomp-micro-tests.dir/cmake_clean.cmake
.PHONY : runtime/src/CMakeFiles/libomp-micro-tests.dir/clean

runtime/src/CMakeFiles/libomp-micro-tests.dir/depend:
	cd /home/nico/stage/runtime-build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/nico/stage/llvm/projects/openmp /home/nico/stage/llvm/projects/openmp/runtime/src /home/nico/stage/runtime-build /home/nico/stage/runtime-build/runtime/src /home/nico/stage/runtime-build/runtime/src/CMakeFiles/libomp-micro-tests.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : runtime/src/CMakeFiles/libomp-micro-tests.dir/depend
