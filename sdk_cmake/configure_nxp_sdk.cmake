CMAKE_MINIMUM_REQUIRED (VERSION 3.6)

# check if all the necessary tools paths have been provided.
if (NOT K64F_SDK_PATH)
    message(FATAL_ERROR "The path to the K64F SDK (K64F_SDK_PATH) must be set.")
endif ()

macro(k64f_setup)
    # Fix on macOS: prevent cmake from adding implicit parameters to Xcode
    set(CMAKE_OSX_SYSROOT "/")
    set(CMAKE_OSX_DEPLOYMENT_TARGET "")

    # CPU specific settings
    if(NOT DEFINED K64F_LINKER_SCRIPT)
        message(FATAL_ERROR "The linker script path (K64F_LINKER_SCRIPT) must be set.")
    endif()
    
    #CPU specific flags
    set(CPU_FLAGS "-mcpu=cortex-m4 -mfloat-abi=hard -mfpu=fpv4-sp-d16")

    #Common flags
    set(COMMON_FLAGS "-MP -MD -mthumb -mabi=aapcs -Wall -g3 -ffunction-sections -fdata-sections -fno-strict-aliasing -fno-builtin --short-enums ${CPU_FLAGS} ${C_ERRORS}")

    # SDK Directores
    include_directories(${K64F_SDK_PATH}/CMSIS/Include)
    include_directories(${K64F_SDK_PATH}/devices)
    include_directories(${K64F_SDK_PATH}/devices/MK64F12)
    include_directories(${K64F_SDK_PATH}/devices/MK64F12/drivers)
    include_directories(${K64F_SDK_PATH}/devices/MK64F12/utilities/str)
    include_directories(${K64F_SDK_PATH}/devices/MK64F12/utilities/debug_console)
    include_directories(${K64F_SDK_PATH}/components)
    include_directories(${K64F_SDK_PATH}/components/serial_manager)
    include_directories(${K64F_SDK_PATH}/components/uart)
        
endmacro(k64f_setup)

macro(app_setup)

    # Application Directories 
    include_directories(${ProjDirPath}/src)
    include_directories(${ProjDirPath}/src/board)
    include_directories(${ProjDirPath}/src/device)

    #Application Files 
    file(GLOB_RECURSE APP_SRC_FILES "${ProjDirPath}/src/*.c" "${ProjDirPath}/src/*.h")

endmacro(app_setup)

function(k64f_addExecutable EXECUTABLE_NAME SOURCE_FILES)

endfunction()

# *********************************************************

# Add legacy drivers
macro(nRF5x_addExternalSeggerRTT)
    include_directories(
        "${NRF5_SDK_PATH}/external/segger_rtt/"
    )

    list(APPEND SDK_SOURCE_FILES
            "${NRF5_SDK_PATH}/external/segger_rtt/SEGGER_RTT_Syscalls_GCC.c"
            "${NRF5_SDK_PATH}/external/segger_rtt/SEGGER_RTT.c"
            "${NRF5_SDK_PATH}/external/segger_rtt/SEGGER_RTT_printf.c"
        )
endmacro(nRF5x_addExternalSeggerRTT)

# Add legacy drivers
macro(nRF5x_addErrorHandlers)
    list(APPEND SDK_SOURCE_FILES
            "${NRF5_SDK_PATH}/components/libraries/util/app_error.c"
            "${NRF5_SDK_PATH}/components/libraries/util/app_error_handler_gcc.c"
        )
endmacro(nRF5x_addErrorHandlers)

# Add nano protobuff
macro(nRF5x_addExternalProtobuf)
    include_directories(
        "${NRF5_SDK_PATH}/external/nano-pb/"
    )

    list(APPEND SDK_SOURCE_FILES
            "${NRF5_SDK_PATH}/external/nano-pb/pb_common.c"
            "${NRF5_SDK_PATH}/external/nano-pb/pb_encode.c"
            "${NRF5_SDK_PATH}/external/nano-pb/pb_decode.c"
        )

endmacro(nRF5x_addExternalProtobuf)

macro(nRF5x_addFStorage)
    include_directories(
        "${NRF5_SDK_PATH}/components/libraries/fstorage/"
    )

    list(APPEND SDK_SOURCE_FILES
            "${NRF5_SDK_PATH}/components/libraries/fstorage/nrf_fstorage.c"
            "${NRF5_SDK_PATH}/components/libraries/fstorage/nrf_fstorage_nvmc.c"
            "${NRF5_SDK_PATH}/components/libraries/fstorage/nrf_fstorage_sd.c"
        )

endmacro(nRF5x_addFStorage)


# Add legacy drivers
macro(nRF5x_addLegacyDrivers)
    include_directories(
        "${NRF5_SDK_PATH}/integration/nrfx/legacy"
    )

    list(APPEND SDK_SOURCE_FILES
            "${NRF5_SDK_PATH}/integration/nrfx/legacy/nrf_drv_clock.c"
            "${NRF5_SDK_PATH}/integration/nrfx/legacy/nrf_drv_uart.c"
            "${NRF5_SDK_PATH}/integration/nrfx/legacy/nrf_drv_ppi.c"
            "${NRF5_SDK_PATH}/integration/nrfx/legacy/nrf_drv_twi.c"
            "${NRF5_SDK_PATH}/integration/nrfx/legacy/nrf_drv_spi.c"
            "${NRF5_SDK_PATH}/integration/nrfx/legacy/nrf_drv_power.c"
        )

endmacro(nRF5x_addLegacyDrivers)

