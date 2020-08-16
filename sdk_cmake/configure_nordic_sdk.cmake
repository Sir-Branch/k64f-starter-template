cmake_minimum_required(VERSION 3.6)

# check if all the necessary tools paths have been provided.
if (NOT NRF5_SDK_PATH)
    message(FATAL_ERROR "The path to the nRF5 SDK (NRF5_SDK_PATH) must be set.")
endif ()

# Configure nrfutils
set(NRFUTIL_COMMAND "nrfutil")
set(MERGEHEX_COMMAND "mergehex")


macro(nRF5x_setup)
    # fix on macOS: prevent cmake from adding implicit parameters to Xcode
    set(CMAKE_OSX_SYSROOT "/")
    set(CMAKE_OSX_DEPLOYMENT_TARGET "")

    # CPU specyfic settings
    if(NOT DEFINED NRF5_LINKER_SCRIPT)
        message(FATAL_ERROR "The linker script path (NRF5_LINKER_SCRIPT) must be set.")
    endif()
    set(CPU_FLAGS "-mcpu=cortex-m4 -mfloat-abi=hard -mfpu=fpv4-sp-d16")
    add_definitions(-DNRF52840 -DNRF52840_XXAA -DBOARD_CUSTOM)
    add_definitions(-DSOFTDEVICE_PRESENT -DS140 -DSWI_DISABLE0 -DBLE_STACK_SUPPORT_REQD -DNRF_SD_BLE_API_VERSION=6)
    include_directories(
            "${NRF5_SDK_PATH}/components/softdevice/s140/headers"
            "${NRF5_SDK_PATH}/components/softdevice/s140/headers/nrf52"
    )
    list(APPEND SDK_SOURCE_FILES
            "${NRF5_SDK_PATH}/modules/nrfx/mdk/system_nrf52840.c"
            "${NRF5_SDK_PATH}/modules/nrfx/mdk/gcc_startup_nrf52840.S"
            )
    set(SOFTDEVICE_PATH "${NRF5_SDK_PATH}/components/softdevice/s140/hex/s140_nrf52_6.1.1_softdevice.hex")
    
    SET(C_ERRORS "-Werror=implicit-function-declaration")
    set(COMMON_FLAGS "-MP -MD -mthumb -mabi=aapcs -Wall -g3 -ffunction-sections -fdata-sections -fno-strict-aliasing -fno-builtin --short-enums ${CPU_FLAGS} ${C_ERRORS}")

    # compiler/assambler/linker flags
    set(CMAKE_C_FLAGS "${COMMON_FLAGS} -Os")
    set(CMAKE_CXX_FLAGS "${COMMON_FLAGS}")
    set(CMAKE_ASM_FLAGS "-MP -MD -x assembler-with-cpp")
    set(CMAKE_EXE_LINKER_FLAGS "-mthumb -mabi=aapcs -L ${NRF5_SDK_PATH}/modules/nrfx/mdk -T${NRF5_LINKER_SCRIPT} ${CPU_FLAGS} -Wl,--gc-sections --specs=nano.specs -lc -lnosys -lm")
    # note: we must override the default cmake linker flags so that CMAKE_C_FLAGS are not added implicitly
    set(CMAKE_C_LINK_EXECUTABLE "${CMAKE_C_COMPILER} <LINK_FLAGS> <OBJECTS> -o <TARGET> <LINK_LIBRARIES>")
    set(CMAKE_CXX_LINK_EXECUTABLE "${CMAKE_C_COMPILER} <LINK_FLAGS> <OBJECTS> -lstdc++ -o <TARGET> <LINK_LIBRARIES>")

    if(DEFINE_DEBUG)
        message(STATUS "DEBUG MODE ENABLED")
        add_definitions(-DDEBUG)
    endif()

    # basic board definitions and drivers
    include_directories(
            "${NRF5_SDK_PATH}/components"
            "${NRF5_SDK_PATH}/components/boards"
            "${NRF5_SDK_PATH}/components/softdevice/common"
            "${NRF5_SDK_PATH}/integration/nrfx"
            "${NRF5_SDK_PATH}/modules/nrfx"
            "${NRF5_SDK_PATH}/modules/nrfx/drivers/include"
            "${NRF5_SDK_PATH}/modules/nrfx/hal"
            "${NRF5_SDK_PATH}/modules/nrfx/mdk"
    )

    list(APPEND SDK_SOURCE_FILES
            "${NRF5_SDK_PATH}/components/boards/boards.c"
            "${NRF5_SDK_PATH}/components/softdevice/common/nrf_sdh.c"
            "${NRF5_SDK_PATH}/components/softdevice/common/nrf_sdh_soc.c"
            "${NRF5_SDK_PATH}/modules/nrfx/drivers/src/nrfx_clock.c"
            "${NRF5_SDK_PATH}/modules/nrfx/drivers/src/nrfx_gpiote.c"
            "${NRF5_SDK_PATH}/modules/nrfx/drivers/src/nrfx_uart.c"
            "${NRF5_SDK_PATH}/modules/nrfx/drivers/src/nrfx_uarte.c"
            "${NRF5_SDK_PATH}/modules/nrfx/drivers/src/nrfx_timer.c"
            "${NRF5_SDK_PATH}/modules/nrfx/drivers/src/nrfx_ppi.c"
            "${NRF5_SDK_PATH}/modules/nrfx/drivers/src/nrfx_power.c"
            "${NRF5_SDK_PATH}/modules/nrfx/drivers/src/nrfx_twi.c"
            "${NRF5_SDK_PATH}/modules/nrfx/drivers/src/nrfx_saadc.c"
            "${NRF5_SDK_PATH}/modules/nrfx/drivers/src/nrfx_spi.c"
            "${NRF5_SDK_PATH}/modules/nrfx/drivers/src/nrfx_spim.c"
            "${NRF5_SDK_PATH}/modules/nrfx/drivers/src/nrfx_usbd.c"
            "${NRF5_SDK_PATH}/modules/nrfx/drivers/src/prs/nrfx_prs.c"
            "${NRF5_SDK_PATH}/modules/nrfx/soc/nrfx_atomic.c"
            )


    # toolchain specific
    include_directories(
            "${NRF5_SDK_PATH}/components/toolchain/cmsis/include"
    )

    # libraries
    include_directories(
            "${NRF5_SDK_PATH}/components/libraries/atomic"
            "${NRF5_SDK_PATH}/components/libraries/atomic_fifo"
            "${NRF5_SDK_PATH}/components/libraries/atomic_flags"
            "${NRF5_SDK_PATH}/components/libraries/balloc"
            "${NRF5_SDK_PATH}/components/libraries/bootloader/ble_dfu"
            "${NRF5_SDK_PATH}/components/libraries/cli"
            "${NRF5_SDK_PATH}/components/libraries/crc16"
            "${NRF5_SDK_PATH}/components/libraries/crc32"
            "${NRF5_SDK_PATH}/components/libraries/crypto"
            "${NRF5_SDK_PATH}/components/libraries/csense"
            "${NRF5_SDK_PATH}/components/libraries/csense_drv"
            "${NRF5_SDK_PATH}/components/libraries/delay"
            "${NRF5_SDK_PATH}/components/libraries/ecc"
            "${NRF5_SDK_PATH}/components/libraries/experimental_section_vars"
            "${NRF5_SDK_PATH}/components/libraries/experimental_task_manager"
            "${NRF5_SDK_PATH}/components/libraries/fds"
            "${NRF5_SDK_PATH}/components/libraries/fstorage"
            "${NRF5_SDK_PATH}/components/libraries/gfx"
            "${NRF5_SDK_PATH}/components/libraries/gpiote"
            "${NRF5_SDK_PATH}/components/libraries/hardfault"
            "${NRF5_SDK_PATH}/components/libraries/hci"
            "${NRF5_SDK_PATH}/components/libraries/led_softblink"
            "${NRF5_SDK_PATH}/components/libraries/log"
            "${NRF5_SDK_PATH}/components/libraries/log/src"
            "${NRF5_SDK_PATH}/components/libraries/low_power_pwm"
            "${NRF5_SDK_PATH}/components/libraries/mem_manager"
            "${NRF5_SDK_PATH}/components/libraries/memobj"
            "${NRF5_SDK_PATH}/components/libraries/mpu"
            "${NRF5_SDK_PATH}/components/libraries/mutex"
            "${NRF5_SDK_PATH}/components/libraries/pwm"
            "${NRF5_SDK_PATH}/components/libraries/pwr_mgmt"
            "${NRF5_SDK_PATH}/components/libraries/queue"
            "${NRF5_SDK_PATH}/components/libraries/ringbuf"
            "${NRF5_SDK_PATH}/components/libraries/scheduler"
            "${NRF5_SDK_PATH}/components/libraries/sdcard"
            "${NRF5_SDK_PATH}/components/libraries/slip"
            "${NRF5_SDK_PATH}/components/libraries/sortlist"
            "${NRF5_SDK_PATH}/components/libraries/spi_mngr"
            "${NRF5_SDK_PATH}/components/libraries/stack_guard"
            "${NRF5_SDK_PATH}/components/libraries/strerror"
            "${NRF5_SDK_PATH}/components/libraries/svc"
            "${NRF5_SDK_PATH}/components/libraries/timer"
            "${NRF5_SDK_PATH}/components/libraries/twi_mngr"
            "${NRF5_SDK_PATH}/components/libraries/twi_sensor"
            "${NRF5_SDK_PATH}/components/libraries/usbd"
            "${NRF5_SDK_PATH}/components/libraries/usbd/class/audio"
            "${NRF5_SDK_PATH}/components/libraries/usbd/class/cdc"
            "${NRF5_SDK_PATH}/components/libraries/usbd/class/cdc/acm"
            "${NRF5_SDK_PATH}/components/libraries/usbd/class/hid"
            "${NRF5_SDK_PATH}/components/libraries/usbd/class/hid/generic"
            "${NRF5_SDK_PATH}/components/libraries/usbd/class/hid/kbd"
            "${NRF5_SDK_PATH}/components/libraries/usbd/class/hid/mouse"
            "${NRF5_SDK_PATH}/components/libraries/usbd/class/msc"
            "${NRF5_SDK_PATH}/components/libraries/util"
    )

    list(APPEND SDK_SOURCE_FILES
            "${NRF5_SDK_PATH}/components/libraries/atomic/nrf_atomic.c"
            "${NRF5_SDK_PATH}/components/libraries/atomic_fifo/nrf_atfifo.c"
            "${NRF5_SDK_PATH}/components/libraries/atomic_flags/nrf_atflags.c"
            "${NRF5_SDK_PATH}/components/libraries/balloc/nrf_balloc.c"
            "${NRF5_SDK_PATH}/components/libraries/crc32/crc32.c"
            "${NRF5_SDK_PATH}/components/libraries/experimental_section_vars/nrf_section_iter.c"
            "${NRF5_SDK_PATH}/components/libraries/hardfault/hardfault_implementation.c"
            "${NRF5_SDK_PATH}/components/libraries/util/nrf_assert.c"
            "${NRF5_SDK_PATH}/components/libraries/util/app_error_weak.c"
            "${NRF5_SDK_PATH}/components/libraries/util/app_util_platform.c"
            "${NRF5_SDK_PATH}/components/libraries/util/sdk_mapped_flags.c"
            "${NRF5_SDK_PATH}/components/libraries/log/src/nrf_log_backend_flash.c"
            "${NRF5_SDK_PATH}/components/libraries/log/src/nrf_log_backend_rtt.c"
            "${NRF5_SDK_PATH}/components/libraries/log/src/nrf_log_backend_serial.c"
            "${NRF5_SDK_PATH}/components/libraries/log/src/nrf_log_backend_uart.c"
            "${NRF5_SDK_PATH}/components/libraries/log/src/nrf_log_default_backends.c"
            "${NRF5_SDK_PATH}/components/libraries/log/src/nrf_log_frontend.c"
            "${NRF5_SDK_PATH}/components/libraries/log/src/nrf_log_str_formatter.c"
            "${NRF5_SDK_PATH}/components/libraries/memobj/nrf_memobj.c"
            "${NRF5_SDK_PATH}/components/libraries/pwr_mgmt/nrf_pwr_mgmt.c"
            "${NRF5_SDK_PATH}/components/libraries/queue/nrf_queue.c"
            "${NRF5_SDK_PATH}/components/libraries/ringbuf/nrf_ringbuf.c"
            "${NRF5_SDK_PATH}/components/libraries/strerror/nrf_strerror.c"
            "${NRF5_SDK_PATH}/components/libraries/spi_mngr/nrf_spi_mngr.c"
            "${NRF5_SDK_PATH}/components/libraries/twi_mngr/nrf_twi_mngr.c"
            "${NRF5_SDK_PATH}/components/libraries/uart/retarget.c"
            "${NRF5_SDK_PATH}/modules/nrfx/hal/nrf_nvmc.c"
            )

    # Other external
    include_directories(
            "${NRF5_SDK_PATH}/external/fprintf/"
            "${NRF5_SDK_PATH}/external/utf_converter/"
    )

    list(APPEND SDK_SOURCE_FILES
            "${NRF5_SDK_PATH}/external/utf_converter/utf.c"
            "${NRF5_SDK_PATH}/external/fprintf/nrf_fprintf.c"
            "${NRF5_SDK_PATH}/external/fprintf/nrf_fprintf_format.c"
            )


    # Common Bluetooth Low Energy files
    include_directories(
            "${NRF5_SDK_PATH}/components/ble"
            "${NRF5_SDK_PATH}/components/ble/common"
            "${NRF5_SDK_PATH}/components/ble/ble_advertising"
            "${NRF5_SDK_PATH}/components/ble/ble_dtm"
            "${NRF5_SDK_PATH}/components/ble/ble_link_ctx_manager"
            "${NRF5_SDK_PATH}/components/ble/ble_racp"
            "${NRF5_SDK_PATH}/components/ble/nrf_ble_qwr"
            "${NRF5_SDK_PATH}/components/ble/peer_manager"
    )

    list(APPEND SDK_SOURCE_FILES
            "${NRF5_SDK_PATH}/components/softdevice/common/nrf_sdh_ble.c"
            "${NRF5_SDK_PATH}/components/ble/common/ble_advdata.c"
            "${NRF5_SDK_PATH}/components/ble/common/ble_conn_params.c"
            "${NRF5_SDK_PATH}/components/ble/common/ble_conn_state.c"
            "${NRF5_SDK_PATH}/components/ble/common/ble_srv_common.c"
            "${NRF5_SDK_PATH}/components/ble/ble_advertising/ble_advertising.c"
            "${NRF5_SDK_PATH}/components/ble/ble_link_ctx_manager/ble_link_ctx_manager.c"
            "${NRF5_SDK_PATH}/components/ble/ble_services/ble_nus/ble_nus.c"
            "${NRF5_SDK_PATH}/components/ble/nrf_ble_qwr/nrf_ble_qwr.c"
            )


    if(${CMAKE_HOST_SYSTEM_NAME} STREQUAL "Darwin")
        set(TERMINAL "open")
    elseif(${CMAKE_HOST_SYSTEM_NAME} STREQUAL "Windows")
        set(TERMINAL "sh")
    else()
        set(TERMINAL "gnome-terminal")
    endif()

