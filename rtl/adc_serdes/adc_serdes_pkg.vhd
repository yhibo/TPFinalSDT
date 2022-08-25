----------------------------------------------------------------------------------
-- Company:  Instituto Balseiro
-- Engineer: José Quinteros
--
-- Design Name:
-- Module Name:
-- Project Name:
-- Target Devices:
-- Tool Versions:
-- Description: ADC Serdes Package
--
-- Dependencies: None.
--
-- Revision: 2022-05-22
-- Additional Comments:
--
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.all;

package adc_serdes_pkg is

    -- IDELAYE3 attributes
    constant ADC_SERDES_CASCADE : string := "NONE"; -- No cascade
    constant ADC_SERDES_DELAY_FORMAT : string := "TIME"; -- tap mode
    constant ADC_SERDES_DELAY_SRC : string := "IDATAIN"; -- Input come from IOB
    constant ADC_SERDES_DELAY_TYPE : string := "FIXED"; -- Variable mode
    constant ADC_SERDES_DELAY_VALUE : integer := 0; -- The DELAY_VALUE is expressed as taps (0 to 511).
    constant ADC_SERDES_IS_CLK_INVERTED : bit := '0';
    constant ADC_SERDES_IS_RST_INVERTED : bit := '1'; --Active low reset
    constant ADC_SERDES_LOOPBACK : string := "FALSE";
    constant ADC_SERDES_REFCLK_FREQUENCY : real := 455.0; -- Default value, doesn't need in COUNT mode
    constant ADC_SERDES_SIM_DEVICE : string := "ULTRASCALE_PLUS"; --device version
    constant ADC_SERDES_SIM_VERSION : real := 2.0;
    constant ADC_SERDES_UPDATE_MODE : string := "ASYNC";
end;
package body adc_serdes_pkg is

end;