# adds app-level scheduler library
macro(nRF5x_addAppScheduler)
    include_directories(
            "${NRF5_SDK_PATH}/components/libraries/scheduler"
    )

    list(APPEND SDK_SOURCE_FILES
            "${NRF5_SDK_PATH}/components/libraries/scheduler/app_scheduler.c"
            )

endmacro(nRF5x_addAppScheduler)

# adds app-level FIFO libraries
macro(nRF5x_addAppFIFO)
    include_directories("${NRF5_SDK_PATH}/components/libraries/fifo")
    list(APPEND SDK_SOURCE_FILES "${NRF5_SDK_PATH}/components/libraries/fifo/app_fifo.c")
endmacro(nRF5x_addAppFIFO)

# adds app-level PWM libraries
macro(nRF5x_addAppPWM)
    include_directories("${NRF5_SDK_PATH}/components/libraries/pwm")
    list(APPEND SDK_SOURCE_FILES "${NRF5_SDK_PATH}/components/libraries/pwm/app_pwm.c")
endmacro(nRF5x_addAppPWM)

# adds app-level Timer libraries
macro(nRF5x_addAppTimer)
    list(APPEND SDK_SOURCE_FILES
            "${NRF5_SDK_PATH}/components/libraries/timer/app_timer.c"
            )
endmacro(nRF5x_addAppTimer)

# adds app-level UART libraries
macro(nRF5x_addAppUART)
    include_directories(
            "${NRF5_SDK_PATH}/components/libraries/uart"
    )

    list(APPEND SDK_SOURCE_FILES
            "${NRF5_SDK_PATH}/components/libraries/uart/app_uart_fifo.c"
            )

endmacro(nRF5x_addAppUART)

# adds app-level Button library
macro(k64f_addButton)
    include_directories(
            "${K64F_SDK_PATH}/components/button"
    )

    list(APPEND SDK_SOURCE_FILES
            "${K64F_SDK_PATH}/components/button/button.c"
            )

endmacro(k64f_addButton)

# adds BSP (board support package) library
macro(nRF5x_addBSP WITH_BLE_BTN WITH_ANT_BTN WITH_NFC)
    include_directories(
            "${NRF5_SDK_PATH}/components/libraries/bsp"
    )

    list(APPEND SDK_SOURCE_FILES
            "${NRF5_SDK_PATH}/components/libraries/bsp/bsp.c"
            )

    if (${WITH_BLE_BTN})
        list(APPEND SDK_SOURCE_FILES
                "${NRF5_SDK_PATH}/components/libraries/bsp/bsp_btn_ble.c"
                )
    endif ()

    if (${WITH_ANT_BTN})
        list(APPEND SDK_SOURCE_FILES
                "${NRF5_SDK_PATH}/components/libraries/bsp/bsp_btn_ant.c"
                )
    endif ()

    if (${WITH_NFC})
        list(APPEND SDK_SOURCE_FILES
                "${NRF5_SDK_PATH}/components/libraries/bsp/bsp_nfc.c"
                )
    endif ()

endmacro(nRF5x_addBSP)

# adds app-level FDS (flash data storage) library
macro(nRF5x_addAppFDS)
    include_directories(
            "${NRF5_SDK_PATH}/components/libraries/fds"
            "${NRF5_SDK_PATH}/components/libraries/fstorage"
            "${NRF5_SDK_PATH}/components/libraries/experimental_section_vars"
    )

    list(APPEND SDK_SOURCE_FILES
            "${NRF5_SDK_PATH}/components/libraries/fds/fds.c"
            "${NRF5_SDK_PATH}/components/libraries/fstorage/nrf_fstorage.c"
            "${NRF5_SDK_PATH}/components/libraries/fstorage/nrf_fstorage_sd.c"
            "${NRF5_SDK_PATH}/components/libraries/fstorage/nrf_fstorage_nvmc.c"
    )
endmacro(nRF5x_addAppFDS)

macro(nRF5x_addExternalUSB WITH_AUDIO WITH_CDC_ACM)
    include_directories(
        "${NRF5_SDK_PATH}/components/libraries/usbd"
    )
    file(GLOB USB_SRC_FILES "${NRF5_SDK_PATH}/components/libraries/usbd/*.c")
    list(APPEND SDK_SOURCE_FILES ${USB_SRC_FILES})

    list(APPEND SDK_SOURCE_FILES "${NRF5_SDK_PATH}/modules/nrfx/drivers/src/nrfx_systick.c")

    if (${WITH_AUDIO})
        include_directories(
            "${NRF5_SDK_PATH}/components/libraries/usbd/class/audio"
        )
        list(APPEND SDK_SOURCE_FILES "${NRF5_SDK_PATH}/components/libraries/usbd/class/audio/app_usbd_audio.c")
    endif()

    if (${WITH_CDC_ACM})
        include_directories(
            "${NRF5_SDK_PATH}/components/libraries/usbd/class/cdc"
            "${NRF5_SDK_PATH}/components/libraries/usbd/class/cdc/acm"
        )
        list(APPEND SDK_SOURCE_FILES "${NRF5_SDK_PATH}/components/libraries/usbd/class/cdc/acm/app_usbd_cdc_acm.c")
    endif()

    # TODO ADD ALL REMAINING
    # "${NRF5_SDK_PATH}/components/libraries/usbd/class/hid"
    # "${NRF5_SDK_PATH}/components/libraries/usbd/class/hid/generic"
    # "${NRF5_SDK_PATH}/components/libraries/usbd/class/hid/kbd"
    # "${NRF5_SDK_PATH}/components/libraries/usbd/class/hid/mouse"
    # "${NRF5_SDK_PATH}/components/libraries/usbd/class/msc"

endmacro(nRF5x_addExternalUSB)



