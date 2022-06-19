package modem_defn_pkg;

  // TB Top definitions.
  localparam int RESET_CLOCK_COUNT = 10;
  localparam int CLK_FREQ_HZ = 125e6;
  localparam time CLK_PERIOD = 1s / CLK_FREQ_HZ;
  localparam real FREQ_TONO_GHz = 0.03721;
  localparam real PI_CONST = 3.14159265;
  localparam int LARGO_TONO = 500;

  localparam int SIM_PKT_NUM = 10;

  localparam int ADC_WIDTH = 14;

 

endpackage : modem_defn_pkg