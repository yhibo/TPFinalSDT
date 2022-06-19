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
// Filename           : stream_agent_config.svh                                :
// Date Last Modified : 2021 SEP 16                                            :
// Date Created       : 2021 SEP 16                                            :
// Device             : Generic                                                :
// Design Name        : Generic                                                :
// Purpose            : Stream agent config                                    :
// :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
//
// Detailed Description:
//
//
// -----------------------------------------------------------------------------

`ifndef STREAM_ADDR2_AGENT_CONFIG_SVH
`define STREAM_ADDR2_AGENT_CONFIG_SVH

class stream_ADDR2_agent_config extends uvm_object;
  `uvm_object_utils(stream_ADDR2_agent_config)

  string                  interface_name;
  uvm_active_passive_enum active          = UVM_ACTIVE;

  stream_ADDR2_abstract_class   iface;

  function new(string name = "");
    super.new(name);
  endfunction

  function automatic void set_interface(uvm_component parent);
    iface = stream_ADDR2_abstract_class::type_id::create(interface_name, parent);
  endfunction

endclass

`endif
