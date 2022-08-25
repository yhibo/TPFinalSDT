//Package of the test class
package tb_test_pkg;

  // Package imports.
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  import tb_defn_pkg::*;

  import tb_env_pkg::*;
  import tb_vseq_pkg::*;

  // Agent package imports.
  import stream_agent_pkg::*;

  import stream_ADDR1_agent_pkg::*;
  import stream_ADDR2_agent_pkg::*;
  import stream_slave_agent_pkg::*;



  //------------------------------------------------------------------------------
  // Class: tb_test_base
  //------------------------------------------------------------------------------
  // Verification test base for axi_example design.
  //------------------------------------------------------------------------------
  class tb_test_base extends uvm_test;
    // UVM Factory Registration Macro
    `uvm_component_utils(tb_test_base)

    // Environment class instantiation.
    axi_example_env m_axi_env;
    modem_env m_modem_env;
    // Environment configuration object instantiation.
    axi_example_env_config env_axi_config;
    modem_env_config env_modem_config;

    // Constructor.
    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction : new

    // Test's build phase.
    function void build_phase(uvm_phase phase);
      // Must always call parent method's build phase.
      super.build_phase(phase);

      // Create environment and its configuration object.
      m_axi_env = axi_example_env::type_id::create("m_axi_env", this);
      env_axi_config = axi_example_env_config::type_id::create("env_axi_config");

      m_modem_env = modem_env::type_id::create("m_modem_env", this);
      env_modem_config = modem_env_config::type_id::create("env_axi_config");

      // Configure Stream Agent.
      env_axi_config.m_araddr_agent_config =
          stream_ADDR2_agent_config::type_id::create("m_araddr_agent_config");
      env_axi_config.m_araddr_agent_config.active = UVM_ACTIVE;
      env_axi_config.m_araddr_agent_config.interface_name = "araddr_if";

      // Configure Stream eth_in Agent.
      env_modem_config.m_stream_agent_config =
          stream_agent_config::type_id::create("m_stream_agent_config");
      env_modem_config.m_stream_agent_config.active = UVM_ACTIVE;
      env_modem_config.m_stream_agent_config.interface_name = "stream_if";

      // Configure Stream Slave Agent.
      env_axi_config.m_rresp_agent_config =
          stream_slave_agent_config::type_id::create("m_rresp_agent_config");
      env_axi_config.m_rresp_agent_config.active = UVM_ACTIVE;
      env_axi_config.m_rresp_agent_config.interface_name = "rresp_if";


      // Configure Stream Agent.
      env_axi_config.m_awaddr_agent_config =
          stream_ADDR1_agent_config::type_id::create("m_awaddr_agent_config");
      env_axi_config.m_awaddr_agent_config.active = UVM_ACTIVE;
      env_axi_config.m_awaddr_agent_config.interface_name = "awaddr_if";


      // Configure Stream Agent.
      env_axi_config.m_wdata_agent_config =
          stream_agent_config::type_id::create("m_wdata_agent_config");
      env_axi_config.m_wdata_agent_config.active = UVM_ACTIVE;
      env_axi_config.m_wdata_agent_config.interface_name = "wdata_if";


      // Configure Stream Slave Agent.
      env_axi_config.m_bresp_agent_config =
          stream_slave_agent_config::type_id::create("m_bresp_agent_config");
      env_axi_config.m_bresp_agent_config.active = UVM_ACTIVE;
      env_axi_config.m_bresp_agent_config.interface_name = "bresp_if";


      // Environment post configuration
      configure_axi_env(env_axi_config);

      configure_modem_env(env_modem_config);

      // Post configure and set configuration object to database
      uvm_config_db#(axi_example_env_config)::set(this, "*", "axi_example_env_config", env_axi_config);
      uvm_config_db#(modem_env_config)::set(this, "*", "modem_env_config", env_modem_config);
    endfunction : build_phase

    // Convenience method used by test sub-classes to modify the environment.
    virtual function void configure_axi_env(axi_example_env_config env_axi_config);
      // Environment post config here (if needed).
    endfunction : configure_axi_env

    virtual function void configure_modem_env(modem_env_config env_modem_config);
      // Environment post config here (if needed).
    endfunction : configure_modem_env


    function void init_axi_vseq(axi4lite_vseq_base seq);

      if (env_axi_config.has_araddr_stream_if) begin
        seq.araddr_sqr = m_axi_env.m_araddr_stream.m_sequencer;
      end

      if (env_axi_config.has_rresp_if_stream_slave_if) begin
        seq.rresp_sqr = m_axi_env.m_rresp_stream_slave.m_sequencer;
      end


      if(env_axi_config.has_awaddr_stream_if) begin
        seq.awaddr_sqr = m_axi_env.m_awaddr_stream.m_sequencer;
      end

      if(env_axi_config.has_wdata_stream_if) begin
        seq.wdata_sqr = m_axi_env.m_wdata_stream.m_sequencer;
      end

      if(env_axi_config.has_bresp_if_stream_slave_if) begin
        seq.bresp_sqr = m_axi_env.m_bresp_stream_slave.m_sequencer;
      end


    endfunction : init_axi_vseq

    function void init_modem_vseq(modem_vseq_base vseq);

      if (env_modem_config.has_stream_agent) begin
        vseq.stream_sqr = m_modem_env.m_stream_agent.m_sequencer;
      end

    endfunction : init_modem_vseq


  endclass : tb_test_base


  //------------------------------------------------------------------------------
  // Class: tb_simple_test
  //------------------------------------------------------------------------------

  class tb_simple_test extends tb_test_base;
    // UVM Factory Registration Macro
    `uvm_component_utils(tb_simple_test)

    // Constructor.
    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction : new

    // Test's build phase.
    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
    endfunction : build_phase

    // Environment configuration for current test.
    function void configure_axi_env(axi_example_env_config env_axi_config);
      env_axi_config.has_araddr_stream_if = 1'b1;
      env_axi_config.has_rresp_if_stream_slave_if = 1'b1;
      env_axi_config.has_awaddr_stream_if = 1'b1;
      env_axi_config.has_wdata_stream_if = 1'b1;
      env_axi_config.has_bresp_if_stream_slave_if = 1'b1;
    endfunction : configure_axi_env

    function void configure_modem_env(modem_env_config env_modem_config);
      env_modem_config.has_stream_agent = 1'b1;
      //env_config.has_eth_stream_layering = 1'b1;
    endfunction : configure_modem_env

    // // Main task executed by the test.
    task run_phase(uvm_phase phase);

      modem_vseq_stream_trasm eth_trasm_vseq;
      axi4lite_seq_read  read_seq;
      axi4lite_seq_read  read_seq2;
      axi4lite_seq_write write_seq;
      axi4lite_seq_write write_seq2;
      axi4lite_seq_write write_seq3;
      axi4lite_seq_write write_seq4;


      eth_trasm_vseq = modem_vseq_stream_trasm::type_id::create("eth_trasm_vseq");
      read_seq  = axi4lite_seq_read::type_id::create("read_seq");
      read_seq2  = axi4lite_seq_read::type_id::create("read_seq2");
      write_seq = axi4lite_seq_write::type_id::create("write_seq");
      write_seq2 = axi4lite_seq_write::type_id::create("write_seq2");
      write_seq3 = axi4lite_seq_write::type_id::create("write_seq3");
      write_seq4 = axi4lite_seq_write::type_id::create("write_seq4");

       init_modem_vseq(eth_trasm_vseq);
       init_axi_vseq(read_seq);
       init_axi_vseq(read_seq2);
       init_axi_vseq(write_seq);
       init_axi_vseq(write_seq2);
       init_axi_vseq(write_seq3);
       init_axi_vseq(write_seq4);

      uvm_test_done.raise_objection(this);

      fork
        begin
          eth_trasm_vseq.start(null);
        end


        begin
          #(300ns);
          $display("Leyendo CORE ID");
          if (!read_seq.randomize() with {
                addr == CORE_ID_ADDR + OFFSET_ADDR;
              }) begin
            `uvm_error(get_full_name(), "Failed to randomize sequence!");
          end
          read_seq.start(null);

          #(300ns);
          $display("Leyendo DATE");
          if (!read_seq2.randomize() with {
                addr == DATE_ADDR + OFFSET_ADDR;
              }) begin
            `uvm_error(get_full_name(), "Failed to randomize sequence!");
          end
          read_seq2.start(null);

          #(300ns);
          $display("Escribiendo fifo enable");

          if (!write_seq.randomize() with {
                addr == FIFO_EN_ADDR + OFFSET_ADDR;
                data == 1;
              }) begin
            `uvm_error(get_full_name(), "Failed to randomize sequence!");
          end
          write_seq.start(null);

          #(40us);
          $display("Escribiendo fir mux reg");

          if (!write_seq4.randomize() with {
                addr == SEL_FIR_ADDR + OFFSET_ADDR;
                data == 2;
              }) begin
            `uvm_error(get_full_name(), "Failed to randomize sequence!");
          end
          write_seq4.start(null);

          #(10us);
          $display("Escribiendo data mux reg");

          if (!write_seq2.randomize() with {
                addr == SEL_SOURCE_ADDR + OFFSET_ADDR;
                data == 1;
              }) begin
            `uvm_error(get_full_name(), "Failed to randomize sequence!");
          end
          write_seq2.start(null);

          #(10us);
          $display("Escribiendo fir mux reg");

          if (!write_seq3.randomize() with {
                addr == SEL_FIR_ADDR + OFFSET_ADDR;
                data == 0;
              }) begin
            `uvm_error(get_full_name(), "Failed to randomize sequence!");
          end
          write_seq3.start(null);
         end

      join

      #(1ms);
      uvm_test_done.drop_objection(this);

    endtask : run_phase


  endclass : tb_simple_test






endpackage : tb_test_pkg