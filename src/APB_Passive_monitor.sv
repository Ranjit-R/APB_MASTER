class apb_passive_monitor extends uvm_monitor;

  virtual apb_if vif;
  uvm_analysis_port #(apb_seq_item) mon_ap;

  apb_seq_item item;

  `uvm_component_utils(apb_passive_monitor)

  function new(string name, uvm_component parent);
    super.new(name, parent);
    mon_ap = new("mon_ap", this);
  endfunction

  function void build_phase(uvm_phase phase);
    if(!uvm_config_db#(virtual apb_if)::get(this,"","vif",vif))
      `uvm_fatal("NO_VIF","Passive monitor missing VIF");
  endfunction

  task run_phase(uvm_phase phase);
    forever begin
       if(vif.PRESETn == 0) begin
         wait(vif.PRESETn == 1);
         @(vif.cb_mon);
       end
      @(vif.cb_mon);
      if( vif.cb_mon.transfer ) begin
       
      item = apb_seq_item::type_id::create("item");

      item.paddr  = vif.cb_mon.PADDR;
      item.psel  = vif.cb_mon.PSEL;
      item.penable  = vif.cb_mon.PENABLE;
      item.pwrite  = vif.cb_mon.PWRITE;
      item.pwdata  = vif.cb_mon.PWDATA;
      item.pstrb  = vif.cb_mon.PSTRB;
      item.pready     = vif.cb_mon.PREADY;

       item.rdata_out  = vif.cb_mon.rdata_out;
       item.transfer_done  = vif.cb_mon.transfer_done;
       item.error  = vif.cb_mon.error;
      //if( item.transfer_done)
      mon_ap.write(item);
      //item.print_item_output();
      end
    end

  endtask

endclass

