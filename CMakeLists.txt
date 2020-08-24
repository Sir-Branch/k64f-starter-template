# Basic CMake configuration
CMAKE_MINIMUM_REQUIRED (VERSION 3.6)
SET(PROJECT_ROOT_DIR_PATH ${CMAKE_CURRENT_SOURCE_DIR})
OPTION(DEFINE_DEBUG "Build the project using debugging code" OFF)

# Configure the GCC toolchain.
INCLUDE(${CMAKE_CURRENT_SOURCE_DIR}/sdk_cmake/armgcc.cmake)
# set(MK64F_LINKER_SCRIPT ${PROJECT_DIR_PATH}/linker/K64FN1M0xxx12.ld)

IF(NOT DEFINED FIRMWARE_TARGET)
    message(FATAL_ERROR "FIRMWARE_TARGET NOT DEFINED")
ENDIF()


# !Set in gcc probably best to override with the ones belows
SET(EXECUTABLE_OUTPUT_PATH ${CMAKE_CURRENT_SOURCE_DIR}/bin/${FIRMWARE_TARGET})
SET(LIBRARY_OUTPUT_PATH ${CMAKE_CURRENT_SOURCE_DIR}/bin/${FIRMWARE_TARGET})
#IMPORTANT NOT MARIO KART 64 D:
project(MK64F_TEMPLATE C ASM)

# Configure the Nordic SDK
set(K64F_SDK_PATH "${CMAKE_CURRENT_SOURCE_DIR}/sdk_K64F")
INCLUDE(${CMAKE_CURRENT_SOURCE_DIR}/sdk_cmake/configure_nxp_sdk.cmake)

# Load all the relevant git repository information.
INCLUDE(${CMAKE_CURRENT_SOURCE_DIR}/sdk_cmake/configure_versions.cmake)

if(NOT DEFINED DEBUG_MODE)
    MESSAGE(STATUS "DEBUG MODE ENABLED")
    ADD_DEFINITIONS(-DDEBUG)
else()
    MESSAGE(STATUS "DEBUG MODE DISABLED")
endif()

add_subdirectory(fw-${FIRMWARE_TARGET})
