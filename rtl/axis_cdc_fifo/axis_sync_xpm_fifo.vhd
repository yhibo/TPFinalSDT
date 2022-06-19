----------------------------------------------------------------------------------
-- Company:  Instituto Balseiro
-- Engineer: José Quinteros
--
-- Design Name:
-- Module Name:
-- Project Name:
-- Target Devices:
-- Tool Versions:
-- Description: AXI-S XPM synchronous FIFO wrapper
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
library xpm;
use xpm.vcomponents.all;

entity axis_sync_xpm_fifo is
  generic (
    TDATA_WIDTH : integer := 128;
    FIFO_DEPTH  : integer := 32768
  );
  port (
    s_aclk        : in std_logic;
    s_aresetn     : in std_logic;
    s_axis_tdata  : in std_logic_vector(TDATA_WIDTH - 1 downto 0);
    s_axis_tlast  : in std_logic;
    s_axis_tvalid : in std_logic;
    s_axis_tready : out std_logic;
    m_axis_tdata  : out std_logic_vector(TDATA_WIDTH - 1 downto 0);
    m_axis_tlast  : out std_logic;
    m_axis_tvalid : out std_logic;
    m_axis_tready : in std_logic
  );
end entity axis_sync_xpm_fifo;

architecture rtl of axis_sync_xpm_fifo is

begin

  xpm_fifo_axis_inst : xpm_fifo_axis
  generic map(
    CLOCKING_MODE       => "common_clock",
    FIFO_DEPTH          => 32768,
    FIFO_MEMORY_TYPE    => "ultra",
    PACKET_FIFO         => "false",
    RD_DATA_COUNT_WIDTH => 16,
    RELATED_CLOCKS      => 0,
    SIM_ASSERT_CHK      => 1,
    TDATA_WIDTH         => TDATA_WIDTH,
    USE_ADV_FEATURES    => "1000"
  )
  port map(
    almost_empty_axis  => open,

    almost_full_axis   => open,

    dbiterr_axis       => open,

    m_axis_tdata       => m_axis_tdata,
    m_axis_tdest       => open,
    m_axis_tid         => open,
    m_axis_tkeep       => open,

    m_axis_tlast       => m_axis_tlast,
    m_axis_tstrb       => open,
    m_axis_tuser       => open,

    m_axis_tvalid      => m_axis_tvalid,

    prog_empty_axis    => open,

    prog_full_axis     => open,

    rd_data_count_axis => open,

    s_axis_tready      => s_axis_tready,
    sbiterr_axis       => open,
    wr_data_count_axis => open,
    injectdbiterr_axis => '0',
    injectsbiterr_axis => '0',
    m_aclk             => s_aclk,
    m_axis_tready      => m_axis_tready,
    s_aclk             => s_aclk,
    s_aresetn          => s_aresetn,
    s_axis_tdata       => s_axis_tdata,
    s_axis_tdest => (others => '0'),
    s_axis_tid => (others => '0'),
    s_axis_tkeep => (others => '1'),

    s_axis_tlast       => s_axis_tlast,
    s_axis_tstrb => (others => '1'),
    s_axis_tuser => (others => '0'),

    s_axis_tvalid      => s_axis_tvalid

  );
end architecture rtl;
