`include "defines.svh"
`include "uvm_macros.svh"
import uvm_pkg::*;

class apb_driver extends uvm_driver #(apb_seq_item);

  `uvm_component_utils(apb_driver)

  virtual apb_if vif;
  int cycle_count;

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
      vif.cb_drv.PREADY     <= 0;

      wait(vif.PRESETn == 1);
      repeat(2)@(vif.cb_drv);
      
    end
   seq_item_port.get_next_item(req);
  	drive();
   seq_item_port.item_done();

  end
  endtask
  
  task drive();

    cycle_count = 0;
   
    @(vif.cb_drv);
    
    vif.cb_drv.transfer   <= req.transfer;
    vif.cb_drv.write_read <= req.write_read;
    vif.cb_drv.addr_in    <= req.addr_in;
    vif.cb_drv.wdata_in   <= req.wdata_in;
    vif.cb_drv.strb_in    <= req.strb_in;

    vif.cb_drv.PRDATA  <=10;// req.prdata;
    vif.cb_drv.PSLVERR <= 0;//req.pslverr;

    while (1) begin
      @(vif.cb_drv);
      if ( cycle_count == 0 ) vif.cb_drv.PREADY <= 0;
      else if ( cycle_count == 1 ) vif.cb_drv.PREADY <= 0;

       else begin  
            if (req.pready == 1) begin
              vif.cb_drv.PREADY <= 1;
              cycle_count = 0;
	       @(vif.cb_drv);
	      vif.cb_drv.transfer <= 0;//req.transfer;
	      wait( !vif.transfer_done );
   	      vif.cb_drv.PREADY <= 0;
              break;      
            end
            else begin
              vif.cb_drv.PREADY <= req.pready;
 	      req.randomize();
            end
        end

      if ( cycle_count <= 1 ) cycle_count++;
    end
  

endtask


endclass

