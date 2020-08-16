# Basic CMake configuration
CMAKE_MINIMUM_REQUIRED (VERSION 3.6)
SET(PROJECT_DIR_PATH ${CMAKE_CURRENT_SOURCE_DIR})
project(bootloader-secure C ASM)


set(NRF5_LINKER_SCRIPT ${PROJECT_DIR_PATH}/linker/bootloader_gcc_nrf52.ld)
nRF5x_setup()
nRF5x_addDFUDefinitions()

# Enable all the required libraries
nRF5x_addAppScheduler()
nRF5x_addAppUART()
nRF5x_addExternalProtobuf()
nRF5x_addCrypto()
nRF5X_addDFU()
nRF5x_addFStorage()
nRF5x_loadDFULibraries()

# Load files for the application and compile
include_directories(${PROJECT_DIR_PATH}/src)
file(GLOB_RECURSE BOOT_SRC_FILES "src/*.c")
list(APPEND BOOT_SRC_FILES "${NRF5_VAULT_PATH}/sample_public.c")

# Add specific compiler flags
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Os")
nRF5x_addExecutable(bootloader-secure "${BOOT_SRC_FILES}" m)