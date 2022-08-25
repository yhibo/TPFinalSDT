----------------------------------------------------------------------------------
-- Company:  Instituto Balseiro
-- Engineer: José Quinteros
--
-- Design Name:
-- Module Name:
-- Project Name:
-- Target Devices:
-- Tool Versions:
-- Description: ADC Serdes Top
--
-- Dependencies: None.
--
-- Revision: 2022-06-19
-- Additional Comments:
--
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.all;

library UNISIM;
use UNISIM.vcomponents.all;

library adc_serdes;
use adc_serdes.adc_serdes_pkg.all;

library common;

entity adc_serdes_top is
  generic (
    N_CH               : integer := 8;
    RES_ADC            : integer := 14;
    C_S_AXI_ADDR_WIDTH : integer := 32
  );
  port (
    sys_rst_n_in      : in std_logic;

    -- ADC input signals
    adc_dco_clk_in    : in std_logic;

    adc_data_p_in     : in std_logic;
    adc_data_n_in     : in std_logic;
    adc_fco_p_in      : in std_logic;
    adc_fco_n_in      : in std_logic;

    -- Axi stream signals
    m_axis_tdata_out  : out std_logic_vector(15 downto 0);
    m_axis_tvalid_out : out std_logic

  );
end adc_serdes_top;

architecture arch of adc_serdes_top is
  signal m_axis_tdata_s : std_logic_vector(13 downto 0);

  signal adc_clk_divide_2 : std_logic;
  signal idelay_rst_n_sync : std_logic;

  signal rdy_from_idelayctrl_s : std_logic;

  signal idelay_ctrl_rst_sync : std_logic;

  signal data_valid : std_logic;
  signal data_valid_s : std_logic;
  signal data_valid_reg : std_logic;

  signal tdata_reg : std_logic_vector(15 downto 0);
  signal tvalid_reg : std_logic;
  
  signal sys_rst: std_logic;
begin

  sys_rst <= sys_rst_n_in;

  BUFGCE_DIV_inst : BUFGCE_DIV
  generic map(
    BUFGCE_DIVIDE => 2
  )
  port map(
    -- Input ports mapping
    I   => adc_dco_clk_in,
    CLR => '0',
    CE  => '1',
    --Output port mapping
    O   => adc_clk_divide_2

  );

  IDELAY_ctrl_inst : IDELAYCTRL
  generic map(
    SIM_DEVICE => "ULTRASCALE"
  )
  port map(
    --output ports
    RDY    => rdy_from_idelayctrl_s,
    --input ports
    REFCLK => adc_dco_clk_in,
    RST    => sys_rst
  );
  adc_serdes_inst : entity adc_serdes.adc_serdes(rtl)
    generic map(
      RES_ADC => 14 --ADC resolution, can take values 14 or 12
    )
    port map(

      sys_rst_n_in        => sys_rst_n_in,
      idelay_rst_n_in     => '1',
      -- ADC inputs
      adc_dco_clk_in      => adc_dco_clk_in,
      adc_data_p_in       => adc_data_p_in,
      adc_data_n_in       => adc_data_n_in,
      adc_fco_p_in        => adc_fco_p_in,
      adc_fco_n_in        => adc_fco_n_in,
      --IDELAYE3 CLK
      adc_clk_divide_2_in => adc_clk_divide_2,
      -- Output signals
      m_axis_tdata_out    => m_axis_tdata_s,
      m_axis_tvalid_out   => data_valid_s
    );

  --sign extension to 16 bits
  tdata_reg(15) <= m_axis_tdata_s(13);
  tdata_reg(14) <= m_axis_tdata_s(13);
  tdata_reg(13 downto 0) <= m_axis_tdata_s(13 downto 0);

  m_axis_tdata_out <= tdata_reg;

  --Data valid generator
  data_valid_proc : process (adc_dco_clk_in, sys_rst_n_in)
  begin
    if sys_rst_n_in = '0' then
      data_valid_reg <= '0';
      tvalid_reg <= '0';
    elsif rising_edge(adc_dco_clk_in) then
      data_valid_reg <= data_valid_reg or data_valid_s; --Latched OR value
      tvalid_reg <= '0';
      if (data_valid_reg = '1') then
        tvalid_reg <= '1';
        data_valid_reg <= '0';
      end if;
    end if;
  end process data_valid_proc;
  m_axis_tvalid_out <= tvalid_reg;

end arch; -- arch