endmacro(nRF5x_setup)

# adds a target for compiling and flashing an executable
function(nRF5x_addExecutable EXECUTABLE_NAME SOURCE_FILES)
    set(LIBRARIES ${ARGV2})
    # executable
    add_executable(${EXECUTABLE_NAME} ${SDK_SOURCE_FILES} ${SOURCE_FILES})
    set_target_properties(${EXECUTABLE_NAME} PROPERTIES SUFFIX ".elf")
    set_target_properties(${EXECUTABLE_NAME} PROPERTIES LINK_FLAGS "-Wl,-Map=${EXECUTABLE_OUTPUT_PATH}/${EXECUTABLE_NAME}.map")
    target_link_libraries(${EXECUTABLE_NAME} ${LIBRARIES} ${DFU_LIBRARIES})

    # additional POST BUILD setps to create the .bin and .hex files
    add_custom_command(TARGET ${EXECUTABLE_NAME} POST_BUILD
            COMMAND ${CMAKE_OBJCOPY} -O binary ${EXECUTABLE_OUTPUT_PATH}/${EXECUTABLE_NAME}.elf "${EXECUTABLE_OUTPUT_PATH}/${EXECUTABLE_NAME}.bin"
            COMMAND ${CMAKE_OBJCOPY} -O ihex ${EXECUTABLE_OUTPUT_PATH}/${EXECUTABLE_NAME}.elf "${EXECUTABLE_OUTPUT_PATH}/${EXECUTABLE_NAME}.hex"
            COMMAND ${NRFUTIL_COMMAND} settings generate --family NRF52840 --application "${EXECUTABLE_OUTPUT_PATH}/${EXECUTABLE_NAME}.hex" --application-version 2 --bootloader-version 1 --bl-settings-version 1  "${EXECUTABLE_OUTPUT_PATH}/settings.hex"
            COMMAND ${MERGEHEX_COMMAND} -m "${EXECUTABLE_OUTPUT_PATH}/${EXECUTABLE_NAME}.hex" "${EXECUTABLE_OUTPUT_PATH}/settings.hex" -o "${EXECUTABLE_OUTPUT_PATH}/${EXECUTABLE_NAME}-settings.hex"
            COMMENT "Post build steps for ${EXECUTABLE_NAME}")

