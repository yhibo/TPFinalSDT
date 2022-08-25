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

// Package: axi_example_vseq_pkg
// Package of the sequencies used to estimulate the DUT

package axi_example_vseq_pkg;
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  import axi_example_defn_pkg::*;

  import stream_agent_pkg::*;
  import stream_ADDR1_agent_pkg::*;
  import stream_ADDR2_agent_pkg::*;
  import stream_slave_agent_pkg::*;



  class axi4lite_vseq_base extends uvm_sequence #(uvm_sequence_item);
    // UVM Factory Registration Macro
    `uvm_object_utils(axi4lite_vseq_base)

    // Sequencer for any sequencie item
    stream_ADDR1_sequencer awaddr_sqr;
    stream_sequencer wdata_sqr;
    stream_slave_sequencer bresp_sqr;


    stream_ADDR2_sequencer araddr_sqr;
    stream_slave_sequencer rresp_sqr;


    // Register map
    uvm_status_e status;

    function new(string name = "axi4lite_vseq_base");
      super.new(name);
    endfunction : new

    task body;

    endtask : body

  endclass : axi4lite_vseq_base



class axi4lite_seq_read extends axi4lite_vseq_base;
  `uvm_object_utils(axi4lite_seq_read)

  rand logic [ADDR_WIDTH-1:0] addr;

  function new(string name = "axi4lite_seq_read");
    super.new(name);
  endfunction : new

  task body();
     stream_ADDR2_seq_item stream_araddr_seq_item;
     stream_slave_seq_item stream_slave_rresp_seq_item;

    
    stream_araddr_seq_item = stream_ADDR2_seq_item::type_id::create("stream_araddr_seq_item");
    stream_slave_rresp_seq_item = stream_slave_seq_item::type_id::create("stream_slave_rresp_seq_item");

    fork
      begin
         start_item(stream_araddr_seq_item,.sequencer(araddr_sqr));

         if (!stream_araddr_seq_item.randomize() with {
            data == local:: addr;
            delay_cycles == 0;
          }) begin
        `uvm_error("axi4lite_seq_read_stream", "Failed to randomize seq!");
          end
         finish_item(stream_araddr_seq_item);

      end
      begin
        start_item(stream_slave_rresp_seq_item,.sequencer(rresp_sqr));
        if (!stream_slave_rresp_seq_item.randomize() with {
            delay_cycles == 0;
          }) begin
        `uvm_error("axi4lite_seq_read_stream_slave", "Failed to randomize seq!");
          end
         finish_item(stream_slave_rresp_seq_item);
      end
    join

    `uvm_info("axi4lite_seq_read", {$sformatf("\nLectura de registro: \n adress:%b\n data:%h\n",addr,stream_slave_rresp_seq_item.data[DATA_WIDTH-1:0])},UVM_HIGH);


  endtask

  

endclass : axi4lite_seq_read




class axi4lite_seq_write extends axi4lite_vseq_base;
  `uvm_object_utils(axi4lite_seq_write)

  rand logic [ADDR_WIDTH-1:0] addr;
  rand logic [DATA_WIDTH-1:0] data;

  function new(string name = "axi4lite_seq_write");
    super.new(name);
  endfunction : new

  task body();
     stream_ADDR1_seq_item stream_awaddr_seq_item;
     stream_seq_item stream_wdata_seq_item;
     stream_slave_seq_item stream_slave_bresp_seq_item;

    
    stream_awaddr_seq_item = stream_ADDR1_seq_item::type_id::create("stream_awaddr_seq_item");
    stream_wdata_seq_item = stream_seq_item::type_id::create("stream_wdata_seq_item");
    stream_slave_bresp_seq_item = stream_slave_seq_item::type_id::create("stream_slave_bresp_seq_item");

    fork
      begin
         start_item(stream_awaddr_seq_item,.sequencer(awaddr_sqr));

         if (!stream_awaddr_seq_item.randomize() with {
            data == local:: addr;
            delay_cycles == 0;
          }) begin
        `uvm_error("axi4lite_seq_write_stream1", "Failed to randomize seq!");
          end
         finish_item(stream_awaddr_seq_item);

      end
      begin
         start_item(stream_wdata_seq_item,.sequencer(wdata_sqr));

         if (!stream_wdata_seq_item.randomize() with {
            delay_cycles == 0;
          }) begin
        `uvm_error("axi4lite_seq_write_stream2", "Failed to randomize seq!");
          end

          stream_wdata_seq_item.data = {data,WSTRB_AGREGADO};
         finish_item(stream_wdata_seq_item);

      end
      begin
        start_item(stream_slave_bresp_seq_item,.sequencer(bresp_sqr));
        if (!stream_slave_bresp_seq_item.randomize() with {
            delay_cycles == 0;
          }) begin
        `uvm_error("axi4lite_seq_write_stream_slave", "Failed to randomize seq!");
          end
         finish_item(stream_slave_bresp_seq_item);
      end
    join

    `uvm_info("axi4lite_seq_write", {$sformatf("\nEscritura de registro: \n adress:%b\n data:%h\n bresp:%2b\n",addr,data,stream_slave_bresp_seq_item.data)},UVM_HIGH);


  endtask

  

endclass : axi4lite_seq_write



endpackage : axi_example_vseq_pkg
