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
// Filename           : stream_slave_sequencer.svh                             :
// Date Last Modified : 2021 SEP 17                                            :
// Date Created       : 2021 SEP 17                                            :
// Device             : Generic                                                :
// Design Name        : Generic                                                :
// Purpose            : Stream slave sequencer class                           :
// Author(s)          : Nicolas Bertolo                                        :
// Email              : nbertolo@emtech.com.ar                                 :
//                                                                             :
// :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
//
// Detailed Description:
//
//
// -----------------------------------------------------------------------------

`ifndef STREAM_SLAVE_SEQUENCER_SVH
`define STREAM_SLAVE_SEQUENCER_SVH

class stream_slave_sequencer extends uvm_sequencer #(stream_slave_seq_item);
    `uvm_component_utils(stream_slave_sequencer);

    function new(string name = "stream_slave_sequencer", uvm_component parent = null);
        super.new(name, parent);
    endfunction: new

endclass: stream_slave_sequencer

`endif
