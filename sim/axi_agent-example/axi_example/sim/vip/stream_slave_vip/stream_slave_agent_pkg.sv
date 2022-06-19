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
// Filename           : stream_slave_agent_pkg.sv                              :
// Date Last Modified : 2021 SEP 17                                            :
// Date Created       : 2021 SEP 17                                            :
// Device             : Generic                                                :
// Design Name        : Generic                                                :
// Purpose            : Stream slave agent package                             :
// Author(s)          : Nicolas Bertolo                                        :
// Email              : nbertolo@emtech.com.ar                                 :
//                                                                             :
// :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
//
// Detailed Description:
//
//
// -----------------------------------------------------------------------------

package stream_slave_agent_pkg;
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  localparam int MAX_DATA_WIDTH = 256;
  typedef logic [MAX_DATA_WIDTH - 1 : 0] max_data_t;

  `include "stream_slave_seq_item.svh"
  `include "stream_slave_abstract_class.svh"
  `include "stream_slave_agent_config.svh"
  `include "stream_slave_driver.svh"
  `include "stream_slave_monitor.svh"
  `include "stream_slave_sequencer.svh"
  `include "stream_slave_agent.svh"

  // Utility sequences
  `include "stream_slave_seq.svh"
endpackage
