class apb_sequence extends uvm_sequence #(apb_seq_item);

  `uvm_object_utils(apb_sequence)



  function new(string name="apb_sequence");
    super.new(name);
  endfunction


  virtual task body();
    apb_seq_item req;
    
    req = apb_seq_item::type_id::create("req");
    repeat(5) begin
    start_item(req);
    assert(req.randomize() with {
      apb_addr inside{[10:100]};
      apb_wdata inside{[10:100]};
    });

    finish_item(req);
    end
    `uvm_info("SEQ", {"APB Sequence Sent:\n", req.sprint()}, UVM_LOW)
  endtask

endclass



