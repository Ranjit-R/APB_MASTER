`include "defines.svh"

class apb_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(apb_scoreboard)

  uvm_tlm_analysis_fifo #(apb_seq_item) act_mon_scb_port;

  uvm_tlm_analysis_fifo #(apb_seq_item) pas_mon_scb_port;

  apb_seq_item expected_q[$];
 
  apb_seq_item current_expected;

  typedef enum {
    IDLE,
    SETUP,
    ACCESS
  } input_state_e;

  input_state_e current_state;

  int total_checks   = 0;
  int matched        = 0;
  int mismatched     = 0;
  uvm_event event_synch;

  function new(string name="apb_scoreboard", uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    act_mon_scb_port = new("act_mon_scb_port", this);
    pas_mon_scb_port = new("pas_mon_scb_port", this);
    current_state    = IDLE;
    current_expected = null;
    event_synch = new(" event_synch ");
  endfunction

  virtual task run_phase(uvm_phase phase);
    fork
      collect_expected(); 
      collect_actual();   
    join
  endtask

  task collect_expected();
    apb_seq_item item;

    forever begin
      act_mon_scb_port.get(item);

      `uvm_info("SCB_IN",
        $sformatf("Input: Addr=0x%0h, %s, Data=0x%0h, PSTRB=0x%0h, transfer=%0b, transfer_done=%0b",
          item.addr_in,
          item.write_read ? "WRITE" : "READ",
          item.write_read ? item.wdata_in : item.prdata,
          item.strb_in,
          item.transfer,
          item.transfer_done),
        UVM_MEDIUM)

      case (current_state)

        IDLE: begin
          if (item.transfer) begin
            `uvm_info("SCB_FSM_IN", "IDLE -> SETUP (new transfer)", UVM_HIGH)

            current_expected = apb_seq_item::type_id::create("exp_txn", this);
            current_expected.addr_in     = item.addr_in;
            current_expected.write_read  = item.write_read;
            current_expected.wdata_in    = item.wdata_in;
            current_expected.strb_in     = item.strb_in;  // Added: Capture PSTRB
              current_state = SETUP;
          end
          else begin
            `uvm_info("SCB_FSM_IN", "IDLE (no transfer)", UVM_HIGH)
          end
        end

        SETUP: begin
          `uvm_info("SCB_FSM_IN", "SETUP -> ACCESS", UVM_HIGH)
          current_state = ACCESS;
        end

        ACCESS: begin
          if (item.pready) begin
            `uvm_info("SCB_FSM_IN", "ACCESS -> IDLE (transfer done)", UVM_HIGH)

            if (!current_expected.write_read)
              current_expected.prdata = item.prdata;

            expected_q.push_back(current_expected);
	    event_synch.trigger();
            current_expected = null;
            current_state    = IDLE;
          end
          else begin
            `uvm_info("SCB_FSM_IN", "ACCESS (waiting for done)", UVM_HIGH)
          end
        end

        default: begin
          `uvm_error("SCB_FSM_IN", "Unknown state in expected collector!")
          current_state    = IDLE;
          current_expected = null;
        end

      endcase
     // $display(" current_state %0d",current_state);
    end
  endtask

  task collect_actual();
    apb_seq_item actual;
    apb_seq_item expected;

    forever begin
      
      pas_mon_scb_port.get(actual);
	//actual.print_item_output();

     `uvm_info("SCB_OUT",$sformatf("Output: Addr=0x%0h, PSEL=%0b, PENABLE=%0b, PREADY=%0b, PWRITE=%0b", actual.paddr, actual.psel, actual.penable, actual.pready, actual.pwrite), UVM_LOW)

      if (actual.psel && actual.penable && actual.pready) begin

        if (expected_q.size() == 0) begin
           event_synch.wait_trigger();
        end

        expected = expected_q.pop_front();
        compare(expected, actual);
      end
    end
  endtask

  function void compare(apb_seq_item expected, apb_seq_item actual);
    bit addr_ok, data_ok, op_ok;
    bit strb_ok;  // Added: PSTRB check flag
    string op_type;

    total_checks++;

    addr_ok = (expected.addr_in == actual.paddr);
    op_ok   = (expected.write_read == actual.pwrite);
    op_type = actual.pwrite ? "WRITE" : "READ";

    if (actual.pwrite) begin
      data_ok = (expected.wdata_in == actual.pwdata);
      strb_ok = (expected.strb_in == actual.pstrb);  // Added: Check PSTRB for writes
    end
    else begin
      data_ok = (expected.prdata == actual.rdata_out);
      strb_ok = 1'b1;  // Added: PSTRB not checked for reads
    end

    if (addr_ok && data_ok && op_ok && strb_ok) begin  // Added: strb_ok to pass condition
      matched++;
      `uvm_info("SCB",
        $sformatf("PASS - %s | Addr: 0x%0h | Data: 0x%0h%s",
          op_type,
          actual.paddr,
          actual.pwrite ? actual.pwdata : actual.rdata_out,
          actual.pwrite ? $sformatf(" | PSTRB: 0x%0h", actual.pstrb) : ""),  // Added: Display PSTRB
        UVM_LOW)
    end
    else begin
      mismatched++;
      `uvm_error("SCB",
        $sformatf("FAIL - %s\n  Expected: Addr=0x%0h, Data=0x%0h, OP=%0s%s\n  Got:      Addr=0x%0h, Data=0x%0h, OP=%0s%s",
          op_type,
          expected.addr_in,
          expected.write_read ? expected.wdata_in : expected.prdata,
          expected.write_read ? "WRITE" : "READ",
          expected.write_read ? $sformatf(", PSTRB=0x%0h", expected.strb_in) : "",  // Added: Display expected PSTRB
          actual.paddr,
          actual.pwrite ? actual.pwdata : actual.rdata_out,
          actual.pwrite ? "WRITE" : "READ",
          actual.pwrite ? $sformatf(", PSTRB=0x%0h", actual.pstrb) : ""))  // Added: Display actual PSTRB
    end
  endfunction

  virtual function void report_phase(uvm_phase phase);
    real pass_rate;

    super.report_phase(phase);

    if (total_checks > 0)
      pass_rate = (matched * 100.0) / total_checks;
    else
      pass_rate = 0.0;

    `uvm_info("SCOREBOARD",
      {"\n",
       "========================================\n",
       "        SCOREBOARD RESULTS\n",
       "========================================\n",
       $sformatf("  Total Checks  : %0d\n", total_checks),
       $sformatf("  Passed        : %0d\n", matched),
       $sformatf("  Failed        : %0d\n", mismatched),
       $sformatf("  Pass Rate     : %.2f%%\n", pass_rate),
       "========================================\n"
      }, UVM_NONE)

    if (mismatched > 0)
      `uvm_error("SCOREBOARD", $sformatf("TEST FAILED with %0d errors!", mismatched))
    else if (total_checks > 0)
      `uvm_info("SCOREBOARD", "ALL TESTS PASSED!", UVM_NONE)
  endfunction

endclass
