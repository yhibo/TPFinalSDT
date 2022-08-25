----------------------------------------------------------------------------------
-- Company:  Instituto Balseiro
-- Engineer: José Quinteros
--
-- Design Name:
-- Module Name:
-- Project Name:
-- Target Devices:
-- Tool Versions:
-- Description: FIFO Generator IP Wrapper
--
-- Dependencies: None.
--
-- Revision: 2022-05-22
-- Additional Comments:
--
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library fifo_async;

entity fifo_generator_wr is
  port (
    wr_rst_busy    : out std_logic;
    rd_rst_busy    : out std_logic;
    m_aclk         : in std_logic;
    s_aclk         : in std_logic;
    s_aresetn      : in std_logic;
    s_axis_tvalid  : in std_logic;
    s_axis_tready  : out std_logic;
    s_axis_tdata   : in std_logic_vector (63 downto 0);
    s_axis_tlast   : in std_logic;
    m_axis_tvalid  : out std_logic;
    m_axis_tready  : in std_logic;
    m_axis_tdata   : out std_logic_vector (63 downto 0);
    m_axis_tlast   : out std_logic;
    axis_prog_full : out std_logic

  );

end fifo_generator_wr;

architecture rtl of fifo_generator_wr is

  component fifo_generator
    port (
      wr_rst_busy    : out std_logic;
      rd_rst_busy    : out std_logic;
      m_aclk         : in std_logic;
      s_aclk         : in std_logic;
      s_aresetn      : in std_logic;
      s_axis_tvalid  : in std_logic;
      s_axis_tready  : out std_logic;
      s_axis_tdata   : in std_logic_vector (63 downto 0);
      s_axis_tlast   : in std_logic;
      m_axis_tvalid  : out std_logic;
      m_axis_tready  : in std_logic;
      m_axis_tdata   : out std_logic_vector (63 downto 0);
      m_axis_tlast   : out std_logic;
      axis_prog_full : out std_logic

    );
  end component;

begin

  FIFO_generator_inst : fifo_generator
  port map(
    wr_rst_busy    => wr_rst_busy,
    rd_rst_busy    => rd_rst_busy,
    m_aclk         => m_aclk,
    s_aclk         => s_aclk,
    s_aresetn      => s_aresetn,
    s_axis_tvalid  => s_axis_tvalid,
    s_axis_tready  => s_axis_tready,
    s_axis_tdata   => s_axis_tdata,
    s_axis_tlast   => s_axis_tlast,
    m_axis_tvalid  => m_axis_tvalid,
    m_axis_tready  => m_axis_tready,
    m_axis_tdata   => m_axis_tdata,
    m_axis_tlast   => m_axis_tlast,
    axis_prog_full => axis_prog_full

  );
end rtl;
