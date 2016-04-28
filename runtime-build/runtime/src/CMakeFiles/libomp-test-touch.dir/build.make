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

# Utility rule file for libomp-test-touch.

# Include the progress variables for this target.
include runtime/src/CMakeFiles/libomp-test-touch.dir/progress.make

runtime/src/CMakeFiles/libomp-test-touch: runtime/src/test-touch-rt/.success

runtime/src/test-touch-rt/.success: /home/nico/stage/llvm/projects/openmp/runtime/src/test-touch.c
runtime/src/test-touch-rt/.success: runtime/src/libomp.so
	$(CMAKE_COMMAND) -E cmake_progress_report /home/nico/stage/runtime-build/CMakeFiles $(CMAKE_PROGRESS_1)
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --blue --bold "Generating test-touch-rt/.success, test-touch-rt/test-touch, test-touch-rt/test-touch.o"
	cd /home/nico/stage/runtime-build/runtime/src && /usr/bin/cmake -E make_directory /home/nico/stage/runtime-build/runtime/src/test-touch-rt
	cd /home/nico/stage/runtime-build/runtime/src && /usr/bin/cmake -E remove -f test-touch-rt/*
	cd /home/nico/stage/runtime-build/runtime/src && /usr/bin/gcc -o test-touch-rt/test-touch /home/nico/stage/llvm/projects/openmp/runtime/src/test-touch.c -Wl,-rpath=/usr/local/lib -lpthread /home/nico/stage/runtime-build/runtime/src/libomp.so /usr/local/lib/libhwloc.so
	cd /home/nico/stage/runtime-build/runtime/src && /bin/sh -c "LD_LIBRARY_PATH=.:/home/nico/stage/runtime-build/runtime/src: KMP_VERSION=1 test-touch-rt/test-touch"
	cd /home/nico/stage/runtime-build/runtime/src && /usr/bin/cmake -E touch test-touch-rt/.success

runtime/src/test-touch-rt/test-touch: runtime/src/test-touch-rt/.success
	@$(CMAKE_COMMAND) -E touch_nocreate runtime/src/test-touch-rt/test-touch

runtime/src/test-touch-rt/test-touch.o: runtime/src/test-touch-rt/.success
	@$(CMAKE_COMMAND) -E touch_nocreate runtime/src/test-touch-rt/test-touch.o

libomp-test-touch: runtime/src/CMakeFiles/libomp-test-touch
libomp-test-touch: runtime/src/test-touch-rt/.success
libomp-test-touch: runtime/src/test-touch-rt/test-touch
libomp-test-touch: runtime/src/test-touch-rt/test-touch.o
libomp-test-touch: runtime/src/CMakeFiles/libomp-test-touch.dir/build.make
.PHONY : libomp-test-touch

# Rule to build all files generated by this target.
runtime/src/CMakeFiles/libomp-test-touch.dir/build: libomp-test-touch
.PHONY : runtime/src/CMakeFiles/libomp-test-touch.dir/build

runtime/src/CMakeFiles/libomp-test-touch.dir/clean:
	cd /home/nico/stage/runtime-build/runtime/src && $(CMAKE_COMMAND) -P CMakeFiles/libomp-test-touch.dir/cmake_clean.cmake
.PHONY : runtime/src/CMakeFiles/libomp-test-touch.dir/clean

runtime/src/CMakeFiles/libomp-test-touch.dir/depend:
	cd /home/nico/stage/runtime-build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/nico/stage/llvm/projects/openmp /home/nico/stage/llvm/projects/openmp/runtime/src /home/nico/stage/runtime-build /home/nico/stage/runtime-build/runtime/src /home/nico/stage/runtime-build/runtime/src/CMakeFiles/libomp-test-touch.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : runtime/src/CMakeFiles/libomp-test-touch.dir/depend

