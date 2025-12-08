
`include "defines.svh"
`include "uvm_macros.svh"
import uvm_pkg::*;

class apb_seq_item extends uvm_sequence_item;

 
  bit [`addr_width-1:0]       paddr;     
  bit                         psel;     
  bit                         penable;   
  bit                         pwrite;      
  bit [`data_width-1:0]       pwdata;    
  bit [(`data_width/8)-1:0]   pstrb;     

  rand bit [`data_width-1:0]       prdata;      
  rand bit                         pready;     
  rand bit                         pslverr;     

  rand bit                    transfer;    
  rand bit                    write_read;    
  rand bit [`addr_width-1:0]  addr_in;       
  rand bit [`data_width-1:0]  wdata_in;     
  rand bit [(`data_width/8)-1:0] strb_in;     

  bit [`data_width-1:0]       rdata_out;      
  bit                         transfer_done;  
  bit                         error;          

  /*constraint c_addr  { addr_in inside {[10 : 100]}; }
  constraint c_pready { pready == 1;}
  constraint c_prdata { prdata inside {[10 : 100]}; }
  constraint c_strb { if (write_read == 1) strb_in != 0; else strb_in == 0; }
  constraint c_trans { transfer!=0; }
  constraint c_wdata { wdata_in inside {[10:100]}; }
  //constraint c_write_read { write_read dist{0 := 50, 1:=50}; }
  constraint c_write_read { write_read  == 1; }*/

  `uvm_object_utils_begin(apb_seq_item)

    
    `uvm_field_int(paddr,        UVM_ALL_ON)
    `uvm_field_int(psel,         UVM_ALL_ON)
    `uvm_field_int(penable,      UVM_ALL_ON)
    `uvm_field_int(pwrite,       UVM_ALL_ON)
    `uvm_field_int(pwdata,       UVM_ALL_ON)
    `uvm_field_int(pstrb,        UVM_ALL_ON)

    
    `uvm_field_int(prdata,       UVM_NOPRINT)
    `uvm_field_int(pready,       UVM_NOPRINT)
    `uvm_field_int(pslverr,      UVM_NOPRINT)

    
    `uvm_field_int(transfer,     UVM_ALL_ON)
    `uvm_field_int(write_read,   UVM_ALL_ON)
    `uvm_field_int(addr_in,      UVM_ALL_ON)
    `uvm_field_int(wdata_in,     UVM_ALL_ON)
    `uvm_field_int(strb_in,      UVM_ALL_ON)

   
    `uvm_field_int(rdata_out,     UVM_NOPRINT)
    `uvm_field_int(transfer_done, UVM_NOPRINT)
    `uvm_field_int(error,         UVM_NOPRINT)

   `uvm_object_utils_end

 
  function new(string name = "apb_seq_item");
    super.new(name);
  endfunction

  function void do_print(uvm_printer printer);
    super.do_print(printer);


   
    printer.print_field("paddr",      paddr,      `addr_width, UVM_HEX);
    printer.print_field("psel",       psel,       1, UVM_BIN);
    printer.print_field("penable",    penable,    1, UVM_BIN);
    printer.print_field("pwrite",     pwrite,     1, UVM_BIN);
    printer.print_field("pwdata",     pwdata,     `data_width, UVM_HEX);
    printer.print_field("pstrb",      pstrb,      (`data_width/8), UVM_HEX);

    
    printer.print_field("prdata",     prdata,     `data_width, UVM_HEX);
    printer.print_field("pready",     pready,     1, UVM_BIN);
    printer.print_field("pslverr",    pslverr,    1, UVM_BIN);

    
    printer.print_field("transfer",   transfer,   1, UVM_BIN);
    printer.print_field("write_read", write_read, 1, UVM_BIN);
    printer.print_field("addr_in",    addr_in,    `addr_width, UVM_HEX);
    printer.print_field("wdata_in",   wdata_in,   `data_width, UVM_HEX);
    printer.print_field("strb_in",    strb_in,    (`data_width/8), UVM_HEX);

  
    printer.print_field("rdata_out",     rdata_out,     `data_width, UVM_HEX);
    printer.print_field("transfer_done", transfer_done, 1, UVM_BIN);
    printer.print_field("error",         error,         1, UVM_BIN);

  endfunction

virtual function void print_item_input();
  
  $display("--------------------------------------------------");
  $display(" APB SEQ INPUT ITEM");
  $display("--------------------------------------------------");

  $display("PRDATA		\t= %0d",   prdata);
  $display("PREADY		\t= %0b",   pready);

  $display("PSLVERR		\t= %0b",   pslverr);
  $display("transfer	\t\t= %0b",   transfer);

  $display("write_read	\t\t= %0b",   write_read);

  $display("addr_in		\t= 0x%0d", addr_in);
  $display("wdata_in	\t\t= %0d",   wdata_in);
  $display("strb_in		\t= %0d",   strb_in);

  $display("--------------------------------------------------");

endfunction
  
  virtual function void print_item_output();
  
  $display("--------------------------------------------------");
    $display(" APB SEQ OUTPUT ITEM");
  $display("--------------------------------------------------");

  $display("PADDR		\t= %0d",   paddr);
  $display("PSEL		\t= %0b",   psel);

  $display("PENABLE		= %0b",   penable);
  $display("pwrite		= %0b",   pwrite);
  $display("PWDATA		= %0d",   pwdata);

  $display("PSTRB		\t= %0d",   pstrb);

  $display("rdata_out	\t= 0x%0d", rdata_out);
    $display("tran_done	\t= %0b",   transfer_done);
  $display("error		\t= %0b",   error);

  $display("--------------------------------------------------");

endfunction


endclass

