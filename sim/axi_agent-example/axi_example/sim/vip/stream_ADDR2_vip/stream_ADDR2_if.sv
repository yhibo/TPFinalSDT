// :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
//                    ______          __            __                         :
//                   / ____/___ ___  / /____  _____/ /_                        :
//                  / __/ / __ `__ \/ __/ _ \/ ___/ __ \                       :
//                 / /___/ / / / / / /_/  __/ /__/ / / /                       :
//                /_____/_/ /_/ /_/\__/\___/\___/_/ /_/                        :
//                                                                             :
// This file contains confidential and proprietary information of Emtech SA.   :
// Any unauthorized copying, alteration, distribution, transmission,           :
// performance, display or other use of this material is prohibited.           :
// :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
//                                                                             :
// Client             :                                                        :
// Version            : 1.0                                                    :
// Application        : Generic                                                :
// Filename           : stream_if.sv                                           :
// Date Last Modified : 2021 SEP 16                                            :
// Date Created       : 2021 SEP 16                                            :
// Device             : Generic                                                :
// Design Name        : Generic                                                :
// Purpose            : Stream interface                                       :
// :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
//
// Detailed Description:
//
//
// ----------------------------------------------------------------------------

`ifndef STREAM_ADDR2_IF_SVH
`define STREAM_ADDR2_IF_SVH

//  Interface: stream_if
//
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  import stream_ADDR2_agent_pkg::*;

interface stream_ADDR2_if (
    input logic rst_n,
    input logic clk
);

  logic                      ready;
  logic [DATA_WIDTH_A2 - 1 : 0] data;
  logic                      valid = 1'b0;

  // synthesis translate_off


  class stream_ADDR2_concrete_class extends stream_ADDR2_abstract_class;
    `uvm_component_param_utils(stream_ADDR2_concrete_class);

    max_data_t mask;

    function new(string name = "stream_ADDR2_concrete_class", uvm_component parent = null);
      super.new(name, parent);
      mask = (1 << DATA_WIDTH_A2) - 1;
    endfunction : new

    function int get_data_width();
      return DATA_WIDTH_A2;
    endfunction : get_data_width

    task wait_reset();
      @(posedge rst_n);
    endtask : wait_reset

    task wait_clocks(int cycles = 1);
      repeat (cycles) @(posedge clk);
    endtask : wait_clocks

    task do_drive(stream_ADDR2_seq_item item);
      repeat (item.delay_cycles) @(posedge clk);

      data  <= item.data & mask;
      valid <= 1;

      @(posedge clk);

      while (!(valid && ready)) begin
        @(posedge clk);
      end

      data  <= 'x;
      valid <= 0;
    endtask : do_drive

    task do_monitor(stream_ADDR2_seq_item item);
      @(posedge clk);

      while (!(valid && ready)) begin
        @(posedge clk);
      end

      item.data = data & mask;
    endtask : do_monitor

  endclass : stream_ADDR2_concrete_class

  function automatic void register_interface(string interface_name);
    string path_name;
    path_name = $sformatf("*.%s", interface_name);
    stream_ADDR2_abstract_class::type_id::set_inst_override(
        stream_ADDR2_concrete_class::get_type(), path_name, null);
  endfunction
  // synthesis translate_on

endinterface : stream_ADDR2_if


`endif
