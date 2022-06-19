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
// Filename           : stream_slave_seq_item.svh                              :
// Date Last Modified : 2021 SEP 17                                            :
// Date Created       : 2021 SEP 17                                            :
// Device             : Generic                                                :
// Design Name        : Generic                                                :
// Purpose            : Stream slave sequence item class                       :
// Author(s)          : Nicolas Bertolo                                        :
// Email              : nbertolo@emtech.com.ar                                 :
//                                                                             :
// :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
//
// Detailed Description:
//
//
// -----------------------------------------------------------------------------

`ifndef STREAM_SLAVE_SEQ_ITEM_SVH
`define STREAM_SLAVE_SEQ_ITEM_SVH

class stream_slave_seq_item extends uvm_sequence_item;
    `uvm_object_utils(stream_slave_seq_item);

    max_data_t data;

    rand int delay_cycles;

    constraint delay_cycles_range {
        delay_cycles dist { -1 := 50, [0:3] :/ 40};
    }

  function new(string name = "stream_slave_seq_item");
    super.new(name);
  endfunction : new

    function void do_copy(uvm_object rhs);
        stream_slave_seq_item rhs_;

        if (!$cast(rhs_, rhs)) begin
            `uvm_error({this.get_name(), ".do_copy()"}, "Cast failed!");
            return;
        end

        /*  chain the copy with parent classes  */
        super.do_copy(rhs);

        /*  list of local properties to be copied  */
        this.data = rhs_.data;
        this.delay_cycles = rhs_.delay_cycles;
    endfunction: do_copy

    function bit do_compare(uvm_object rhs, uvm_comparer comparer);
        stream_slave_seq_item rhs_;

        if (!$cast(rhs_, rhs)) begin
            `uvm_error({this.get_name(), ".do_compare()"}, "Cast failed!");
            return 0;
        end

        /*  chain the compare with parent classes  */
        do_compare = super.do_compare(rhs, comparer);

        do_compare &= comparer.compare_field("data",
                                             this.data,
                                             rhs_.data,
                                             MAX_DATA_WIDTH);
    endfunction: do_compare

    function string convert2string();
        string s;

        /*  chain the convert2string with parent classes  */
        s = super.convert2string();

        s = {s, $sformatf("Payload data: 0x%0h", data)};

        return s;
    endfunction: convert2string

endclass: stream_slave_seq_item

`endif
