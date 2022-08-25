library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity dsp_quarter_freq_multiplier is
    generic (TICK_FOR_COSINE_UNTICK_FOR_SINE : boolean := true);
    port (
        sys_clk_in       : in std_logic;
        sys_rst_n_in     : in std_logic;
        s_axis_tdata_in  : in std_logic_vector(15 downto 0);
        s_axis_tvalid_in : in std_logic;
        m_axis_tdata     : out std_logic_vector(16 downto 0);
        m_axis_tvalid    : out std_logic;
        m_axis_tready    : in std_logic
    );
end entity dsp_quarter_freq_multiplier;

architecture rtl of dsp_quarter_freq_multiplier is
    type mult_state is (INIT, MULT_BY_1, MULT_BY_0_FIRST, MULT_BY_NEG_1, MULT_BY_0_SECOND);
    signal state_reg : mult_state := INIT;
    signal s_axis_tdata_reg : signed(16 downto 0);
    signal s_axis_tvalid_reg : std_logic := '0';
    signal valid_buffer : std_logic := '0';

begin
    fsm : process (sys_clk_in, sys_rst_n_in)
    begin
        if (rising_edge(sys_clk_in)) then
            if (sys_rst_n_in = '0') then
                state_reg <= INIT;
                s_axis_tdata_reg <= (others => '0');
                s_axis_tvalid_reg <= '0';
                valid_buffer <= '0';
            else
                s_axis_tdata_reg <= (others => '0');
                s_axis_tvalid_reg <= '0';
                valid_buffer <= '0';
                case state_reg is
                    when INIT =>
                        if (TICK_FOR_COSINE_UNTICK_FOR_SINE) then
                            state_reg <= MULT_BY_1;
                        else
                            state_reg <= MULT_BY_0_FIRST;
                        end if;
                    when MULT_BY_1 =>
                        if (s_axis_tvalid_in = '1' or valid_buffer = '1') then
                            valid_buffer <= '1';
                            state_reg <= MULT_BY_1;
                            if (m_axis_tready = '1') then
                                state_reg <= MULT_BY_0_FIRST;
                                valid_buffer <= '0';
                                s_axis_tdata_reg <= resize(signed(s_axis_tdata_in), 17);
                                s_axis_tvalid_reg <= '1';
                            end if;
                        else
                            state_reg <= MULT_BY_1;
                        end if;
                    when MULT_BY_0_FIRST =>
                        if (s_axis_tvalid_in = '1' or valid_buffer = '1') then
                            valid_buffer <= '1';
                            state_reg <= MULT_BY_0_FIRST;
                            if (m_axis_tready = '1') then
                                state_reg <= MULT_BY_NEG_1;
                                valid_buffer <= '0';
                                s_axis_tdata_reg <= (others => '0');
                                s_axis_tvalid_reg <= '1';
                            end if;
                        else
                            state_reg <= MULT_BY_0_FIRST;
                        end if;
                    when MULT_BY_NEG_1 =>
                        if (s_axis_tvalid_in = '1' or valid_buffer = '1') then
                            valid_buffer <= '1';
                            state_reg <= MULT_BY_NEG_1;
                            if (m_axis_tready = '1') then
                                state_reg <= MULT_BY_0_SECOND;
                                valid_buffer <= '0';
                                s_axis_tdata_reg <= resize(-1 * resize(signed(s_axis_tdata_in), 17), 17);
                                s_axis_tvalid_reg <= '1';
                            end if;
                        else
                            state_reg <= MULT_BY_NEG_1;
                        end if;
                    when MULT_BY_0_SECOND =>
                        if (s_axis_tvalid_in = '1' or valid_buffer = '1') then
                            valid_buffer <= '1';
                            state_reg <= MULT_BY_0_SECOND;
                            if (m_axis_tready = '1') then
                                state_reg <= MULT_BY_1;
                                valid_buffer <= '0';
                                s_axis_tdata_reg <= (others => '0');
                                s_axis_tvalid_reg <= '1';
                            end if;
                        else
                            state_reg <= MULT_BY_0_SECOND;
                        end if;
                end case;
            end if;
        end if;
    end process;
    m_axis_tdata <= std_logic_vector(s_axis_tdata_reg);
    m_axis_tvalid <= s_axis_tvalid_reg;
end architecture rtl;
