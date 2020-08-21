# Basic CMake configuration
CMAKE_MINIMUM_REQUIRED (VERSION 3.6)
SET(PROJECT_DIR_PATH ${CMAKE_CURRENT_SOURCE_DIR})

get_filename_component(CURR_PROJECT_NAME ${CMAKE_CURRENT_SOURCE_DIR} NAME)
string(REPLACE "fw-" "" CURR_PROJECT_NAME ${CURR_PROJECT_NAME})
project(${CURR_PROJECT_NAME} C ASM)

set(MK64F_LINKER_SCRIPT ${PROJECT_DIR_PATH}/linker/K64FN1M0xxx12.ld)

# Load files for the application and compile
include_directories(${PROJECT_DIR_PATH}/src)
file(GLOB_RECURSE APP_SRC_FILES "src/*.c")

# Add specific compiler flags
add_executable(${PROJECT_NAME} ${APP_SRC_FILES})
generateVersionHeader(${PROJECT_DIR_PATH}/VERSION ${PROJECT_DIR_PATH}/src/version.h.in)

