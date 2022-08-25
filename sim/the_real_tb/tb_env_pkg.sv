package tb_env_pkg;
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  import stream_agent_pkg::*;
  import stream_ADDR1_agent_pkg::*;
  import stream_ADDR2_agent_pkg::*;
  import stream_slave_agent_pkg::*;

  import tb_defn_pkg::*;


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

  //------------------------------------------------------------------------------
  // CLASS: axi_example_env_config
  //------------------------------------------------------------------------------

  class axi_example_env_config extends uvm_object;
    // UVM Factory Registration Macro.
    `uvm_object_utils(axi_example_env_config)

    // Agent usage flags.
    bit has_awaddr_stream_if = 1'b0;
    bit has_wdata_stream_if = 1'b0;
    bit has_bresp_if_stream_slave_if = 1'b0;


    bit has_araddr_stream_if = 1'b0;
    bit has_rresp_if_stream_slave_if = 1'b0;

  

    // Configuration objects for the environment's sub components.
    stream_ADDR1_agent_config m_awaddr_agent_config;
    stream_agent_config m_wdata_agent_config;
    stream_slave_agent_config m_bresp_agent_config;


    stream_ADDR2_agent_config m_araddr_agent_config;
    stream_slave_agent_config m_rresp_agent_config;


    // Configuration object's constructor.
    function new(string name = "axi_example_env_config");
      super.new(name);
    endfunction : new

  endclass : axi_example_env_config

  //------------------------------------------------------------------------------
  // Class: axi_example_env
  //------------------------------------------------------------------------------
  // Environment class
  //------------------------------------------------------------------------------
  class axi_example_env extends uvm_env;
    // UVM Factory Registration Macro.
    `uvm_component_utils(axi_example_env)

    // Environment's configuration object instantiation.
    axi_example_env_config m_config;

    // Agents instantiation.
    stream_ADDR1_agent m_awaddr_stream;
    stream_agent m_wdata_stream;
    stream_slave_agent m_bresp_stream_slave;


    stream_ADDR2_agent m_araddr_stream;
    stream_slave_agent m_rresp_stream_slave;

    // Environment's constructor.
    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction : new

    // Environment's build phase.
    function void build_phase(uvm_phase phase);
      super.build_phase(phase);

      // Get Environment's configuration from database.
      if (!uvm_config_db#(axi_example_env_config)::get(this, "", "axi_example_env_config", m_config)) begin
        `uvm_fatal("axi_example Env", "No configuration object specified")
      end

      // Create stream agent for the eth_in if this is used
      if (m_config.has_araddr_stream_if) begin
        m_araddr_stream = stream_ADDR2_agent::type_id::create("m_araddr_stream", this);
        // Get Agent's configuration object from database.
        uvm_config_db#(stream_ADDR2_agent_config)::set(this, "m_araddr_stream", "m_config",
                                                 m_config.m_araddr_agent_config);
      end


      // Create stream slave agent for the eth_in if this is used
      if (m_config.has_rresp_if_stream_slave_if) begin
        m_rresp_stream_slave = stream_slave_agent::type_id::create("m_rresp_stream_slave", this);
        // Get Agent's configuration object from database.
        uvm_config_db#(stream_slave_agent_config)::set(this, "m_rresp_stream_slave", "m_config",
                                                 m_config.m_rresp_agent_config);
      end



      // Create stream agent for the eth_in if this is used
      if (m_config.has_awaddr_stream_if) begin
        m_awaddr_stream = stream_ADDR1_agent::type_id::create("m_awaddr_stream", this);
        // Get Agent's configuration object from database.
        uvm_config_db#(stream_ADDR1_agent_config)::set(this, "m_awaddr_stream", "m_config",
                                                 m_config.m_awaddr_agent_config);
      end

      // Create stream agent for the eth_in if this is used
      if (m_config.has_wdata_stream_if) begin
        m_wdata_stream = stream_agent::type_id::create("m_wdata_stream", this);
        // Get Agent's configuration object from database.
        uvm_config_db#(stream_agent_config)::set(this, "m_wdata_stream", "m_config",
                                                 m_config.m_wdata_agent_config);
      end


      // Create stream slave agent for the eth_in if this is used
      if (m_config.has_bresp_if_stream_slave_if) begin
        m_bresp_stream_slave = stream_slave_agent::type_id::create("m_bresp_stream_slave", this);
        // Get Agent's configuration object from database.
        uvm_config_db#(stream_slave_agent_config)::set(this, "m_bresp_stream_slave", "m_config",
                                                 m_config.m_bresp_agent_config);
      end

    endfunction : build_phase

    // Environment's connect phase.
    function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);

    endfunction : connect_phase


  endclass : axi_example_env


endpackage : tb_env_pkg
