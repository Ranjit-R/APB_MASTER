class apb_active_monitor extends uvm_monitor;

  virtual apb_if vif;
  apb_seq_item item;
  uvm_analysis_port #(apb_seq_item) mon_ap;

  `uvm_component_utils(apb_active_monitor)

  function new(string name, uvm_component parent);
    super.new(name, parent);
    mon_ap = new("mon_ap", this);
  endfunction

  function void build_phase(uvm_phase phase);
    if(!uvm_config_db#(virtual apb_if)::get(this,"","vif",vif))
      `uvm_fatal("NO_VIF","Active monitor missing VIF");
  endfunction

task run_phase(uvm_phase phase);
  
  forever begin
    
     
    if(vif.PRESETn == 0) begin
      wait(vif.PRESETn  == 1);
    end
    
    @(vif.cb_mon);
    
    item = apb_seq_item::type_id::create("item", this);

    item.apb_addr   = vif.cb_mon.PADDR;
    item.apb_write  = vif.cb_mon.PWRITE;
    item.apb_wdata  = vif.cb_mon.PWDATA;
    item.apb_strb   = vif.cb_mon.PSTRB;

    item.apb_rdata  = vif.cb_mon.PRDATA;
    item.pslverr    = vif.cb_mon.PSLVERR;
    item.pready     = vif.cb_mon.PREADY;
    
    
    mon_ap.write(item);
    item.print();
    $info(" Active_Monitor");
  end

endtask


endclass
