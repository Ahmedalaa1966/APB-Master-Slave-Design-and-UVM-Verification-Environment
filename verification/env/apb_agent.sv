`ifndef APB_AGENT_SV
`define APB_AGENT_SV
 
class apb_agent extends uvm_agent;
    
    `uvm_component_utils(apb_agent)                                                    // factory registeration
    
    apb_driver    drvh ;                                                               // declaring the handle of driver
    apb_monitor   monh ;                                                               // declaring the handle of the monitor
    apb_sequencer sqrh ;                                                               // declaring the handle of the sequencer

    virtual apb_interface vif ;                                                              // declaring a handle for the virual interface 

    function new(string name = "apb_agent",uvm_component parent);                     // creating the construtor function
        super.new(name,parent) ;
    endfunction //new()

    function void build_phase(uvm_phase phase );
        super.build_phase(phase) ;

        if(!uvm_config_db#(virtual apb_interface)::get(this,"","vif",vif))                      // get the virtul interface form the top through the configrable database
            `uvm_fatal("[AGENT]no interface","virtual interface isnot receiver")    
        
        drvh = apb_driver    :: type_id :: create  ("drvh",this)   ;                       // creating instances for the driver 
        monh = apb_monitor   :: type_id :: create  ("monh",this)   ;                       // creating instances for the monitor
        sqrh = apb_sequencer :: type_id :: create  ("sqrh",this)   ;                       // creating insatnces for the suencer 

    endfunction


    function void connect_phase(uvm_phase phase);
        
        super.connect_phase(phase) ;
        drvh.seq_item_port.connect(sqrh.seq_item_export) ;                              // connecting the driver and the sequencer usiing built in TLM ports

        drvh.vif = vif ;                                                                // passing the virual interface to the driver 
        monh.vif = vif ;                                                                // passing the virtual interface t the monitor 
        
    endfunction
endclass //apb_agent extends uvm_agent
`endif 