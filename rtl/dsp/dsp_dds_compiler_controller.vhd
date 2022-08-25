library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity dsp_dds_compiler_controller is
  port (
    sys_clk_in        : in std_logic;
    sys_rst_n_in      : in std_logic;
    s_axis_tdata      : in std_logic_vector(15 downto 0);
    s_axis_data_tuser : in std_logic_vector(2 downto 0);
    s_axis_tvalid     : in std_logic;
    m_axis_tdata      : out std_logic_vector(15 downto 0);
    m_axis_tvalid     : out std_logic
  );
end entity dsp_dds_compiler_controller;

architecture rtl of dsp_dds_compiler_controller is

begin
  process (sys_clk_in, sys_rst_n_in)
  begin
    if (sys_rst_n_in = '0') then
      m_axis_tdata <= (others => '0');
      m_axis_tvalid <= '0';
    elsif (rising_edge(sys_clk_in)) then
      -- I pick one channel
      if (s_axis_data_tuser = "000") then
        m_axis_tdata <= s_axis_tdata;
        m_axis_tvalid <= s_axis_tvalid;
      else
        m_axis_tdata <= (others => '0');
        m_axis_tvalid <= '0';
      end if;
    end if;
  end process;
end rtl;
