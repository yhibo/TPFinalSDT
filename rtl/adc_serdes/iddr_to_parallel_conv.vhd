----------------------------------------------------------------------------------
-- Company:  Instituto Balseiro
-- Engineer: José Quinteros
--
-- Design Name:
-- Module Name:
-- Project Name:
-- Target Devices:
-- Tool Versions:
-- Description: IDDR to parallel converter
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

library STD;
use STD.TEXTIO.all;
use IEEE.Std_Logic_TextIO.all;

library adc_serdes;

entity iddr_to_parallel_conv is
  generic (
    OUTPUT_WIDTH : integer := 14
  );
  port (
    sys_clk_in        : in std_logic;
    sys_rst_n_in      : in std_logic;

    data_re_in        : in std_logic;
    data_fe_in        : in std_logic;
    frame_re_in       : in std_logic;
    frame_fe_in       : in std_logic;
    m_axis_tdata_out  : out std_logic_vector(OUTPUT_WIDTH - 1 downto 0); --"00" & data
    m_axis_tvalid_out : out std_logic
  );
end entity iddr_to_parallel_conv;

architecture rtl of iddr_to_parallel_conv is
  signal shift_reg : std_logic_vector(OUTPUT_WIDTH - 1 downto 0) := (others => '0');
  signal data_reg : std_logic_vector(OUTPUT_WIDTH - 1 downto 0) := (others => '0');
  signal frame_re_reg : std_logic;
  signal valid_reg : std_logic := '0';

begin

  aproc_shift_reg : process (sys_clk_in)
  begin
    if rising_edge(sys_clk_in) then
      shift_reg <= shift_reg(OUTPUT_WIDTH - 3 downto 0) & data_re_in & data_fe_in;
    end if;
  end process aproc_shift_reg;

  aproc_frame : process (sys_clk_in, sys_rst_n_in)
  begin
    if sys_rst_n_in = '0' then
      valid_reg <= '0';
      frame_re_reg <= '0';
    elsif rising_edge(sys_clk_in) then
      valid_reg <= '0';
      frame_re_reg <= frame_re_in;
      if (frame_re_in = '1' and frame_re_reg = '0') then
        data_reg <= shift_reg;
        valid_reg <= '1';
      end if;
    end if;
  end process aproc_frame;

  m_axis_tdata_out <= data_reg;
  m_axis_tvalid_out <= valid_reg;

end architecture rtl;
