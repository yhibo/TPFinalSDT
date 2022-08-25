module modem_top;

  // Imports.
  import uvm_pkg::*;
  import modem_defn_pkg::*;
  import modem_test_pkg::*;


  `include "uvm_macros.svh"

  // Clock and reset signals.
  logic clk;
  logic rst_n;
  logic aux_rst_n;
  logic cpo;  //señal a conectar al DUT en cpo
  logic fco;  //señal a conectar al DUT en fco
  logic pd;  //señal a conectar al DUT en pd

  stream_if #(
      .DATA_WIDTH(3)
  ) stream_if_inst (
      .rst_n(aux_rst_n),
      .clk  (clk)
  );
  assign stream_if_inst.ready = 1'b1;

  always_comb begin
    cpo <= #(CLK_PERIOD / 2) stream_if_inst.data[2];
    fco <= stream_if_inst.data[1];
    pd  <= stream_if_inst.data[0];
  end

  //DUT
  adc_receiver_syn_top adc_receiver_syn_top_inst (
      .ext_resetn(rst_n),
      .adc_data_p_in(pd),
      .adc_data_n_in(~pd),
      .adc_dco_p_in(cpo),
      .adc_dco_n_in(~cpo),
      .adc_fco_p_in(fco),
      .adc_fco_n_in(~fco)
  );

  // dut DUT (
  //     .clk_i(clk),
  //     .rst_ni(rst_n),

  //     .valid_i(stream_if_inst.valid),
  //     .ready_o(stream_if_inst.ready),
  //     .last_i(stream_if_inst.data[1]),
  //     .eth_i(stream_if_inst.data[0]),

  //     .sc_o(xcvr_inst.data[7:0])
  // );

  // Clock and reset initial block.
  // Clock and reset initial block.
  initial begin
    // Initialize clock to 0 and reset_n to TRUE.
    clk   = 0;
    rst_n = 0;
    aux_rst_n = 0;
    #(CLK_PERIOD/2) clk <= ~clk;
    // Wait for reset completion (RESET_CLOCK_COUNT).
    repeat (RESET_CLOCK_COUNT) begin
      #(CLK_PERIOD / 2) clk = 0;
      #(CLK_PERIOD - CLK_PERIOD / 2) clk = 1;
    end

    aux_rst_n = 1;

    repeat (RESET_CLOCK_COUNT) begin
      #(CLK_PERIOD / 2) clk = 0;
      #(CLK_PERIOD - CLK_PERIOD / 2) clk = 1;
    end
    // Set rst to FALSE.
    rst_n = 1;
    forever begin
      #(CLK_PERIOD / 2) clk = 0;
      #(CLK_PERIOD - CLK_PERIOD / 2) clk = 1;
    end
  end


  initial begin
    // Set default verbosity level for all TB components.
    uvm_top.set_report_verbosity_level(UVM_HIGH);
    // Set time format for simulation.
    $timeformat(-12, 1, " ps", 1);

    // Configure some simulation options.
    uvm_top.enable_print_topology = 1;
    uvm_top.finish_on_completion  = 0;
    // Register concrete classes
    stream_if_inst.register_interface("stream_if");

    // Test name must be set from the simulator's command line.
    run_test();
    $stop();
  end



endmodule : modem_top
