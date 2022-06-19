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
`timescale 1ps/1ps
module axi_example_top;

  // Imports.
  import uvm_pkg::*;
  import axi_example_defn_pkg::*;
  import axi_example_test_pkg::*;


  `include "uvm_macros.svh"

  // Clock and reset signals.
  logic clk;
  logic rst_n;
  logic [15:0] a; //señal a conectar al DUT en cpo
  logic [15:0] b; //señal a conectar al DUT en fco
  logic [15:0] c; //señal a conectar al DUT en pd

  assign a = 16'h5;
  assign b = 16'h6;
  assign c = 16'h7;

  stream_ADDR1_if awaddr_if (
      .clk  (clk),
      .rst_n(rst_n)
  );

  stream_if #(
      .DATA_WIDTH(DATA_WIDTH + WSTRB_WIDTH)
  ) wdata_if (
      .clk  (clk),
      .rst_n(rst_n)
  );

  stream_slave_if #(
      .DATA_WIDTH(2)
  ) bresp_if (
      .clk  (clk),
      .rst_n(rst_n)
  );






 stream_ADDR2_if  araddr_if (
      .clk  (clk),
      .rst_n(rst_n)
  );


  stream_slave_if #(
      .DATA_WIDTH(DATA_WIDTH + 2)
  ) rresp_if (
      .clk  (clk),
      .rst_n(rst_n)
  );

tp2_no_pipeline #(
  .DATA_WIDTH(16)
) no_pipeline_inst(


   .clk_i(clk), 
   .srst_i(~rst_n),
   .selop1_i(registros.selop1_out), 
   .selop2_i(registros.selop2_out),
   .selout1_i(registros.selout1_out), 
   .selout2_i(registros.selout2_out),
   .a_i(a),
   .b_i(b),
   .c_i(c),
   .x_o()
);

axi4lite_regs_dut#(
  .C_S_AXI_DATA_WIDTH(32),
	.C_S_AXI_ADDR_WIDTH(7)
) registros (
  .S_AXI_ACLK(clk),
  .S_AXI_ARESETN(rst_n),

  .S_AXI_AWADDR(awaddr_if.data),
  .S_AXI_AWPROT(3'b0),
  .S_AXI_AWVALID(awaddr_if.valid),
  .S_AXI_AWREADY(awaddr_if.ready),

  .S_AXI_WDATA(wdata_if.data[DATA_WIDTH+WSTRB_WIDTH-1:WSTRB_WIDTH]),
  .S_AXI_WSTRB(wdata_if.data[WSTRB_WIDTH-1:0]),
  .S_AXI_WVALID( wdata_if.valid),
  .S_AXI_WREADY(wdata_if.ready),

  .S_AXI_BRESP(bresp_if.data[1:0]),
  .S_AXI_BVALID(bresp_if.valid),
  .S_AXI_BREADY(bresp_if.ready),

  .S_AXI_ARADDR(araddr_if.data[DATA_WIDTH-1:0]),
  .S_AXI_ARPROT(3'b0),
  .S_AXI_ARVALID(araddr_if.valid),
  .S_AXI_ARREADY(araddr_if.ready),

  .S_AXI_RDATA(rresp_if.data[DATA_WIDTH-1:0]),
  .S_AXI_RRESP(rresp_if.data[DATA_WIDTH + 1:DATA_WIDTH ]),
  .S_AXI_RVALID(rresp_if.valid),
  .S_AXI_RREADY(rresp_if.ready)

);


  // Clock and reset initial block.
  // Clock and reset initial block.
  initial begin
    // Initialize clock to 0 and reset_n to TRUE.
    clk   = 0;
    rst_n = 0;
    // Wait for reset completion (RESET_CLOCK_COUNT).
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
    awaddr_if.register_interface("awaddr_if");
    wdata_if.register_interface("wdata_if");
    bresp_if.register_interface("bresp_if");

    araddr_if.register_interface("araddr_if");
    rresp_if.register_interface("rresp_if");
    

    // Test name must be set from the simulator's command line.
    run_test();
    $stop();
  end



  endmodule : axi_example_top