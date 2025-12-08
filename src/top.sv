`include "uvm_pkg.sv"
`include "uvm_macros.svh"
`include "apb_pkg.sv"
`include "APB_interface.sv"
`include "design.v"
`include "apb_protocol_checker.sv"

module top;

  import uvm_pkg::*;
  import apb_pkg::*;
  //import apb_assertions_pkg::*;

  bit pclk;
  bit presetn;

  always #5 pclk = ~pclk;

  initial begin
    pclk    = 0;
    presetn = 0;
    #20 presetn = 1;
  end

  apb_if intf(pclk, presetn);

  

  apb_master #(.ADDR_WIDTH(8),.DATA_WIDTH(32)) duv (
    .PCLK         (intf.PCLK),
    .PRESETn      (intf.PRESETn),
    .PADDR        (intf.PADDR),
    .PSEL         (intf.PSEL),
    .PENABLE      (intf.PENABLE),
    .PWRITE       (intf.PWRITE),
    .PWDATA       (intf.PWDATA),
    .PSTRB        (intf.PSTRB),
    .PRDATA       (intf.PRDATA),
    .PREADY       (intf.PREADY),
    .PSLVERR      (intf.PSLVERR),
    .transfer     (intf.transfer),
    .write_read   (intf.write_read),
    .addr_in      (intf.addr_in),
    .wdata_in     (intf.wdata_in),
    .strb_in      (intf.strb_in),
    .rdata_out    (intf.rdata_out),
    .transfer_done(intf.transfer_done),
    .error        (intf.error)
  );

bind apb_master apb_master_assertions  all_inst (.vif(top.intf));

  initial begin
    uvm_config_db#(virtual apb_if)::set(null, "*", "vif", intf);
    run_test("apb_regression_test");
  end

endmodule

