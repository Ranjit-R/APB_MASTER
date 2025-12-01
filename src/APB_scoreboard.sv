`include "defines.svh"

class apb_scoreboard extends uvm_scoreboard;

  `uvm_component_utils(apb_scoreboard)

 
  uvm_tlm_analysis_fifo #(apb_seq_item) act_mon_scb_port;
  uvm_tlm_analysis_fifo #(apb_seq_item) pas_mon_scb_port;

  // Reference Memory (Two slaves)
  bit [`data_width-1:0] ref_mem_slave1 [bit [`addr_width-2:0]];
  bit [`data_width-1:0] ref_mem_slave2 [bit [`addr_width-2:0]];

  apb_seq_item act_mon_item;
  apb_seq_item pas_mon_item;

  function new(string name="apb_scoreboard", uvm_component parent);
    super.new(name,parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    act_mon_scb_port = new("act_mon_scb_port", this);
    pas_mon_scb_port = new("mon_scb_port", this);
  endfunction

  virtual task run_phase(uvm_phase phase);
    
      fork
        input_write();
        output_write();
      join_none
        
  endtask
  
  task input_write();
    forever begin
      act_mon_scb_port.get(act_mon_item);
      $display(" Get In @scr");
    end
  endtask
  
  task output_write();
    forever begin
      pas_mon_scb_port.get(pas_mon_item);
      $display(" Get out @scr");
    end
  endtask

endclass

