#include "stdbool.h"

#include <nrf_delay.h>
#include <nrf_drv_clock.h>
#include <nrf_log.h>
#include <nrf_log_ctrl.h>
#include <nrf_log_default_backends.h>
#include <nrf_pwr_mgmt.h>

#include <app_error.h>
#include <app_timer.h>

void log_init(void) {
    ret_code_t err_code = NRF_LOG_INIT(NULL);
    APP_ERROR_CHECK(err_code);

    NRF_LOG_DEFAULT_BACKENDS_INIT();
}

void power_management_init(void) {
    ret_code_t err_code;
    err_code = nrf_pwr_mgmt_init();
    APP_ERROR_CHECK(err_code);
}

/** Application main function.
 */

int main(void) {
    nrf_drv_clock_init();
    log_init();
    power_management_init();
    app_timer_init();

    nrf_delay_us(1000);

    while (true) {
        nrf_delay_us(1000);
    }
}

void app_error_fault_handler(uint32_t id, uint32_t pc, uint32_t info) {
    //__disable_irq();
    // NRF_LOG_FINAL_FLUSH();

    if (id == NRF_FAULT_ID_SDK_ASSERT) {
        assert_info_t *p_info = (assert_info_t *)info;
    } else if (id == NRF_FAULT_ID_SDK_ERROR) {
        error_info_t *p_info = (error_info_t *)info;
    } else {
    }

    nrf_delay_us(100 * 1000);
    NVIC_SystemReset();
}

void assert_nrf_callback(uint16_t line_num, const uint8_t *file_name) {
    assert_info_t assert_info = {
        .line_num = line_num,
        .p_file_name = file_name,
    };
    app_error_fault_handler(NRF_FAULT_ID_SDK_ASSERT, 0, (uint32_t)(&assert_info));

    UNUSED_VARIABLE(assert_info);
}