endfunction()

function(nRF5x_packageFirmware EXECUTABLE_NAME PRIVATE_KEY SOFTDEVICE_HASH)
    #string(TIMESTAMP BUILD_TIMESTAMP "-%Y%m%d-%H%M%S" "UTC")
    set(PACKAGE_FILENAME "${EXECUTABLE_OUTPUT_PATH}/${EXECUTABLE_NAME}${GIT_BRANCH}.zip")

    # ! Revert to --sd-req "0xB6" before the final release.
    add_custom_command(TARGET ${EXECUTABLE_NAME} POST_BUILD
            COMMAND ${NRFUTIL_COMMAND} pkg generate --application "${EXECUTABLE_OUTPUT_PATH}/${EXECUTABLE_NAME}.hex"
            --application-version 2 --hw-version 52 --sd-req "${SOFTDEVICE_HASH}" --key-file "${NRF5_VAULT_PATH}/${PRIVATE_KEY}.pem" ${PACKAGE_FILENAME}
            COMMENT "Packaging ${EXECUTABLE_NAME}")

endfunction()


# *********************************************************

macro(nRF5x_loadDFULibraries)
    set(DFU_LIBRARIES "${NRF5_SDK_PATH}/external/nrf_oberon/lib/cortex-m4/hard-float/liboberon_2.0.7.a" "${NRF5_SDK_PATH}/external/nrf_cc310_bl/lib/cortex-m4/hard-float/libnrf_cc310_bl_0.9.12.a")
