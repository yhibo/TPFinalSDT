package modem_env_pkg;
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  import stream_agent_pkg::*;

  import modem_defn_pkg::*;


  //------------------------------------------------------------------------------
  // CLASS: modem_env_config
  //------------------------------------------------------------------------------

  class modem_env_config extends uvm_object;
    // UVM Factory Registration Macro.
    `uvm_object_utils(modem_env_config)

    // Agent usage flags.
    bit has_stream_agent = 1'b0;
  

    // Configuration objects for the environment's sub components.
    stream_agent_config m_stream_agent_config;


    // Configuration object's constructor.
    function new(string name = "modem_env_config");
      super.new(name);
    endfunction : new

  endclass : modem_env_config

  //------------------------------------------------------------------------------
  // Class: modem_env
  //------------------------------------------------------------------------------
  // Environment class
  //------------------------------------------------------------------------------
  class modem_env extends uvm_env;
    // UVM Factory Registration Macro.
    `uvm_component_utils(modem_env)

    // Environment's configuration object instantiation.
    modem_env_config m_config;

    // Agents instantiation.
    stream_agent m_stream_agent;

    // Environment's constructor.
    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction : new

    // Environment's build phase.
    function void build_phase(uvm_phase phase);
      super.build_phase(phase);

      // Get Environment's configuration from database.
      if (!uvm_config_db#(modem_env_config)::get(this, "", "modem_env_config", m_config)) begin
        `uvm_fatal("Modem Env", "No configuration object specified")
      end

      // Create stream agent for the eth_in if this is used
      if (m_config.has_stream_agent) begin
        m_stream_agent = stream_agent::type_id::create("m_stream_agent", this);
        // Get Agent's configuration object from database.
        uvm_config_db#(stream_agent_config)::set(this, "m_stream_agent", "m_config",
                                                 m_config.m_stream_agent_config);
      end


    endfunction : build_phase

    // Environment's connect phase.
    function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);

    endfunction : connect_phase


  endclass : modem_env


endpackage : modem_env_pkg
