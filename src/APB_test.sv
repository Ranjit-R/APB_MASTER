class apb_base_test extends uvm_test;
  `uvm_component_utils(apb_base_test)
  apb_environment env;
  apb_sequence seq;
  
  function new(string name="apb_base_test", uvm_component parent=null);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = apb_environment::type_id::create("env",this);
  endfunction
endclass

class apb_write_test extends apb_base_test; 
  `uvm_component_utils(apb_write_test)
  
  function new(string name="apb_write_test", uvm_component parent=null);
    super.new(name,parent);
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this);
      seq = apb_sequence::type_id::create("seq");
      seq.start(env.agt.seqr);
    phase.drop_objection(this);
  endtask
endclass