endmacro(nRF5x_loadDFULibraries)

macro(nRF5x_addDFUDefinitions)
    add_definitions(-DNRF_DFU_SETTINGS_VERSION=2 -DNRF_DFU_SVCI_ENABLED -DSVC_INTERFACE_CALL_AS_NORMAL_FUNCTION)
endmacro(nRF5x_addDFUDefinitions)

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

# Add crypto
macro(nRF5x_addCrypto)
    include_directories(
        "${NRF5_SDK_PATH}/components/libraries/crypto/backend/cc310/"
        "${NRF5_SDK_PATH}/components/libraries/crypto/backend/cc310_bl/"
        "${NRF5_SDK_PATH}/components/libraries/crypto/backend/mbedtls/"  
        "${NRF5_SDK_PATH}/components/libraries/crypto/backend/oberon/"
        "${NRF5_SDK_PATH}/components/libraries/crypto/backend/micro_ecc/"
        "${NRF5_SDK_PATH}/components/libraries/crypto/backend/optiga/"
        "${NRF5_SDK_PATH}/components/libraries/crypto/backend/cifra/"
        "${NRF5_SDK_PATH}/components/libraries/crypto/backend/nrf_sw/"
        "${NRF5_SDK_PATH}/components/libraries/crypto/backend/nrf_hw/"
        "${NRF5_SDK_PATH}/external/nrf_cc310_bl/include/"
    )

    list(APPEND SDK_SOURCE_FILES
            "${NRF5_SDK_PATH}/components/libraries/crypto/backend/cc310_bl/cc310_bl_backend_ecc.c"
            "${NRF5_SDK_PATH}/components/libraries/crypto/backend/cc310_bl/cc310_bl_backend_ecdsa.c"
            "${NRF5_SDK_PATH}/components/libraries/crypto/backend/cc310_bl/cc310_bl_backend_hash.c"
            "${NRF5_SDK_PATH}/components/libraries/crypto/backend/cc310_bl/cc310_bl_backend_init.c"
            "${NRF5_SDK_PATH}/components/libraries/crypto/backend/cc310_bl/cc310_bl_backend_shared.c"
            "${NRF5_SDK_PATH}/components/libraries/crypto/backend/oberon/oberon_backend_chacha_poly_aead.c"
            "${NRF5_SDK_PATH}/components/libraries/crypto/backend/oberon/oberon_backend_ecc.c"
            "${NRF5_SDK_PATH}/components/libraries/crypto/backend/oberon/oberon_backend_ecdh.c"
            "${NRF5_SDK_PATH}/components/libraries/crypto/backend/oberon/oberon_backend_ecdsa.c"
            "${NRF5_SDK_PATH}/components/libraries/crypto/backend/oberon/oberon_backend_eddsa.c"
            "${NRF5_SDK_PATH}/components/libraries/crypto/backend/oberon/oberon_backend_hash.c"
            "${NRF5_SDK_PATH}/components/libraries/crypto/backend/oberon/oberon_backend_hmac.c"
            "${NRF5_SDK_PATH}/components/libraries/crypto/nrf_crypto_ecc.c"
            "${NRF5_SDK_PATH}/components/libraries/crypto/nrf_crypto_ecdsa.c"
            "${NRF5_SDK_PATH}/components/libraries/crypto/nrf_crypto_hash.c"
            "${NRF5_SDK_PATH}/components/libraries/crypto/nrf_crypto_init.c"
            "${NRF5_SDK_PATH}/components/libraries/crypto/nrf_crypto_shared.c"
        )

