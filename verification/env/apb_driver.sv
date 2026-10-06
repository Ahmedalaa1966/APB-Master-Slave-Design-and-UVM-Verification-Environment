`ifndef APB_DRIVER_SV
`define APB_DRIVER_SV

class apb_driver extends uvm_driver #(apb_sequence_item);

  `uvm_component_utils(apb_driver)
  virtual apb_interface vif;

  int unsigned timeout_cycles = 64;   // max clock cycles to wait for done

  function new(string name = "apb_driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual apb_interface)::get(this, "", "vif", vif))
      `uvm_fatal("DRIVER", "virtual interface not received")
  endfunction

  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);

    // idle values
    vif.drv_cb.transfer <= 0;
    vif.drv_cb.wr_en    <= 0;
    vif.drv_cb.addr_in  <= '0;
    vif.drv_cb.wdata_in <= '0;

    // wait until reset is released (presetn is active low)
    wait (vif.presetn === 1'b1);

    forever begin
      seq_item_port.get_next_item(req);
      drive_transaction(req);
      seq_item_port.item_done();
    end
  endtask

  task drive_transaction(apb_sequence_item trn);
    int unsigned cycles = 0;

    // 1. one-clock pulse on transfer (master latches the request when idle)
    @(vif.drv_cb);
    vif.drv_cb.transfer <= 1;
    vif.drv_cb.wr_en    <= trn.wr_en;
    vif.drv_cb.addr_in  <= trn.addr_in;
    vif.drv_cb.wdata_in <= trn.wdata_in;

    if (trn.wr_en) begin
        `uvm_info("DRIVER", $sformatf("SEND WRITE: addr=0x%0h wdata=0x%0h",
                                    trn.addr_in, trn.wdata_in), UVM_LOW)
    end
    else begin
        `uvm_info("DRIVER", $sformatf("SEND READ : addr=0x%0h", trn.addr_in), UVM_LOW)
    end

    @(vif.drv_cb);
    vif.drv_cb.transfer <= 0;

    // 2. wait for done
    do begin
        @(vif.drv_cb);
        cycles++;
        if (cycles > timeout_cycles) begin
        `uvm_error("DRIVER", $sformatf("Timeout: done not seen for addr=0x%0h", trn.addr_in))
        break;
        end
    end while (vif.drv_cb.done !== 1'b1);

    // 3. rdata_out is registered: valid one clock after done
    @(vif.drv_cb);
    if (!trn.wr_en) begin
        trn.rdata_out = vif.drv_cb.rdata_out;
        `uvm_info("DRIVER", $sformatf("GOT READ DATA: addr=0x%0h rdata=0x%0h",
                                    trn.addr_in, trn.rdata_out), UVM_LOW)
    end
endtask

endclass

`endif