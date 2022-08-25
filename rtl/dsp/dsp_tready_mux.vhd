library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity dsp_tready_mux is
    port (
        select_in         : in std_logic_vector(1 downto 0);
        s_axis_tdata      : in std_logic_vector(16 downto 0);
        s_axis_tvalid     : in std_logic;
        s_axis_tready     : out std_logic;

        data_tready_1_in  : in std_logic;
        data_tready_2_in  : in std_logic;
        data_tready_3_in  : in std_logic;

        m_axis_tdata_out  : out std_logic_vector(16 downto 0);
        m_axis_tvalid_out : out std_logic
    );
end dsp_tready_mux;

architecture Behavioral of dsp_tready_mux is
begin
    with select_in select s_axis_tready <=
        data_tready_1_in when "00",
        data_tready_2_in when "01",
        data_tready_3_in when "10",
        '0' when others;

    m_axis_tdata_out <= s_axis_tdata;
    m_axis_tvalid_out <= s_axis_tvalid;
end Behavioral;
