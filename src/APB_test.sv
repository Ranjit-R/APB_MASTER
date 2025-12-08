class apb_base_test extends uvm_test;
  `uvm_component_utils(apb_base_test)
  apb_environment env;
  apb_base_sequence seq;
  
  function new(string name="apb_base_test", uvm_component parent=null);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = apb_environment::type_id::create("env",this);
  endfunction
endclass

/*class apb_write_test extends apb_base_test; 
  `uvm_component_utils(apb_write_test)
  
  function new(string name="apb_write_test", uvm_component parent=null);
    super.new(name,parent);
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this);
      seq = apb_sequence::type_id::create("seq");
      seq.start(env.agt.seqr);
    phase.drop_objection(this);
    phase.phase_done.set_drain_time(this,20ns);
  endtask
endclass */

class apb_regression_test extends apb_base_test;
  `uvm_component_utils(apb_regression_test)

  // local sequence handles
  tc1_no_transfer_seq              tc1;
  tc2_single_write_seq             tc2;
  tc3_single_read_seq              tc3;
  tc4_back2back_write_seq          tc4;
  tc5_back2back_read_seq           tc5;
  tc6_mixed_seq                    tc6;
  tc7_partial_strobe_write_seq     tc7;
  tc8_zero_strobe_seq              tc8;
  tc9_wait_state_seq               tc9;
  tc10_error_handling_seq          tc10;
 

  function new(string name="apb_regression_test", uvm_component parent=null);
    super.new(name, parent);
  endfunction


  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    tc1  = tc1_no_transfer_seq            ::type_id::create("tc1");
    tc2  = tc2_single_write_seq           ::type_id::create("tc2");
    tc3  = tc3_single_read_seq            ::type_id::create("tc3");
    tc4  = tc4_back2back_write_seq        ::type_id::create("tc4");
    tc5  = tc5_back2back_read_seq         ::type_id::create("tc5");
    tc6  = tc6_mixed_seq                  ::type_id::create("tc6");
    tc7  = tc7_partial_strobe_write_seq   ::type_id::create("tc7");
    tc8  = tc8_zero_strobe_seq            ::type_id::create("tc8");
    tc9  = tc9_wait_state_seq             ::type_id::create("tc9");
    tc10 = tc10_error_handling_seq        ::type_id::create("tc10");
  endfunction


  virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this);

    `uvm_info("\n\n *** REG", "Running TC1 *** \n", UVM_LOW)
    tc1.start(env.agt.seqr);

    `uvm_info("\n\n *** REG", "Running TC2 *** \n", UVM_LOW)
    tc2.start(env.agt.seqr);

   `uvm_info("\n\n *** REG", "Running TC3 *** \n", UVM_LOW)
    tc3.start(env.agt.seqr);

   /*  `uvm_info("\n\n *** REG", "Running TC4 *** \n", UVM_LOW)
    tc4.start(env.agt.seqr);

    `uvm_info("\n\n *** REG", "Running TC5 *** \n", UVM_LOW)
    tc5.start(env.agt.seqr);

    `uvm_info("\n\n *** REG", "Running TC6 *** \n", UVM_LOW)
    tc6.start(env.agt.seqr);

    `uvm_info("\n\n *** REG", "Running TC7 *** \n", UVM_LOW)
    tc7.start(env.agt.seqr);

    `uvm_info("\n\n *** REG", "Running TC8 *** \n", UVM_LOW)
    tc8.start(env.agt.seqr);

    `uvm_info("\n\n *** REG", "Running TC9 *** \n", UVM_LOW)
    tc9.start(env.agt.seqr);

    `uvm_info("\n\n *** REG", "Running TC10 *** \n", UVM_LOW)
    tc10.start(env.agt.seqr);
    */


    phase.drop_objection(this);
    phase.phase_done.set_drain_time(this, 50ns);
  endtask

endclass




