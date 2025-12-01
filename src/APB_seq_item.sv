`include "defines.svh"
`include "uvm_macros.svh"
import uvm_pkg::*;

class apb_seq_item extends uvm_sequence_item;

  rand bit [`addr_width-1:0] apb_addr;
  rand bit [`data_width-1:0] apb_wdata;
  rand bit [3:0]             apb_strb;
  rand bit                     apb_write;

  bit [`data_width-1:0] apb_rdata;
  bit                   pslverr;
  bit                   pready;

  constraint addr_c {
    apb_addr inside {[0 : (1<<`addr_width)-1]};
  }

  constraint strb_c {
    apb_strb inside {[1:15]}; 
  }

  `uvm_object_utils_begin(apb_seq_item)
    `uvm_field_int(apb_addr,   UVM_ALL_ON)
    `uvm_field_int(apb_wdata,  UVM_ALL_ON)
    `uvm_field_int(apb_strb,   UVM_ALL_ON)
    `uvm_field_int(apb_write,  UVM_ALL_ON)

    `uvm_field_int(apb_rdata,  UVM_NOPRINT)
    `uvm_field_int(pslverr,    UVM_NOPRINT)
    `uvm_field_int(pready,     UVM_NOPRINT)
  `uvm_object_utils_end

  function new(string name="apb_seq_item");
    super.new(name);
  endfunction


  function void do_print(uvm_printer printer);
    super.do_print(printer);

    printer.print_field_int("APB Address", apb_addr,  `addr_width);
    printer.print_field_int("APB Write Data", apb_wdata, `data_width);
    printer.print_field_int("APB STRB", apb_strb, 4);
    printer.print_field_int("APB Write/Read", apb_write, 1);

    printer.print_field_int("APB Read Data", apb_rdata, `data_width);
    printer.print_field_int("PSLVERR", pslverr, 1);
    printer.print_field_int("PREADY", pready, 1);
  endfunction

endclass

