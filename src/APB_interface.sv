interface apb_if #(parameter ADDR_WIDTH = 8,
                   parameter DATA_WIDTH = 32)
                  (input logic PCLK,
                   input logic PRESETn);

  logic [ADDR_WIDTH-1:0]   PADDR;
  logic                    PSEL;
  logic                    PENABLE;
  logic                    PWRITE;
  logic [DATA_WIDTH-1:0]   PWDATA;
  logic [DATA_WIDTH/8-1:0] PSTRB;

  logic [DATA_WIDTH-1:0]   PRDATA;
  logic                    PREADY;
  logic                    PSLVERR;

  logic                    transfer;
  logic                    write_read;
  logic [ADDR_WIDTH-1:0]   addr_in;
  logic [DATA_WIDTH-1:0]   wdata_in;
  logic [DATA_WIDTH/8-1:0] strb_in;

  logic [DATA_WIDTH-1:0]   rdata_out;
  logic                    transfer_done;
  logic                    error;

  clocking cb_drv @(posedge PCLK);
    default input #1step output #0;

   output transfer, write_read, addr_in, wdata_in, strb_in;
    
    output  PRDATA, PREADY, PSLVERR;
    input  rdata_out, transfer_done, error;
  endclocking

  clocking cb_mon @(posedge PCLK);
    default input #0;

    input PADDR, PSEL, PENABLE, PWRITE;
    input PWDATA, PSTRB;

    input PRDATA, PREADY, PSLVERR;
    input transfer, write_read, addr_in, wdata_in, strb_in;
    input rdata_out, transfer_done, error;
  endclocking

  modport DRIVER (clocking cb_drv);

  modport MONITOR (clocking cb_mon);

endinterface
