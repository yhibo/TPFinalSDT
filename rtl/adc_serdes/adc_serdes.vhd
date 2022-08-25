----------------------------------------------------------------------------------
-- Company:  Instituto Balseiro
-- Engineer: José Quinteros
--
-- Design Name:
-- Module Name:
-- Project Name:
-- Target Devices:
-- Tool Versions:
-- Description: ADC Serdes
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

library UNISIM;
use UNISIM.vcomponents.all;

library adc_serdes;
use adc_serdes.adc_serdes_pkg.all; -- Add package
use adc_serdes.iddr_to_parallel_conv;

library common;

entity adc_serdes is
  generic (
    RES_ADC : integer := 14 --ADC resolution, can take values 14 or 12
  );
  port (

    sys_rst_n_in        : in std_logic;
    idelay_rst_n_in     : in std_logic;
    -- ADC inputs
    adc_dco_clk_in      : in std_logic;
    adc_data_p_in       : in std_logic;
    adc_data_n_in       : in std_logic;
    adc_fco_p_in        : in std_logic;
    adc_fco_n_in        : in std_logic;
    --IDELAYE3 CLK
    adc_clk_divide_2_in : in std_logic;
    -- Output signals
    m_axis_tdata_out    : out std_logic_vector(RES_ADC - 1 downto 0); -- "00" & data
    m_axis_tvalid_out   : out std_logic
  );
end adc_serdes;

architecture rtl of adc_serdes is

  signal data_to_idelay : std_logic;
  signal frame_to_idelay : std_logic;
  signal data_to_iddr : std_logic;
  signal frame_to_iddr : std_logic;
  signal data_to_des_RE : std_logic_vector(0 downto 0);
  signal frame_to_des_RE : std_logic_vector(0 downto 0);
  signal data_to_des_FE : std_logic_vector(0 downto 0);
  signal frame_to_des_FE : std_logic_vector(0 downto 0);

