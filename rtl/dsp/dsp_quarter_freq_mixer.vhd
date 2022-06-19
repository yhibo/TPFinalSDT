library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity dsp_quarter_freq_mixer is
    port (
        sys_clk_in       : in std_logic;
        sys_rst_n_in     : in std_logic;
        s_axis_tdata_in  : in std_logic_vector(15 downto 0);
        s_axis_tvalid_in : in std_logic;
        m_axis_re_tdata  : out std_logic_vector(16 downto 0);
        m_axis_im_tdata  : out std_logic_vector(16 downto 0);
        m_axis_tvalid    : out std_logic;
        m_axis_tready    : in std_logic
    );
end entity dsp_quarter_freq_mixer;

architecture rtl of dsp_quarter_freq_mixer is
    type mult_state is (COS_1, COS_0_FIRST, COS_NEG_1, COS_0_SECOND);
    signal state_reg : mult_state := COS_1;
    signal s_axis_re_tdata_reg : signed(16 downto 0);
    signal s_axis_im_tdata_reg : signed(16 downto 0);
    signal s_axis_tvalid_reg : std_logic := '0';

begin
    fsm : process (sys_clk_in, sys_rst_n_in)
    begin
        if (sys_rst_n_in = '0') then
            state_reg <= COS_1;
            s_axis_re_tdata_reg <= (others => '0');
            s_axis_im_tdata_reg <= (others => '0');
            s_axis_tvalid_reg <= '0';
        elsif (rising_edge(sys_clk_in)) then
            s_axis_re_tdata_reg <= (others => '0');
            s_axis_im_tdata_reg <= (others => '0');
            s_axis_tvalid_reg <= '0';
            case state_reg is
                when COS_1 =>
                    state_reg <= COS_1;
                    if (s_axis_tvalid_in = '1') then
                        state_reg <= COS_0_FIRST;
                        s_axis_re_tdata_reg <= resize(signed(s_axis_tdata_in), 17);
                        s_axis_im_tdata_reg <= (others => '0');
                        s_axis_tvalid_reg <= '1';
                    end if;
                when COS_0_FIRST =>
                    state_reg <= COS_0_FIRST;
                    if (s_axis_tvalid_in = '1') then
                        state_reg <= COS_NEG_1;
                        s_axis_re_tdata_reg <= (others => '0');
                        s_axis_im_tdata_reg <= resize(signed(s_axis_tdata_in), 17);
                        s_axis_tvalid_reg <= '1';
                    end if;
                when COS_NEG_1 =>
                    state_reg <= COS_NEG_1;
                    if (s_axis_tvalid_in = '1') then
                        state_reg <= COS_0_SECOND;
                        s_axis_re_tdata_reg <= - 1 * resize(signed(s_axis_tdata_in), 17);
                        s_axis_im_tdata_reg <= (others => '0');
                        s_axis_tvalid_reg <= '1';
                    end if;
                when COS_0_SECOND =>
                    state_reg <= COS_0_SECOND;
                    if (s_axis_tvalid_in = '1') then
                        state_reg <= COS_1;
                        s_axis_re_tdata_reg <= (others => '0');
                        s_axis_im_tdata_reg <= - 1 * resize(signed(s_axis_tdata_in), 17);
                        s_axis_tvalid_reg <= '1';
                    end if;
            end case;
        end if;
    end process;
    m_axis_re_tdata <= std_logic_vector(s_axis_re_tdata_reg);
    m_axis_im_tdata <= std_logic_vector(s_axis_im_tdata_reg);
    m_axis_tvalid <= s_axis_tvalid_reg;
end architecture rtl;
