cmake_minimum_required(VERSION 3.13.4)
project(Alibaba-Cloud-Compiler-test-suite LANGUAGES C CXX)
add_subdirectory(fuzz)

set(OPTFLAGS "${OPTFLAGS}")
set(CMAKE_C_FLAGS_RELEASE "${OPTFLAGS}" CACHE STRING "")
set(CMAKE_CXX_FLAGS_RELEASE "${OPTFLAGS}" CACHE STRING "")
set(CMAKE_BUILD_TYPE "Release" CACHE STRING "")

