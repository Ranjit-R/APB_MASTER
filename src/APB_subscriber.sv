`include "defines.svh"

class apb_subscriber extends uvm_component;

  `uvm_component_utils(apb_subscriber)

  apb_seq_item mon_item;

  real cov_report;

  uvm_tlm_analysis_fifo #(apb_seq_item) mon_cov_port;

  // ---------------------------------------------------------
  //  COVERGROUP — updated to match NEW seq_item fields
  // ---------------------------------------------------------
  covergroup cg;

    cp_pready: coverpoint mon_item.pready { bins rdy[] = {0,1}; }

    /* cp_write:  coverpoint mon_item.apb_write   { bins wr[] = {0,1}; }

    cp_addr:   coverpoint mon_item.apb_addr {
                  bins low_addr[]  = {[0:100]};
                  bins mid_addr[]  = {[101:256]};
                  bins high_addr[] = {[257:511]};
               }

    cp_wdata:  coverpoint mon_item.apb_wdata {
                  bins data_low[]  = {[0:100]};
                  bins data_mid[]  = {[101:256]};
                  bins data_high[] = {[257:511]};
               }

    cp_rdata:  coverpoint mon_item.apb_rdata {
                  bins r_low[]  = {[0:100]};
                  bins r_mid[]  = {[101:256]};
                  bins r_high[] = {[257:511]};
               }

    cp_pslverr: coverpoint mon_item.pslverr { bins err[] = {0,1}; }

    cp_strb:    coverpoint mon_item.apb_strb { bins all_strb[] = {[0:15]}; } */

  endgroup

  // ---------------------------------------------------------
  // Constructor
  // ---------------------------------------------------------
  function new(string name = "apb_subscriber", uvm_component parent);
    super.new(name,parent);
    mon_cov_port = new("mon_cov_port",this);
    cg = new();
  endfunction

  // ---------------------------------------------------------
  // RUN PHASE — get items and sample coverage
  // ---------------------------------------------------------
  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    
    forever begin
      mon_cov_port.get(mon_item);
      cg.sample();
    end
  endtask

  // ---------------------------------------------------------
  // EXTRACT PHASE
  // ---------------------------------------------------------
//   function void extract_phase(uvm_phase phase);
//     cov_report = cg.get_coverage();
//   endfunction

  // ---------------------------------------------------------
  // REPORT PHASE
  // ---------------------------------------------------------
//   function void report_phase(uvm_phase phase);
//     `uvm_info(get_type_name(),
//               $sformatf("APB Coverage = %0.2f%%", cov_report),
//               UVM_LOW)
//   endfunction

endclass

