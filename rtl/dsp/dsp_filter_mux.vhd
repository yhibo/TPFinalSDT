library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity dsp_filter_mux is
    port (
        select_in               : in std_logic_vector(1 downto 0);
        fir_1_data_in           : in std_logic_vector(31 downto 0);
        fir_1_valid_in          : in std_logic;
        s_axis_no_fir_tdata_in  : in std_logic_vector(31 downto 0);
        s_axis_no_fir_tvalid_in : in std_logic;
        fir_2_data_in           : in std_logic_vector(31 downto 0);
        fir_2_valid_in          : in std_logic;
        m_axis_tdata_out        : out std_logic_vector(31 downto 0);
        m_axis_tvalid_out       : out std_logic
    );
end dsp_filter_mux;

architecture Behavioral of dsp_filter_mux is
begin
    with select_in select m_axis_tdata_out <=
        fir_1_data_in when "00",
        s_axis_no_fir_tdata_in when "01",
        fir_2_data_in when "10",
        (others => '0') when others;

    with select_in select m_axis_tvalid_out <=
        fir_1_valid_in when "00",
        s_axis_no_fir_tvalid_in when "01",
        fir_2_valid_in when "10",
        '0' when others;
end Behavioral;
