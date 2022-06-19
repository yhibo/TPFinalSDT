----------------------------------------------------------------------------------
-- Company:  Instituto Balseiro
-- Engineer: José Quinteros
--
-- Design Name:
-- Module Name:
-- Project Name:
-- Target Devices:
-- Tool Versions:
-- Description: AXI-S CDC FIFO top
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

library fifo_async;
use fifo_async.fifo_generator_wr;
library axis_cdc_fifo;

entity axis_cdc_fifo_top is
  port (
    s_aclk           : in std_logic;
    s_aresetn        : in std_logic;
    s_re_axis_tvalid : in std_logic;
    s_re_axis_tready : out std_logic;
    s_re_axis_tdata  : in std_logic_vector(31 downto 0);
    s_re_axis_tlast  : in std_logic;
    s_im_axis_tvalid : in std_logic;
    s_im_axis_tready : out std_logic;
    s_im_axis_tdata  : in std_logic_vector(31 downto 0);
    s_im_axis_tlast  : in std_logic;

    fifo_enable_in   : in std_logic;
    fifo_full_out    : out std_logic;

    m_aclk           : in std_logic;
    m_aresetn        : in std_logic;
    m_axis_tvalid    : out std_logic;
    m_axis_tready    : in std_logic;
    m_axis_tdata     : out std_logic_vector(63 downto 0);
    m_axis_tlast     : out std_logic
  );
end entity axis_cdc_fifo_top;

architecture rtl of axis_cdc_fifo_top is
  signal axis_tdata : std_logic_vector(63 downto 0);
  signal axis_tvalid : std_logic;
  signal axis_tvalid_inter_fifos : std_logic;
  signal axis_tready_inter_fifos : std_logic;
  signal axis_tdata_inter_fifos : std_logic_vector(63 downto 0);
  signal axis_tlast_inter_fifos : std_logic;
  signal re_axis_tready : std_logic;
  signal im_axis_tready : std_logic;
begin

  s_re_axis_tready <= re_axis_tready;
  s_im_axis_tready <= im_axis_tready;
  fifo_full_out <= not(re_axis_tready and im_axis_tready);
  axis_tdata <= s_im_axis_tdata & s_re_axis_tdata;
  axis_tvalid <= s_re_axis_tvalid and s_im_axis_tvalid and fifo_enable_in;

  fifo_async_inst : entity fifo_generator_wr
    port map(
      wr_rst_busy    => open,
      rd_rst_busy    => open,
      m_aclk         => m_aclk,
      s_aclk         => s_aclk,
      s_aresetn      => s_aresetn,
      s_axis_tvalid  => axis_tvalid,
      s_axis_tready  => s_re_axis_tready,
      s_axis_tdata   => axis_tdata,
      s_axis_tlast   => s_re_axis_tlast,
      m_axis_tvalid  => axis_tvalid_inter_fifos,
      m_axis_tready  => axis_tready_inter_fifos,
      m_axis_tdata   => axis_tdata_inter_fifos,
      m_axis_tlast   => axis_tlast_inter_fifos,
      axis_prog_full => open
    );

  fifo_sync_inst : entity axis_cdc_fifo.axis_sync_xpm_fifo
    generic map(
      TDATA_WIDTH => 64,
      FIFO_DEPTH  => 32768
    )
    port map(
      s_aclk        => m_aclk,
      s_aresetn     => m_aresetn,
      s_axis_tdata  => axis_tdata_inter_fifos,
      s_axis_tlast  => axis_tlast_inter_fifos,
      s_axis_tvalid => axis_tvalid_inter_fifos,
      s_axis_tready => axis_tready_inter_fifos,
      m_axis_tdata  => m_axis_tdata,
      m_axis_tlast  => m_axis_tlast,
      m_axis_tvalid => m_axis_tvalid,
      m_axis_tready => m_axis_tready
    );

end architecture rtl;
