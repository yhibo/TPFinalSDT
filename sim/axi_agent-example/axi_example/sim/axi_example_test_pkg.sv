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

//Package of the test class
package axi_example_test_pkg;

  // Package imports.
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  import axi_example_defn_pkg::*;
  import axi_example_env_pkg::*;
  import axi_example_vseq_pkg::*;

  // Agent package imports.
  import stream_agent_pkg::*;
  import stream_ADDR1_agent_pkg::*;
  import stream_ADDR2_agent_pkg::*;
  import stream_slave_agent_pkg::*;



  //------------------------------------------------------------------------------
  // Class: axi_example_test_base
  //------------------------------------------------------------------------------
  // Verification test base for axi_example design.
  //------------------------------------------------------------------------------
  class axi_example_test_base extends uvm_test;
    // UVM Factory Registration Macro
    `uvm_component_utils(axi_example_test_base)

    // Environment class instantiation.
    axi_example_env m_env;
    // Environment configuration object instantiation.
    axi_example_env_config env_config;

    // Constructor.
    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction : new

    // Test's build phase.
    function void build_phase(uvm_phase phase);
      // Must always call parent method's build phase.
      super.build_phase(phase);

      // Create environment and its configuration object.
      m_env = axi_example_env::type_id::create("m_env", this);
      env_config = axi_example_env_config::type_id::create("env_config");


      // Configure Stream Agent.
      env_config.m_araddr_agent_config =
          stream_ADDR2_agent_config::type_id::create("m_araddr_agent_config");
      env_config.m_araddr_agent_config.active = UVM_ACTIVE;
      env_config.m_araddr_agent_config.interface_name = "araddr_if";


      // Configure Stream Slave Agent.
      env_config.m_rresp_agent_config =
          stream_slave_agent_config::type_id::create("m_rresp_agent_config");
      env_config.m_rresp_agent_config.active = UVM_ACTIVE;
      env_config.m_rresp_agent_config.interface_name = "rresp_if";


      // Configure Stream Agent.
      env_config.m_awaddr_agent_config =
          stream_ADDR1_agent_config::type_id::create("m_awaddr_agent_config");
      env_config.m_awaddr_agent_config.active = UVM_ACTIVE;
      env_config.m_awaddr_agent_config.interface_name = "awaddr_if";


      // Configure Stream Agent.
      env_config.m_wdata_agent_config =
          stream_agent_config::type_id::create("m_wdata_agent_config");
      env_config.m_wdata_agent_config.active = UVM_ACTIVE;
      env_config.m_wdata_agent_config.interface_name = "wdata_if";


      // Configure Stream Slave Agent.
      env_config.m_bresp_agent_config =
          stream_slave_agent_config::type_id::create("m_bresp_agent_config");
      env_config.m_bresp_agent_config.active = UVM_ACTIVE;
      env_config.m_bresp_agent_config.interface_name = "bresp_if";


      // Environment post configuration
      configure_env(env_config);

      // Post configure and set configuration object to database
      uvm_config_db#(axi_example_env_config)::set(this, "*", "axi_example_env_config", env_config);
    endfunction : build_phase

    // Convenience method used by test sub-classes to modify the environment.
    virtual function void configure_env(axi_example_env_config env_config);
      // Environment post config here (if needed).
    endfunction : configure_env


    function void init_vseq(axi4lite_vseq_base seq);

      if (env_config.has_araddr_stream_if) begin
        seq.araddr_sqr = m_env.m_araddr_stream.m_sequencer;
      end

      if (env_config.has_rresp_if_stream_slave_if) begin
        seq.rresp_sqr = m_env.m_rresp_stream_slave.m_sequencer;
      end


      if(env_config.has_awaddr_stream_if) begin
        seq.awaddr_sqr = m_env.m_awaddr_stream.m_sequencer;
      end
      
      if(env_config.has_wdata_stream_if) begin
        seq.wdata_sqr = m_env.m_wdata_stream.m_sequencer;
      end

      if(env_config.has_bresp_if_stream_slave_if) begin
        seq.bresp_sqr = m_env.m_bresp_stream_slave.m_sequencer;
      end
      

    endfunction : init_vseq


  endclass : axi_example_test_base


  //------------------------------------------------------------------------------
  // Class: axi_example_simple_test
  //------------------------------------------------------------------------------

  class axi_example_simple_test extends axi_example_test_base;
    // UVM Factory Registration Macro
    `uvm_component_utils(axi_example_simple_test)

    // Constructor.
    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction : new

    // Test's build phase.
    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
    endfunction : build_phase

    // Environment configuration for current test.
    function void configure_env(axi_example_env_config env_config);
      env_config.has_araddr_stream_if = 1'b1;
      env_config.has_rresp_if_stream_slave_if = 1'b1;
      env_config.has_awaddr_stream_if = 1'b1;
      env_config.has_wdata_stream_if = 1'b1;
      env_config.has_bresp_if_stream_slave_if = 1'b1;
    endfunction : configure_env

    // // Main task executed by the test.
    task run_phase(uvm_phase phase);

      axi4lite_seq_read  read_seq;
      axi4lite_seq_write write_seq;
      
      read_seq  = axi4lite_seq_read::type_id::create("read_seq");
      write_seq = axi4lite_seq_write::type_id::create("write_seq");


       init_vseq(read_seq);
       init_vseq(write_seq);

      uvm_test_done.raise_objection(this);

          #(1ms);
          $display("papapapaapppapapapapapapapapapapapapapapapapa");
          if (!read_seq.randomize() with {
                addr == CORE_ID_ADDR + OFFSET_ADDR;
              }) begin
            `uvm_error(get_full_name(), "Failed to randomize sequence!");
          end
          read_seq.start(null);

          #(1us);
          $display("pepepepeppepepepeppepepepepeppepepepepeppepepe");

          if (!write_seq.randomize() with {
                addr == 8;
                data == 10;
              }) begin
            `uvm_error(get_full_name(), "Failed to randomize sequence!");
          end
          write_seq.start(null);

          //  #(1ms);
          // $display("papapapaapppapapapapapapapapapapapapapapapapa");
          // if (!read_seq.randomize() with {
          //       addr == 8;
          //     }) begin
          //   `uvm_error(get_full_name(), "Failed to randomize sequence!");
          // end
          // read_seq.start(null);


      #(1ms);
      uvm_test_done.drop_objection(this);

    endtask : run_phase


  endclass : axi_example_simple_test






endpackage : axi_example_test_pkg