begin

  ---- ADC DATA INPUTS

  IBUFDS_inst_data : IBUFDS
  port map(
    O  => data_to_idelay, -- Buffer output
    I  => adc_data_p_in,  -- Diff_p buffer input (connect directly to top-level port)
    IB => adc_data_n_in   -- Diff_n buffer input (connect directly to top-level port)
  );

  IDELAY_inst_data : IDELAYE3
  generic map(
    CASCADE          => ADC_SERDES_CASCADE,
    DELAY_FORMAT     => ADC_SERDES_DELAY_FORMAT,
    DELAY_SRC        => ADC_SERDES_DELAY_SRC,
    DELAY_TYPE       => ADC_SERDES_DELAY_TYPE,
    DELAY_VALUE      => ADC_SERDES_DELAY_VALUE,
    IS_CLK_INVERTED  => ADC_SERDES_IS_CLK_INVERTED,
    IS_RST_INVERTED  => ADC_SERDES_IS_RST_INVERTED,
    LOOPBACK         => ADC_SERDES_LOOPBACK,
    REFCLK_FREQUENCY => ADC_SERDES_REFCLK_FREQUENCY,
    SIM_DEVICE       => ADC_SERDES_SIM_DEVICE,
    SIM_VERSION      => ADC_SERDES_SIM_VERSION,
    UPDATE_MODE      => ADC_SERDES_UPDATE_MODE
  )
  port map(
    CNTVALUEOUT => open,
    DATAOUT     => data_to_iddr,
    CASC_IN     => '0',
    CASC_RETURN => '0',
    CE          => '0',
    CLK         => adc_clk_divide_2_in,
    CNTVALUEIN => (others => '0'),
    DATAIN      => '0',
    EN_VTC      => '1',
    IDATAIN     => data_to_idelay,
    INC         => '0',
    LOAD        => '0',
    RST         => idelay_rst_n_in
  );

  IDDR_inst_data : IDDRE1
  generic map(
    DDR_CLK_EDGE   => "SAME_EDGE_PIPELINED", -- IDDRE1 mode (OPPOSITE_EDGE, SAME_EDGE, SAME_EDGE_PIPELINED)
    IS_CB_INVERTED => '1',                   -- Optional inversion for CB
    IS_C_INVERTED  => '0'                    -- Optional inversion for C
  )
  port map(
    Q1 => data_to_des_RE(0), -- 1-bit output: Registered parallel output 1
    Q2 => data_to_des_FE(0), -- 1-bit output: Registered parallel output 2
    C  => adc_dco_clk_in,    -- 1-bit input: High-speed clock
    CB => adc_dco_clk_in,    -- 1-bit input: Inversion of High-speed clock C
    D  => data_to_iddr,      -- 1-bit input: Serial Data Input
    R  => '0'                -- 1-bit input: Active-High Async Reset
  );

  ---- ADC FCO INPUTS

  IBUFDS_inst_frame : IBUFDS
  port map(
    O  => frame_to_idelay, -- Buffer output
    I  => adc_fco_p_in,    -- Diff_p buffer input (connect directly to top-level port)
    IB => adc_fco_n_in     -- Diff_n buffer input (connect directly to top-level port)
  );

  IDELAY_inst_frame : IDELAYE3
  generic map(
    CASCADE          => ADC_SERDES_CASCADE,
    DELAY_FORMAT     => ADC_SERDES_DELAY_FORMAT,
    DELAY_SRC        => ADC_SERDES_DELAY_SRC,
    DELAY_TYPE       => ADC_SERDES_DELAY_TYPE,
    DELAY_VALUE      => ADC_SERDES_DELAY_VALUE,
    IS_CLK_INVERTED  => ADC_SERDES_IS_CLK_INVERTED,
    IS_RST_INVERTED  => ADC_SERDES_IS_RST_INVERTED,
    LOOPBACK         => ADC_SERDES_LOOPBACK,
    REFCLK_FREQUENCY => ADC_SERDES_REFCLK_FREQUENCY,
    SIM_DEVICE       => ADC_SERDES_SIM_DEVICE,
    SIM_VERSION      => ADC_SERDES_SIM_VERSION,
    UPDATE_MODE      => ADC_SERDES_UPDATE_MODE
  )
  port map(
    CNTVALUEOUT => open,
    DATAOUT     => frame_to_iddr,
    CASC_IN     => '0',
    CASC_RETURN => '0',
    CE          => '0',
    CLK         => adc_clk_divide_2_in,
    CNTVALUEIN => (others => '0'),
    DATAIN      => '0',
    EN_VTC      => '1',
    IDATAIN     => frame_to_idelay,
    INC         => '0',
    LOAD        => '0',
    RST         => '1'
  );

  IDDR_inst_frame : IDDRE1
  generic map(
    DDR_CLK_EDGE   => "SAME_EDGE_PIPELINED", -- IDDRE1 mode (OPPOSITE_EDGE, SAME_EDGE, SAME_EDGE_PIPELINED)
    IS_CB_INVERTED => '1',                   -- Optional inversion for CB
    IS_C_INVERTED  => '0'                    -- Optional inversion for C
  )
  port map(
    Q1 => frame_to_des_RE(0), -- 1-bit output: Registered parallel output 1
    Q2 => frame_to_des_FE(0), -- 1-bit output: Registered parallel output 2
    C  => adc_dco_clk_in,     -- 1-bit input: High-speed clock
    CB => adc_dco_clk_in,     -- 1-bit input: Inversion of High-speed clock C
    D  => frame_to_iddr,      -- 1-bit input: Serial Data Input
    R  => '0'                 -- 1-bit input: Active-High Async Reset
  );

  iddr_to_parallel_inst : entity iddr_to_parallel_conv
    generic map(
      OUTPUT_WIDTH => RES_ADC
    )
    port map(
      sys_clk_in        => adc_dco_clk_in,
      sys_rst_n_in      => sys_rst_n_in,
      data_re_in        => data_to_des_RE(0),
      data_fe_in        => data_to_des_FE(0),
      frame_re_in       => frame_to_des_RE(0),
      frame_fe_in       => frame_to_des_FE(0),
      m_axis_tdata_out  => m_axis_tdata_out,
      m_axis_tvalid_out => m_axis_tvalid_out
    );

end rtl;
