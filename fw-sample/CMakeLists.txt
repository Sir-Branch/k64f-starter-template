# Basic CMake configuration
CMAKE_MINIMUM_REQUIRED (VERSION 3.6)
SET(PROJECT_DIR_PATH ${CMAKE_CURRENT_SOURCE_DIR})

get_filename_component(CURR_PROJECT_NAME ${CMAKE_CURRENT_SOURCE_DIR} NAME)
string(REPLACE "fw-" "" CURR_PROJECT_NAME ${CURR_PROJECT_NAME})
project(${CURR_PROJECT_NAME} C ASM)


set(NRF5_LINKER_SCRIPT ${PROJECT_DIR_PATH}/linker/application_gcc_nrf52.ld)
nRF5x_setup()

# Enable all the required libraries
nRF5x_addLegacyDrivers()
nRF5x_addErrorHandlers()
nRF5x_addAppScheduler()
nRF5x_addAppFIFO()
nRF5x_addAppTimer()
nRF5x_addAppUART()
nRF5x_addAppPWM()
nRF5x_addAppButton()
nRF5x_addBSP(TRUE FALSE FALSE)
nRF5x_addExternalUSB(FALSE TRUE)
nRF5x_addExternalSeggerRTT()
nRF5x_addBLEService(ble_nus)
nRF5x_addBLEService(ble_dis)
nRF5x_addBLEService(ble_bas)
nRF5x_addBLEGATT()

# Load files for the application and compile
include_directories(${PROJECT_DIR_PATH}/src)
file(GLOB_RECURSE APP_SRC_FILES "src/*.c")

# Add specific compiler flags
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -O3")
generateVersionHeader(${PROJECT_DIR_PATH}/VERSION ${PROJECT_DIR_PATH}/src/version.h.in)
nRF5x_addExecutable(${CURR_PROJECT_NAME} "${APP_SRC_FILES}" m)
nRF5x_packageFirmware(${CURR_PROJECT_NAME} sample "0xB6")
