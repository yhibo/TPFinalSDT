module tb_top;

  // Imports.
  import uvm_pkg::*;
  import tb_defn_pkg::*;
  import tb_test_pkg::*;

  `include "uvm_macros.svh"

  // Clock and reset signals.
  logic axi_clk;
  logic adc_clk;
  logic rst_n;
  logic aux_rst_n;
  logic cpo;  //señal a conectar al DUT en cpo
  logic fco;  //señal a conectar al DUT en fco
  logic pd;  //señal a conectar al DUT en pd

  stream_if #(
      .DATA_WIDTH(3)
  ) stream_if_inst (
      .rst_n(aux_rst_n),
      .clk  (adc_clk)
  );
  assign stream_if_inst.ready = 1'b1;

  stream_ADDR1_if awaddr_if (
      .clk  (axi_clk),
      .rst_n(aux_rst_n)
  );

  stream_if #(
      .DATA_WIDTH(DATA_WIDTH + WSTRB_WIDTH)
  ) wdata_if (
      .clk  (axi_clk),
      .rst_n(aux_rst_n)
  );

  stream_slave_if #(
      .DATA_WIDTH(2)
  ) bresp_if (
      .clk  (axi_clk),
      .rst_n(aux_rst_n)
  );

 stream_ADDR2_if  araddr_if (
      .clk  (axi_clk),
      .rst_n(aux_rst_n)
  );


  stream_slave_if #(
      .DATA_WIDTH(DATA_WIDTH + 2)
  ) rresp_if (
      .clk  (axi_clk),
      .rst_n(aux_rst_n)
  );

  always_comb begin
    cpo <= #(ADC_CLK_PERIOD / 2) stream_if_inst.data[2];
    fco <= stream_if_inst.data[1];
    pd  <= stream_if_inst.data[0];
  end




  adc_receiver_bd_wrapper adc_receiver_bd_wrapper_inst (
      .adc_data_p_in(pd),
      .adc_data_n_in(~pd),
      .adc_dco_p_in(cpo),
      .adc_dco_n_in(~cpo),
      .adc_fco_p_in(fco),
      .adc_fco_n_in(~fco),
      .ext_resetn(rst_n),

      .S02_ACLK(axi_clk),
      .S02_ARESETN(rst_n),

    .S02_AXI_araddr (araddr_if.data[ADDR_WIDTH-1:0]),
    .S02_AXI_arprot (3'b0),
    .S02_AXI_arready(araddr_if.ready),
    .S02_AXI_arvalid(araddr_if.valid),
    .S02_AXI_awaddr (awaddr_if.data),
    .S02_AXI_awprot (3'b0),
    .S02_AXI_awready (awaddr_if.ready),
    .S02_AXI_awvalid (awaddr_if.valid),
    .S02_AXI_bready (bresp_if.ready),
    .S02_AXI_bresp (bresp_if.data[1:0]),
    .S02_AXI_bvalid (bresp_if.valid),
    .S02_AXI_rdata (rresp_if.data[DATA_WIDTH-1:0]),
    .S02_AXI_rready (rresp_if.ready),
    .S02_AXI_rresp (rresp_if.data[DATA_WIDTH + 1:DATA_WIDTH ]),
    .S02_AXI_rvalid (rresp_if.valid),
    .S02_AXI_wdata (wdata_if.data[DATA_WIDTH+WSTRB_WIDTH-1:WSTRB_WIDTH]),
    .S02_AXI_wready (wdata_if.ready),
    .S02_AXI_wstrb (wdata_if.data[WSTRB_WIDTH-1:0]),
    .S02_AXI_wvalid (wdata_if.valid)
  );


  // Clock and reset initial block.
  // Clock and reset initial block.
  initial begin

    fork
        begin
            // Initialize clock to 0 and reset_n to TRUE.
            adc_clk   = 0;
            rst_n = 0;
            aux_rst_n = 0;
            // Wait for reset completion (RESET_CLOCK_COUNT).
            repeat (RESET_CLOCK_COUNT) begin
            #(ADC_CLK_PERIOD / 2) adc_clk = 0;
            #(ADC_CLK_PERIOD - ADC_CLK_PERIOD / 2) adc_clk = 1;
            end

            aux_rst_n = 1;

            repeat (RESET_CLOCK_COUNT) begin
            #(ADC_CLK_PERIOD / 2) adc_clk = 0;
            #(ADC_CLK_PERIOD - ADC_CLK_PERIOD / 2) adc_clk = 1;
            end

            // Set rst to FALSE.
            rst_n = 1;
            forever begin
            #(ADC_CLK_PERIOD / 2) adc_clk = 0;
            #(ADC_CLK_PERIOD - ADC_CLK_PERIOD / 2) adc_clk = 1;
            end
        end

        begin
            // Initialize clock to 0 and reset_n to TRUE.
            axi_clk   = 0;
            forever begin
            #(AXI_CLK_PERIOD / 2) axi_clk = 0;
            #(AXI_CLK_PERIOD - AXI_CLK_PERIOD / 2) axi_clk = 1;
            end
        end
    join
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

    awaddr_if.register_interface("awaddr_if");
    wdata_if.register_interface("wdata_if");
    bresp_if.register_interface("bresp_if");

    araddr_if.register_interface("araddr_if");
    rresp_if.register_interface("rresp_if");

    // Test name must be set from the simulator's command line.
    run_test();
    $stop();
  end



endmodule : tb_top
