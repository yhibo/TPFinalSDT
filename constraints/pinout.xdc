# ADC SPI interface
set_property PACKAGE_PIN E1 [get_ports adc_ss1_o]
set_property IOSTANDARD LVCMOS18 [get_ports adc_ss1_o]
set_property PACKAGE_PIN D1 [get_ports adc_ss2_o]
set_property IOSTANDARD LVCMOS18 [get_ports adc_ss2_o]
set_property PACKAGE_PIN G6 [get_ports adc_sdio_o]
set_property IOSTANDARD LVCMOS18 [get_ports adc_sdio_o]
set_property PACKAGE_PIN F6 [get_ports adc_sclk_o]
set_property IOSTANDARD LVCMOS18 [get_ports adc_sclk_o]

# #FMC present signal
# set_property PACKAGE_PIN C12 [get_ports fmc_present_i]
# set_property IOSTANDARD LVCMOS18 [get_ports fmc_present_i]

#adc_DCO1+
set_property PACKAGE_PIN D4 [get_ports adc_dco_p_in]
set_property IOSTANDARD LVDS [get_ports adc_dco_p_in]

# adc_FCO1+
set_property PACKAGE_PIN K9 [get_ports adc_fco_p_in]
set_property IOSTANDARD LVDS [get_ports adc_fco_p_in]

# adc_D_A1+
set_property PACKAGE_PIN L7 [get_ports adc_data_p_in]
set_property IOSTANDARD LVDS [get_ports adc_data_p_in]

