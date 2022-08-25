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
// Filename           : stream_seq.svh                                         :
// Date Last Modified : 2021 SEP 16                                            :
// Date Created       : 2021 SEP 16                                            :
// Device             : Generic                                                :
// Design Name        : Generic                                                :
// Purpose            : Stream sequence classes                                :
// Author(s)          : Nicolas Bertolo                                        :
// Email              : nbertolo@emtech.com.ar                                 :
//                                                                             :
// :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
//
// Detailed Description:
//
//
// -----------------------------------------------------------------------------

`ifndef STREAM_SEQ_SVH
`define STREAM_SEQ_SVH

class stream_seq_base extends uvm_sequence #(stream_seq_item);
  `uvm_object_utils(stream_seq_base);
  `uvm_declare_p_sequencer(stream_sequencer);

  function new(string name = "stream_seq_base");
    super.new(name);
  endfunction : new

  task body();

  endtask
endclass : stream_seq_base

class stream_seq_random extends stream_seq_base;
  `uvm_object_utils(stream_seq_random);

  function new(string name = "stream_seq_random");
    super.new(name);
  endfunction

  task body;
    stream_seq_item item;

    item = stream_seq_item::type_id::create("item");
    start_item(item);

    if (!item.randomize()) begin
      `uvm_error("STREAMRND", "Failed to randomize seq!");
    end

    finish_item(item);
  endtask

endclass : stream_seq_random

class stream_seq_forward extends stream_seq_base;
  `uvm_object_utils(stream_seq_forward);

  rand max_data_t data;

  function new(string name = "stream_seq_forward");
    super.new(name);
  endfunction

  task body;
    stream_seq_item item;

    item = stream_seq_item::type_id::create("item");
    start_item(item);

    if (!item.randomize() with {data == local:: data;}) begin
      `uvm_error("STREAMRND", "Failed to randomize seq!");
    end

    finish_item(item);
  endtask
endclass : stream_seq_forward

class stream_seq_forward_constant_delay extends stream_seq_base;
  `uvm_object_utils(stream_seq_forward_constant_delay);

  rand max_data_t data;
  integer delay_cycles;

  function new(string name = "stream_seq_forward_constant_delay");
    super.new(name);
  endfunction

  task body;
    stream_seq_item item;

    item = stream_seq_item::type_id::create("item");
    start_item(item);

    if (!item.randomize() with {
          data == local:: data;
          delay_cycles == local:: delay_cycles;
        }) begin
      `uvm_error("STREAMRND", "Failed to randomize seq!");
    end

    finish_item(item);
  endtask

endclass : stream_seq_forward_constant_delay

class stream_seq_forward_no_delay extends stream_seq_base;
  `uvm_object_utils(stream_seq_forward_no_delay);

  rand max_data_t data;
  integer delay_cycles;

  function new(string name = "stream_seq_forward_no_delay");
    super.new(name);
  endfunction

  task body;
    stream_seq_item item;

    item = stream_seq_item::type_id::create("item");
    start_item(item);

    if (!item.randomize() with {
          data == local:: data;
          delay_cycles == 0;
        }) begin
      `uvm_error("STREAMRND", "Failed to randomize seq!");
    end

    finish_item(item);
  endtask

endclass : stream_seq_forward_no_delay

`endif
