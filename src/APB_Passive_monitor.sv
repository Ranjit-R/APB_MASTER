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
       end
      @(vif.cb_mon);

       item = apb_seq_item::type_id::create("item");

      item.apb_rdata  = vif.cb_mon.PRDATA;
      item.pready     = vif.cb_mon.PREADY;
      item.pslverr    = vif.cb_mon.PSLVERR;

      item.apb_addr   = vif.cb_mon.addr_in;    
      item.apb_write  = vif.cb_mon.write_read;
      item.apb_wdata  = vif.cb_mon.wdata_in;
      item.apb_strb   = vif.cb_mon.strb_in;

      item.pslverr     = vif.cb_mon.PSLVERR;
      item.pready      = vif.cb_mon.PREADY;

      
      mon_ap.write(item);
      item.print();
      $info(" Passive_Monitor");
    end
  endtask

endclass

