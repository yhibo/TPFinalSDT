library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
entity dsp_data_source_mux is
    port (
        s_axis_counter_tdata       : in std_logic_vector(15 downto 0);
        s_axis_counter_tvalid      : in std_logic;
        s_axis_adc_tdata           : in std_logic_vector(15 downto 0);
        s_axis_adc_tvalid          : in std_logic;
        s_axis_dds_compiler_tdata  : in std_logic_vector(15 downto 0);
        s_axis_dds_compiler_tvalid : in std_logic;
        control_in                 : in std_logic_vector(1 downto 0);
        m_axis_tdata               : out std_logic_vector(15 downto 0);
        m_axis_tvalid              : out std_logic
    );
end dsp_data_source_mux;

architecture Behavioral of dsp_data_source_mux is
begin
    with control_in select m_axis_tdata <=
        s_axis_adc_tdata when "00",
        s_axis_dds_compiler_tdata when "01",
        s_axis_counter_tdata when "10",
        (others => '0') when others;

    with control_in select m_axis_tvalid <=
        s_axis_adc_tvalid when "00",
        s_axis_dds_compiler_tvalid when "01",
        s_axis_counter_tvalid when "10",
        '0' when others;
end Behavioral;
