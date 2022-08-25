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
// Filename           : stream_driver.svh                                      :
// Date Last Modified : 2021 SEP 16                                            :
// Date Created       : 2021 SEP 16                                            :
// Device             : Generic                                                :
// Design Name        : Generic                                                :
// Purpose            : Stream driver class                                    :
// :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
//
// Detailed Description:
//
//
// -----------------------------------------------------------------------------

`ifndef STREAM_ADDR1_DRIVER_SVH
`define STREAM_ADDR1_DRIVER_SVH

class stream_ADDR1_driver extends uvm_driver #(stream_ADDR1_seq_item);
  `uvm_component_utils(stream_ADDR1_driver);

  stream_ADDR1_agent_config m_cfg;

  function new(string name = "stream_ADDR1_driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);

  endfunction : build_phase

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
  endfunction : connect_phase

  task run_phase(uvm_phase phase);
    m_cfg.iface.wait_reset();
    m_cfg.iface.wait_clocks(10);

    forever begin
      stream_ADDR1_seq_item item;

      seq_item_port.get_next_item(item);
      `uvm_info(this.get_full_name, item.convert2string(), UVM_HIGH);

      m_cfg.iface.do_drive(item);

      seq_item_port.item_done();
    end
  endtask : run_phase
endclass : stream_ADDR1_driver

`endif
