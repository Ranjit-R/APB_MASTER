`include "defines.svh"
import uvm_pkg::*;

class apb_agent extends uvm_agent;

  apb_sequencer   seqr;
  apb_driver      drv;

  apb_active_monitor  a_mon;     
  apb_passive_monitor p_mon;    

  `uvm_component_utils(apb_agent)

  function new(string name="apb_agent", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if (get_is_active() == UVM_ACTIVE) begin
      seqr  = apb_sequencer  ::type_id::create("seqr",  this);
      drv   = apb_driver     ::type_id::create("drv",   this);
      a_mon = apb_active_monitor ::type_id::create("a_mon", this);
    end

    p_mon = apb_passive_monitor::type_id::create("p_mon", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    if (get_is_active()==UVM_ACTIVE)
      drv.seq_item_port.connect(seqr.seq_item_export);
  endfunction

endclass

