`include "defines.svh"
import uvm_pkg::*;

class apb_environment extends uvm_env;

  `uvm_component_utils(apb_environment)

  apb_agent       agt;
  apb_scoreboard  scb;
  apb_subscriber  cov;

  function new(string name="apb_environment", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    agt = apb_agent     ::type_id::create("agt", this);
    scb = apb_scoreboard::type_id::create("scb", this);
    cov = apb_subscriber::type_id::create("cov", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    agt.a_mon.mon_ap.connect(scb.act_mon_scb_port.analysis_export);
    agt.a_mon.mon_ap.connect(cov.mon_cov_port.analysis_export);

    agt.p_mon.mon_ap.connect(scb.pas_mon_scb_port.analysis_export);
    agt.p_mon.mon_ap.connect(cov.mon_cov_port.analysis_export);

  endfunction

endclass

