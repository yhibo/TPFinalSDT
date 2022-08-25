//--------------------------------------------------------------------------------
// Institution: Instituto Balseiro
// Deve:        Maia Desamo
//
// Design Name: TP final
// Module Name:
// Project Name:
// Target Devices:
// Tool Versions:
// Description: Ejemplos básicos de Testbench UVM
//
// Dependencies: None.
//
// Revision:
// Additional Comments:
//
//--------------------------------------------------------------------------------

package axi_example_defn_pkg;

  // TB Top definitions.
  localparam int RESET_CLOCK_COUNT = 10;
  localparam int CLK_FREQ_HZ = 125e3;
  localparam time CLK_PERIOD = 1s / CLK_FREQ_HZ;

  localparam logic[6:0] OFFSET_ADDR = 7'b0_0000_00;
  localparam logic[6:0] CORE_ID_ADDR = 7'b0_0000_00;
  localparam logic[6:0] DATE_ADDR = 7'b0_0001_00;
  localparam int DATA_WIDTH=32;
  localparam int ADDR_WIDTH=7;
  localparam int WSTRB_WIDTH = DATA_WIDTH / 8;
  localparam logic[WSTRB_WIDTH-1:0] WSTRB_AGREGADO = 4'b1111;


endpackage : axi_example_defn_pkg