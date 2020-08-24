
# CROSS COMPILER SETTING
CMAKE_MINIMUM_REQUIRED (VERSION 3.6)
SET(PROJECT_DIR_PATH ${CMAKE_CURRENT_SOURCE_DIR})

# Set Project Name (Folder name without fw-)
get_filename_component(CURR_PROJECT_NAME ${CMAKE_CURRENT_SOURCE_DIR} NAME)
string(REPLACE "fw-" "" CURR_PROJECT_NAME ${CURR_PROJECT_NAME})
project(${CURR_PROJECT_NAME} C ASM)

# Configure Linker
set(K64F_LINKER_SCRIPT ${PROJECT_DIR_PATH}/linker/MK64FN1M0xxx12_flash.ld)

# Barebone Setup
k64f_setup()

# Enable required libraries/addons
# k64f_()
# k64f_()
#.....

# Application Directories 
include_directories(${ProjDirPath}/src)
include_directories(${ProjDirPath}/src/board)
include_directories(${ProjDirPath}/src/device)
# Application Files 
file(GLOB_RECURSE APP_SRC_FILES "${ProjDirPath}/src/*.c" "${ProjDirPath}/src/*.h")

# Add specific compiler flags
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -O3")
generateVersionHeader(${PROJECT_DIR_PATH}/VERSION ${PROJECT_DIR_PATH}/src/version.h.in)
nRF5x_addExecutable(${CURR_PROJECT_NAME} "${APP_SRC_FILES}" m)
nRF5x_packageFirmware(${CURR_PROJECT_NAME} sample "0xB6")
