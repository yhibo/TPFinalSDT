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
// Filename           : stream_abstract_class.svh                              :
// Date Last Modified : 2021 SEP 16                                            :
// Date Created       : 2021 SEP 16                                            :
// Device             : Generic                                                :
// Design Name        : Generic                                                :
// Purpose            : Stream abstract class                                  :
// :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
//
// Detailed Description:
//
//
// -----------------------------------------------------------------------------

`ifndef STREAM_ADDR2_ABSTRACT_CLASS_SVH
`define STREAM_ADDR2_ABSTRACT_CLASS_SVH

class stream_ADDR2_abstract_class extends uvm_component;
  `uvm_component_utils(stream_ADDR2_abstract_class);

  function new(string name = "stream_ADDR2_abstract_class", uvm_component parent);
    super.new(name, parent);
  endfunction : new

  virtual function int get_data_width();
    `uvm_fatal(get_type_name(), "get_data_width not implemented");
    return 0;
  endfunction

  virtual task wait_reset();
    `uvm_fatal(get_type_name(), "wait_reset not implemented");
  endtask

  virtual task wait_clocks(int cycles);
    `uvm_fatal(get_type_name(), "wait_cycles not implemented");
  endtask

  virtual task do_drive(stream_ADDR2_seq_item item);
    `uvm_fatal(get_name(), "do_drive not implemented");
  endtask

  virtual task do_monitor(stream_ADDR2_seq_item item);
    `uvm_fatal(get_type_name(), "do_monitor not implemented")
  endtask

endclass : stream_ADDR2_abstract_class


`endif
