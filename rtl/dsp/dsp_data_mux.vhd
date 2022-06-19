----------------------------------------------------------------------------------
-- Company:  Instituto Balseiro
-- Author: Yhibo
--
-- Design Name:
-- Module Name:
-- Project Name:
-- Target Devices:
-- Tool Versions:
-- Description: DSP Placeholder!
--
-- Dependencies: None.
--
-- Revision: 2022-06-19
-- Additional Comments:
--
----------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity dsp_data_mux is
  port (
    sel                  : in std_logic_vector(2 downto 0);
    s_axis_tdata_in      : in std_logic_vector(15 downto 0);
    s_axis_tvalid_in     : in std_logic;
    s_counter_tdata_in   : in std_logic_vector(15 downto 0);
    s_counter_tvalid_in  : in std_logic;
    s_dds_tdata_in       : in std_logic_vector(15 downto 0);
    s_dds_tvalid_in      : in std_logic;
    m_axis_tdata_out     : out std_logic_vector(31 downto 0);
    m_axis_tvalid_out    : out std_logic
  );
end entity dsp_data_mux;

architecture rtl of dsp_data_mux is

begin

  with sel select m_axis_tdata_out <=
    s_axis_tdata_in    when "00",
    s_counter_tdata_in when "01",
    s_dds_tdata_in     when "10",
    (others => '0')    when others;

  with sel select m_axis_tvalid_out <=
    s_axis_tvalid_in    when "00",
    s_counter_tvalid_in when "01",
    s_dds_tvalid_in     when "10",
    '0'                 when others;

end architecture rtl;