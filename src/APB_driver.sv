`include "defines.svh"
`include "uvm_macros.svh"
import uvm_pkg::*;

class apb_driver extends uvm_driver #(apb_seq_item);

  `uvm_component_utils(apb_driver)

  virtual apb_if vif;

  apb_seq_item req;

  function new(string name = "apb_driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual apb_if)::get(this, "", "vif", vif)) begin
      `uvm_fatal("NOVIF", {"APB Driver: virtual interface not found for ", get_full_name(), ".vif"})
    end
  endfunction

task run_phase(uvm_phase phase);
  logic [(`data_width)-1:0] rdata;
  
  forever begin
    
    if(vif.PRESETn == 0) begin
      vif.cb_drv.transfer   <= 0;
      vif.cb_drv.write_read <= 0;
      vif.cb_drv.addr_in    <= 0;
      vif.cb_drv.wdata_in   <= 0;
      vif.cb_drv.strb_in    <= 0;

      wait(vif.PRESETn == 1);
      
    end
   seq_item_port.get_next_item(req);
    drive();
   seq_item_port.item_done();
  end
  endtask
  
  task drive();
   
    @(vif.cb_drv);  
    if (req.apb_write) begin

      vif.cb_drv.transfer   <= 1;
      vif.cb_drv.write_read <= 1;
      vif.cb_drv.addr_in    <= req.apb_addr;
      vif.cb_drv.wdata_in   <= req.apb_wdata;
      vif.cb_drv.strb_in    <= req.apb_strb;

    end
    else begin

      vif.cb_drv.transfer   <= 1;
      vif.cb_drv.write_read <= 0;
      vif.cb_drv.addr_in    <= req.apb_addr;
      vif.cb_drv.strb_in    <= 4'hF;

    end

  endtask



endclass