endmacro(nRF5x_addCrypto)

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
macro(nRF5x_addAppButton)
    include_directories(
            "${NRF5_SDK_PATH}/components/libraries/button"
    )

    list(APPEND SDK_SOURCE_FILES
            "${NRF5_SDK_PATH}/components/libraries/button/app_button.c"
            )

endmacro(nRF5x_addAppButton)

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

# adds Bluetooth Low Energy GATT support library
macro(nRF5x_addBLEGATT)
    include_directories(
            "${NRF5_SDK_PATH}/components/ble/nrf_ble_gatt"
    )

    list(APPEND SDK_SOURCE_FILES
            "${NRF5_SDK_PATH}/components/ble/nrf_ble_gatt/nrf_ble_gatt.c"
            )

endmacro(nRF5x_addBLEGATT)

# adds Bluetooth Low Energy advertising support library
macro(nRF5x_addBLEAdvertising)
    include_directories(
            "${NRF5_SDK_PATH}/components/ble/ble_advertising"
    )

    list(APPEND SDK_SOURCE_FILES
            "${NRF5_SDK_PATH}/components/ble/ble_advertising/ble_advertising.c"
            )

endmacro(nRF5x_addBLEAdvertising)

# adds Bluetooth Low Energy advertising support library
macro(nRF5x_addBLEPeerManager)
    include_directories(
            "${NRF5_SDK_PATH}/components/ble/peer_manager"
    )

    list(APPEND SDK_SOURCE_FILES
            "${NRF5_SDK_PATH}/components/ble/peer_manager/auth_status_tracker.c"
            "${NRF5_SDK_PATH}/components/ble/peer_manager/gatt_cache_manager.c"
            "${NRF5_SDK_PATH}/components/ble/peer_manager/gatts_cache_manager.c"
            "${NRF5_SDK_PATH}/components/ble/peer_manager/id_manager.c"
            "${NRF5_SDK_PATH}/components/ble/peer_manager/nrf_ble_lesc.c"
            "${NRF5_SDK_PATH}/components/ble/peer_manager/peer_data_storage.c"
            "${NRF5_SDK_PATH}/components/ble/peer_manager/peer_database.c"
            "${NRF5_SDK_PATH}/components/ble/peer_manager/peer_id.c"
            "${NRF5_SDK_PATH}/components/ble/peer_manager/peer_manager.c"
            "${NRF5_SDK_PATH}/components/ble/peer_manager/peer_manager_handler.c"
            "${NRF5_SDK_PATH}/components/ble/peer_manager/pm_buffer.c"
            "${NRF5_SDK_PATH}/components/ble/peer_manager/security_dispatcher.c"
            "${NRF5_SDK_PATH}/components/ble/peer_manager/security_manager.c"
    )

