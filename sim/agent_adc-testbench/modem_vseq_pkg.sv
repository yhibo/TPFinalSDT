// Package: modem_vseq_pkg
// Package of the sequencies used to estimulate the DUT

package modem_vseq_pkg;
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  import modem_defn_pkg::*;

  import stream_agent_pkg::*;


  // Class: modem_vseq_base
  // Class base for the sequences of the test
  class modem_vseq_base extends uvm_sequence #(uvm_sequence_item);
    // UVM Factory Registration Macro
    `uvm_object_utils(modem_vseq_base)

    // Sequencer for any sequencie item
    stream_sequencer stream_sqr;


    // Register map
    uvm_status_e status;

    function new(string name = "modem_vseq_base");
      super.new(name);
    endfunction : new

    task body;

    endtask : body

  endclass : modem_vseq_base


  // Class: modem_vseq_stream_trasm
  // Sequence to estimulate the DUT with random ETH packets
  class modem_vseq_stream_trasm extends modem_vseq_base;
    // UVM Factory Registration Macro
    `uvm_object_utils(modem_vseq_stream_trasm)
    logic [223:0] trama;


    function new(string name = "modem_vseq_stream_trasm");
      super.new(name);
    endfunction : new

    task body;

     real tono;
     logic [13:0] tono_adc;

      for (int i = 0; i < LARGO_TONO; i++) begin
        stream_seq_item item;
        item = stream_seq_item::type_id::create("item");
        tono = 20*$cos(2*PI_CONST*$time * FREQ_TONO_GHz)+21; //$cos() es en radianes
        $display("time: %t",$time);
        $display("cos arg: %f",2*PI_CONST*$time * FREQ_TONO_GHz);
        tono_adc = tono;
        $display("tono %f",tono);
        $display("tono_adc %d",tono_adc);
        for(int j = 0; j<ADC_WIDTH; j++) begin

          start_item(item, .sequencer(stream_sqr));

          if (!item.randomize() with {delay_cycles==0;}) begin
            `uvm_error(get_name(), "Failed to randomize stream_trasm_sqr error sequence item!");
          end

          item.data[0] = tono_adc[ADC_WIDTH-j-1];

          if (j<7) begin
           item.data[1] = 1;
          end else begin
            item.data[1] = 0;
          end

          item.data[2] = (j+1)%2;

        finish_item(item);
        end
      end

    endtask : body

  endclass : modem_vseq_stream_trasm



endpackage : modem_vseq_pkg
