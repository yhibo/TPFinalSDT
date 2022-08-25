//Package of the test class
package modem_test_pkg;

  // Package imports.
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  import modem_defn_pkg::*;
  import modem_env_pkg::*;
  import modem_vseq_pkg::*;

  // Agent package imports.
  import stream_agent_pkg::*;



  //------------------------------------------------------------------------------
  // Class: modem_test_base
  //------------------------------------------------------------------------------
  // Verification test base for modem design.
  //------------------------------------------------------------------------------
  class modem_test_base extends uvm_test;
    // UVM Factory Registration Macro
    `uvm_component_utils(modem_test_base)

    // Environment class instantiation.
    modem_env m_env;
    // Environment configuration object instantiation.
    modem_env_config env_config;

    // Constructor.
    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction : new

    // Test's build phase.
    function void build_phase(uvm_phase phase);
      // Must always call parent method's build phase.
      super.build_phase(phase);

      // Create environment and its configuration object.
      m_env = modem_env::type_id::create("m_env", this);
      env_config = modem_env_config::type_id::create("env_config");


      // Configure Stream eth_in Agent.
      env_config.m_stream_agent_config =
          stream_agent_config::type_id::create("m_stream_agent_config");
      env_config.m_stream_agent_config.active = UVM_ACTIVE;
      env_config.m_stream_agent_config.interface_name = "stream_if";


      // Environment post configuration
      configure_env(env_config);

      // Post configure and set configuration object to database
      uvm_config_db#(modem_env_config)::set(this, "*", "modem_env_config", env_config);
    endfunction : build_phase

    // Convenience method used by test sub-classes to modify the environment.
    virtual function void configure_env(modem_env_config env_config);
      // Environment post config here (if needed).
    endfunction : configure_env


    function void init_vseq(modem_vseq_base vseq);

      if (env_config.has_stream_agent) begin
        vseq.stream_sqr = m_env.m_stream_agent.m_sequencer;
      end

    endfunction : init_vseq


  endclass : modem_test_base


  //------------------------------------------------------------------------------
  // Class: modem_simple_stream_test
  //------------------------------------------------------------------------------

  class modem_simple_stream_test extends modem_test_base;
    // UVM Factory Registration Macro
    `uvm_component_utils(modem_simple_stream_test)

    // Constructor.
    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction : new

    // Test's build phase.
    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
    endfunction : build_phase

    // Environment configuration for current test.
    function void configure_env(modem_env_config env_config);
      env_config.has_stream_agent = 1'b1;
      //env_config.has_eth_stream_layering = 1'b1;
    endfunction : configure_env

    // // Main task executed by the test.
    task run_phase(uvm_phase phase);
      modem_vseq_stream_trasm eth_trasm_vseq;


      eth_trasm_vseq = modem_vseq_stream_trasm::type_id::create("eth_trasm_vseq");


      init_vseq(eth_trasm_vseq);


      uvm_test_done.raise_objection(this);

      fork
        begin
          eth_trasm_vseq.start(null);
        end
      join


      uvm_test_done.drop_objection(this);

    endtask : run_phase


  endclass : modem_simple_stream_test




  

endpackage : modem_test_pkg
