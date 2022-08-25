package tb_defn_pkg;

  // TB Top definitions.
  localparam int RESET_CLOCK_COUNT = 50;
  localparam int ADC_CLK_FREQ_HZ = 455e6*2;
  localparam realtime ADC_CLK_PERIOD = 1s / ADC_CLK_FREQ_HZ;

  localparam int AXI_CLK_FREQ_HZ = 100e6;
  localparam time AXI_CLK_PERIOD = 1s / AXI_CLK_FREQ_HZ;

  localparam logic[39:0] OFFSET_ADDR = 40'h00_44A0_0000;
  localparam logic[4:0] CORE_ID_ADDR = 5'b00000;
  localparam logic[4:0] DATE_ADDR = 5'b00100;
  localparam logic[4:0] FIFO_EN_ADDR = 5'b01000;
  localparam logic[4:0] SEL_SOURCE_ADDR = 5'b01100;
  localparam logic[4:0] SEL_FIR_ADDR = 5'b10000;
  localparam int DATA_WIDTH=32;
  localparam int ADDR_WIDTH=40;
  localparam int WSTRB_WIDTH = DATA_WIDTH / 8;
  localparam logic[WSTRB_WIDTH-1:0] WSTRB_AGREGADO = 4'b1111;

  localparam real FREQ_TONO_GHz = 0.01725;
  localparam real FREQ_TONO_GHz_2 = 0.0163;
  localparam real PI_CONST = 3.14159265;
  localparam int LARGO_TONO = 50000;

  localparam int SIM_PKT_NUM = 10;

  localparam int ADC_WIDTH = 14;

endpackage : tb_defn_pkg