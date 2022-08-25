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
// Client             : Skyloom                                                :
// Version            : 1.0                                                    :
// Application        : Generic                                                :
// Filename           : stream_slave_agent.svh                                 :
// Date Last Modified : 2021 SEP 17                                            :
// Date Created       : 2021 SEP 17                                            :
// Device             : Generic                                                :
// Design Name        : Generic                                                :
// Purpose            : Stream slave agent class                               :
// Author(s)          : Nicolas Bertolo                                        :
// Email              : nbertolo@emtech.com.ar                                 :
//                                                                             :
// :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
//
// Detailed Description:
//
//
// -----------------------------------------------------------------------------

`ifndef STREAM_SLAVE_AGENT_SVH
`define STREAM_SLAVE_AGENT_SVH

class stream_slave_agent extends uvm_agent;
  `uvm_component_utils(stream_slave_agent)

  uvm_analysis_port #(stream_slave_seq_item) aport;

  stream_slave_agent_config                  m_config;
  stream_slave_sequencer                     m_sequencer;
  stream_slave_driver                        m_driver;
  stream_slave_monitor                       m_monitor;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if (m_config == null) begin
      if (!uvm_config_db#(stream_slave_agent_config)::get(this, "", "m_config", m_config)) begin
        `uvm_fatal(this.get_full_name, "No stream_slave_agent config specified!")
      end
    end

    m_config.set_interface(this);

    if (m_config.active == UVM_ACTIVE) begin
      m_sequencer = stream_slave_sequencer::type_id::create("m_sequencer", this);
      m_driver = stream_slave_driver::type_id::create("m_driver", this);
      m_driver.m_cfg = m_config;
    end

    m_monitor = stream_slave_monitor::type_id::create("m_monitor", this);
    m_monitor.m_cfg = m_config;

    aport = new("aport", this);
  endfunction : build_phase

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    if (m_config.active == UVM_ACTIVE) begin
      m_driver.seq_item_port.connect(m_sequencer.seq_item_export);
    end

    m_monitor.aport.connect(aport);
  endfunction

endclass : stream_slave_agent

`endif