endmacro(nRF5x_addBLEPeerManager)

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

macro(nRF5x_addBLEService NAME)
    include_directories(
            "${NRF5_SDK_PATH}/components/ble/ble_services/${NAME}"
    )

    list(APPEND SDK_SOURCE_FILES
            "${NRF5_SDK_PATH}/components/ble/ble_services/${NAME}/${NAME}.c"
            )

endmacro(nRF5x_addBLEService)

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

# Add DFU libraries
macro(nRF5x_addDFU)
    include_directories(
            "${NRF5_SDK_PATH}/components/libraries/bootloader"
            "${NRF5_SDK_PATH}/components/libraries/bootloader/ble_dfu"
            "${NRF5_SDK_PATH}/components/libraries/bootloader/dfu"
    )

    list(APPEND SDK_SOURCE_FILES
            "${NRF5_SDK_PATH}/components/libraries/bootloader/ble_dfu/nrf_dfu_ble.c"
            "${NRF5_SDK_PATH}/components/libraries/bootloader/dfu/dfu-cc.pb.c"
            "${NRF5_SDK_PATH}/components/libraries/bootloader/dfu/nrf_dfu.c"
            "${NRF5_SDK_PATH}/components/libraries/bootloader/dfu/nrf_dfu_flash.c"
            "${NRF5_SDK_PATH}/components/libraries/bootloader/dfu/nrf_dfu_handling_error.c"
            "${NRF5_SDK_PATH}/components/libraries/bootloader/dfu/nrf_dfu_mbr.c"
            "${NRF5_SDK_PATH}/components/libraries/bootloader/dfu/nrf_dfu_req_handler.c"
            "${NRF5_SDK_PATH}/components/libraries/bootloader/dfu/nrf_dfu_settings.c"
            "${NRF5_SDK_PATH}/components/libraries/bootloader/dfu/nrf_dfu_settings_svci.c"
            "${NRF5_SDK_PATH}/components/libraries/bootloader/dfu/nrf_dfu_svci.c"
            "${NRF5_SDK_PATH}/components/libraries/bootloader/dfu/nrf_dfu_svci_handler.c"
            "${NRF5_SDK_PATH}/components/libraries/bootloader/dfu/nrf_dfu_transport.c"
            "${NRF5_SDK_PATH}/components/libraries/bootloader/dfu/nrf_dfu_utils.c"
            "${NRF5_SDK_PATH}/components/libraries/bootloader/dfu/nrf_dfu_validation.c"
            "${NRF5_SDK_PATH}/components/libraries/bootloader/dfu/nrf_dfu_ver_validation.c"
            "${NRF5_SDK_PATH}/components/libraries/bootloader/nrf_bootloader.c"
            "${NRF5_SDK_PATH}/components/libraries/bootloader/nrf_bootloader_app_start.c"
            "${NRF5_SDK_PATH}/components/libraries/bootloader/nrf_bootloader_app_start_final.c"
            "${NRF5_SDK_PATH}/components/libraries/bootloader/nrf_bootloader_dfu_timers.c"
            "${NRF5_SDK_PATH}/components/libraries/bootloader/nrf_bootloader_fw_activation.c"
            "${NRF5_SDK_PATH}/components/libraries/bootloader/nrf_bootloader_info.c"
            "${NRF5_SDK_PATH}/components/libraries/bootloader/nrf_bootloader_wdt.c"
    )
endmacro(nRF5x_addDFU)

