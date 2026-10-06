`ifndef APB_SEQUENCER_SV
`define APB_DEQUENCER_SV
 
class apb_sequencer extends uvm_sequencer#(apb_sequence_item);
    
    `uvm_component_utils(apb_sequencer)                                    // registeration in the uvm factory

    function new(string name = "apb_sequencer", uvm_component parent = null);
        super.new(name, parent);
    endfunction //new()

endclass //apb_sequencer extends uvm_sequencer

`endif 