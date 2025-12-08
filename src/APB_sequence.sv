`include "defines.svh"
/*class apb_sequence extends uvm_sequence #(apb_seq_item);

  `uvm_object_utils(apb_sequence)



  function new(string name="apb_sequence");
    super.new(name);
  endfunction


  virtual task body();
    apb_seq_item req;
    
    req = apb_seq_item::type_id::create("req");
    repeat(10) begin
    start_item(req);
    req.randomize();
    finish_item(req);
    end
    //`uvm_info("SEQ", {"APB Sequence Sent:\n", req.sprint()}, UVM_LOW)
  endtask

endclass*/


class apb_base_sequence extends uvm_sequence #(apb_seq_item);
  `uvm_object_utils(apb_base_sequence)
  
  function new(string name="apb_base_sequence");
    super.new(name);
  endfunction

  virtual task start_transfer(apb_seq_item req);
    start_item(req);
    finish_item(req);
  endtask
endclass

class tc1_no_transfer_seq extends apb_base_sequence;
  `uvm_object_utils(tc1_no_transfer_seq)

  virtual task body();
    apb_seq_item req = apb_seq_item::type_id::create("tc1_req");
    repeat(`no_trans) begin
    req.randomize() with {
	transfer == 0;
	};
    start_transfer(req);
   end
  endtask
endclass

class tc2_single_write_seq extends apb_base_sequence;
  `uvm_object_utils(tc2_single_write_seq)

  virtual task body();
    apb_seq_item req = apb_seq_item::type_id::create("tc2_req");
    repeat(`no_trans) begin
    req.randomize() with { 
	write_read == 1; 
	transfer == 1;
	};
    start_transfer(req);
    end
  endtask
endclass

class tc3_single_read_seq extends apb_base_sequence;
  `uvm_object_utils(tc3_single_read_seq)

  virtual task body();
    apb_seq_item req = apb_seq_item::type_id::create("tc3_req");
    repeat(`no_trans) begin
        req.randomize() with { 
	write_read == 0; 
	transfer == 1;
	};
    start_transfer(req);
    end
  endtask
endclass

class tc4_back2back_write_seq extends apb_base_sequence;
  `uvm_object_utils(tc4_back2back_write_seq)

  virtual task body();
    apb_seq_item req;
    repeat(`no_trans) begin
      req = apb_seq_item::type_id::create($sformatf("tc4_req_%0d", $time));
      req.randomize() with { write_read == 1; transfer == 1; };
      start_transfer(req);
    end
  endtask
endclass


class tc5_back2back_read_seq extends apb_base_sequence;
  `uvm_object_utils(tc5_back2back_read_seq)

  virtual task body();
    apb_seq_item req;
    repeat(`no_trans) begin
      req = apb_seq_item::type_id::create($sformatf("tc5_req_%0d", $time));
      req.randomize() with { write_read == 0; transfer == 1; };
      start_transfer(req);
    end
  endtask
endclass

class tc6_mixed_seq extends apb_base_sequence;
  `uvm_object_utils(tc6_mixed_seq)

  virtual task body();
    apb_seq_item req;
    req = apb_seq_item::type_id::create("tc6_r1");
    req = apb_seq_item::type_id::create("tc6_w");
    req = apb_seq_item::type_id::create("tc6_r2");
   
    repeat(`no_trans) begin
    req.randomize() with { write_read == 0; transfer == 1; };
    start_transfer(req);

    req.randomize() with { write_read == 1; transfer == 1; };
    start_transfer(req);

    req.randomize() with { write_read == 0; transfer == 1; };
    start_transfer(req);
   end
  endtask
endclass


class tc7_partial_strobe_write_seq extends apb_base_sequence;
  `uvm_object_utils(tc7_partial_strobe_write_seq)

  virtual task body();
    apb_seq_item req = apb_seq_item::type_id::create("tc7_req");
    repeat(`no_trans) begin
    req.randomize() with {
      write_read == 1;
      transfer == 1;
      $countones(strb_in) >= 1;                    
      $countones(strb_in) <  $bits(strb_in);      
    };
    start_transfer(req);
   end
  endtask
endclass


class tc8_zero_strobe_seq extends apb_base_sequence;
  `uvm_object_utils(tc8_zero_strobe_seq)

  virtual task body();
    apb_seq_item req = apb_seq_item::type_id::create("tc8_req");
    repeat(`no_trans) begin
    req.randomize() with {
      write_read == 1;
      transfer == 1;
      strb_in == 0; 
    };
    start_transfer(req);
   end
  endtask
endclass



class tc9_wait_state_seq extends apb_base_sequence;
  `uvm_object_utils(tc9_wait_state_seq)

  virtual task body();
    apb_seq_item req = apb_seq_item::type_id::create("tc9_req");
    repeat(`no_trans) begin
    req.randomize() with { transfer == 1; };
    start_transfer(req);
   end
  endtask
endclass


class tc10_error_handling_seq extends apb_base_sequence;
  `uvm_object_utils(tc10_error_handling_seq)

  virtual task body();
    apb_seq_item req = apb_seq_item::type_id::create("tc10_req");
    repeat(`no_trans) begin
    req.randomize() with { transfer == 1; pslverr == 1;};
    start_transfer(req);
    end
  endtask
endclass





class apb_virtual_sequence extends uvm_sequence;
  `uvm_object_utils(apb_virtual_sequence)

  apb_sequencer m_seqr;

  function new(string name="apb_virtual_sequence");
    super.new(name);
  endfunction

  virtual task body();
    if (m_seqr == null)
      `uvm_fatal("VSEQ", "Sequencer not assigned!")

    // TC1
    tc1_no_transfer_seq::type_id::create("tc1").start(m_seqr);
    // TC2
    tc2_single_write_seq::type_id::create("tc2").start(m_seqr);
    // TC3
    tc3_single_read_seq::type_id::create("tc3").start(m_seqr);
    // TC4
    tc4_back2back_write_seq::type_id::create("tc4").start(m_seqr);
    // TC5
    tc5_back2back_read_seq::type_id::create("tc5").start(m_seqr);
    // TC6
    tc6_mixed_seq::type_id::create("tc6").start(m_seqr);
    // TC7
    tc7_partial_strobe_write_seq::type_id::create("tc7").start(m_seqr);
    // TC8
    tc8_zero_strobe_seq::type_id::create("tc8").start(m_seqr);
    // TC9
    tc9_wait_state_seq::type_id::create("tc9").start(m_seqr);
    // TC10
    tc10_error_handling_seq::type_id::create("tc10").start(m_seqr);
    // TC14
   // tc11_reset_mid_seq::type_id::create("tc11").start(m_seqr);
  endtask
endclass





