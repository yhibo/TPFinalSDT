----------------------------------------------------------------------------------
-- Company:  Instituto Balseiro
-- Engineer: José Quinteros
--
-- Design Name:
-- Module Name:
-- Project Name:
-- Target Devices:
-- Tool Versions:
-- Description: ADC Receiver Synthesis Top
--
-- Dependencies: None.
--
-- Revision: 2022-05-30
-- Additional Comments:
-- Note that this is a synthesis wrapper, instantiating a block design which has
-- an AXI-4 interface. This interface is not meant to be synthesized, it's only
-- meant for simulation.
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
library UNISIM;
use UNISIM.VCOMPONENTS.all;
library xil_defaultlib;

entity adc_receiver_syn_top is
  port (
    adc_data_n_in : in std_logic;
    adc_data_p_in : in std_logic;
    adc_dco_n_in  : in std_logic;
    adc_dco_p_in  : in std_logic;
    adc_fco_n_in  : in std_logic;
    adc_fco_p_in  : in std_logic;
    adc_sclk_o    : out std_logic;
    adc_sdio_o    : out std_logic;
    adc_ss1_o     : out std_logic;
    adc_ss2_o     : out std_logic
  );
end adc_receiver_syn_top;

architecture rtl of adc_receiver_syn_top is
  signal S02_ACLK : std_logic;
  signal S02_ARESETN : std_logic;
  signal S02_AXI_araddr : std_logic_vector (39 downto 0);
  signal S02_AXI_arburst : std_logic_vector (1 downto 0);
  signal S02_AXI_arcache : std_logic_vector (3 downto 0);
  signal S02_AXI_arid : std_logic_vector (1 downto 0);
  signal S02_AXI_arlen : std_logic_vector (7 downto 0);
  signal S02_AXI_arlock : std_logic_vector (0 to 0);
  signal S02_AXI_arprot : std_logic_vector (2 downto 0);
  signal S02_AXI_arqos : std_logic_vector (3 downto 0);
  signal S02_AXI_arready : std_logic;
  signal S02_AXI_arregion : std_logic_vector (3 downto 0);
  signal S02_AXI_arsize : std_logic_vector (2 downto 0);
  signal S02_AXI_aruser : std_logic_vector (15 downto 0);
  signal S02_AXI_arvalid : std_logic;
  signal S02_AXI_awaddr : std_logic_vector (39 downto 0);
  signal S02_AXI_awburst : std_logic_vector (1 downto 0);
  signal S02_AXI_awcache : std_logic_vector (3 downto 0);
  signal S02_AXI_awid : std_logic_vector (1 downto 0);
  signal S02_AXI_awlen : std_logic_vector (7 downto 0);
  signal S02_AXI_awlock : std_logic_vector (0 to 0);
  signal S02_AXI_awprot : std_logic_vector (2 downto 0);
  signal S02_AXI_awqos : std_logic_vector (3 downto 0);
  signal S02_AXI_awready : std_logic;
  signal S02_AXI_awregion : std_logic_vector (3 downto 0);
  signal S02_AXI_awsize : std_logic_vector (2 downto 0);
  signal S02_AXI_awuser : std_logic_vector (15 downto 0);
  signal S02_AXI_awvalid : std_logic;
  signal S02_AXI_bid : std_logic_vector (1 downto 0);
  signal S02_AXI_bready : std_logic;
  signal S02_AXI_bresp : std_logic_vector (1 downto 0);
  signal S02_AXI_bvalid : std_logic;
  signal S02_AXI_rdata : std_logic_vector (31 downto 0);
  signal S02_AXI_rid : std_logic_vector (1 downto 0);
  signal S02_AXI_rlast : std_logic;
  signal S02_AXI_rready : std_logic;
  signal S02_AXI_rresp : std_logic_vector (1 downto 0);
  signal S02_AXI_rvalid : std_logic;
  signal S02_AXI_wdata : std_logic_vector (31 downto 0);
  signal S02_AXI_wlast : std_logic;
  signal S02_AXI_wready : std_logic;
  signal S02_AXI_wstrb : std_logic_vector (3 downto 0);
  signal S02_AXI_wvalid : std_logic;
begin

  bd_wrapper_inst : entity adc_receiver_bd_wrapper
    port map(
      S02_ACLK         => S02_ACLK,
      S02_ARESETN      => S02_ARESETN,
      S02_AXI_araddr   => S02_AXI_araddr,
      S02_AXI_arburst  => S02_AXI_arburst,
      S02_AXI_arcache  => S02_AXI_arcache,
      S02_AXI_arid     => S02_AXI_arid,
      S02_AXI_arlen    => S02_AXI_arlen,
      S02_AXI_arlock   => S02_AXI_arlock,
      S02_AXI_arprot   => S02_AXI_arprot,
      S02_AXI_arqos    => S02_AXI_arqos,
      S02_AXI_arready  => S02_AXI_arready,
      S02_AXI_arregion => S02_AXI_arregion,
      S02_AXI_arsize   => S02_AXI_arsize,
      S02_AXI_aruser   => S02_AXI_aruser,
      S02_AXI_arvalid  => S02_AXI_arvalid,
      S02_AXI_awaddr   => S02_AXI_awaddr,
      S02_AXI_awburst  => S02_AXI_awburst,
      S02_AXI_awcache  => S02_AXI_awcache,
      S02_AXI_awid     => S02_AXI_awid,
      S02_AXI_awlen    => S02_AXI_awlen,
      S02_AXI_awlock   => S02_AXI_awlock,
      S02_AXI_awprot   => S02_AXI_awprot,
      S02_AXI_awqos    => S02_AXI_awqos,
      S02_AXI_awready  => S02_AXI_awready,
      S02_AXI_awregion => S02_AXI_awregion,
      S02_AXI_awsize   => S02_AXI_awsize,
      S02_AXI_awuser   => S02_AXI_awuser,
      S02_AXI_awvalid  => S02_AXI_awvalid,
      S02_AXI_bid      => S02_AXI_bid,
      S02_AXI_bready   => S02_AXI_bready,
      S02_AXI_bresp    => S02_AXI_bresp,
      S02_AXI_bvalid   => S02_AXI_bvalid,
      S02_AXI_rdata    => S02_AXI_rdata,
      S02_AXI_rid      => S02_AXI_rid,
      S02_AXI_rlast    => S02_AXI_rlast,
      S02_AXI_rready   => S02_AXI_rready,
      S02_AXI_rresp    => S02_AXI_rresp,
      S02_AXI_rvalid   => S02_AXI_rvalid,
      S02_AXI_wdata    => S02_AXI_wdata,
      S02_AXI_wlast    => S02_AXI_wlast,
      S02_AXI_wready   => S02_AXI_wready,
      S02_AXI_wstrb    => S02_AXI_wstrb,
      S02_AXI_wvalid   => S02_AXI_wvalid,
      adc_data_n_in    => adc_data_n_in,
      adc_data_p_in    => adc_data_p_in,
      adc_dco_n_in     => adc_dco_n_in,
      adc_dco_p_in     => adc_dco_p_in,
      adc_fco_n_in     => adc_fco_n_in,
      adc_fco_p_in     => adc_fco_p_in,
      adc_sclk_o       => adc_sclk_o,
      adc_sdio_o       => adc_sdio_o,
      adc_ss1_o        => adc_ss1_o,
      adc_ss2_o        => adc_ss2_o
    );

end architecture rtl;
