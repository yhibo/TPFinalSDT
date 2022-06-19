----------------------------------------------------------------------------------
-- Company:  Instituto Balseiro
-- Engineer: José Quinteros
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
-- Revision: 2022-05-22
-- Additional Comments:
--
----------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity dsp_placeholder is
  port (
    sys_clk_in           : in std_logic;
    sys_rst_n_in         : in std_logic;
    s_axis_tdata_in      : in std_logic_vector(15 downto 0);
    s_axis_tvalid_in     : in std_logic;
    m_re_axis_tdata_out  : out std_logic_vector(31 downto 0);
    m_re_axis_tvalid_out : out std_logic;
    m_im_axis_tdata_out  : out std_logic_vector(31 downto 0);
    m_im_axis_tvalid_out : out std_logic
  );
end entity dsp_placeholder;

architecture rtl of dsp_placeholder is

begin
  --replace with your magic!
  m_re_axis_tdata_out <= (others => '0');
  m_re_axis_tvalid_out <= '0';
  m_im_axis_tdata_out <= (others => '0');
  m_im_axis_tvalid_out <= '0';
end architecture rtl;
