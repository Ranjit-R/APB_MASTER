`include "uvm_pkg.sv"
`include "uvm_macros.svh"
`include "apb_pkg.sv"
`include "APB_interface.sv"


module top;

  import uvm_pkg::*;
  import apb_pkg::*;

  bit pclk;
  bit presetn;

  always #5 pclk = ~pclk;

  // Reset
  initial begin
    pclk    = 0;
    presetn = 0;
    #20 presetn = 1;
  end

  apb_if intf(pclk, presetn);

  apb_master#( .ADDR_WIDTH(8),.DATA_WIDTH(32))
 duv (
    .PCLK         (pclk),
    .PRESETn      (presetn),
    .PADDR        (paddr),
    .PSEL         (psel),
    .PENABLE      (penable),
    .PWRITE       (pwrite),
    .PWDATA       (pwdata),
    .PSTRB        (pstrb),
    .PRDATA       (prdata),
    .PREADY       (pready),
    .PSLVERR      (pslverr),
    .transfer     (transfer),
    .write_read   (write_read),
    .addr_in      (addr_in),
    .wdata_in     (wdata_in),
    .strb_in      (strb_in),
    .rdata_out    (rdata_out),
    .transfer_done(transfer_done),
    .error        (error)
);

  initial begin
    uvm_config_db#(virtual apb_if)::set(null, "*", "vif", intf);
    run_test("apb_write_test");
    $finish;
  end

endmodule

