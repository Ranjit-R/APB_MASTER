module apb_master_assertions #(
  parameter ADDR_WIDTH = 8,
  parameter DATA_WIDTH = 32
)(
  apb_if vif
);

  property idle_to_setup;
    @(posedge vif.PCLK) disable iff (!vif.PRESETn)
    vif.transfer |=> vif.PSEL;
  endproperty

  assert property(idle_to_setup)
  else $error("Protocol Error: PSEL didn't assert after Transfer at time %0t", $time);

  property setup_to_access;
    @(posedge vif.PCLK) disable iff (!vif.PRESETn)
    (vif.PSEL && !vif.PENABLE) |=> vif.PENABLE;
  endproperty
  
  assert property(setup_to_access)
  else $error("Protocol Error: PENABLE didn't assert after PSEL at time %0t", $time);

 property penable_needs_psel;
    @(posedge vif.PCLK) disable iff (!vif.PRESETn)
    vif.PENABLE |-> vif.PSEL;
  endproperty
  
  assert property(penable_needs_psel)
  else $error("Protocol Error: PENABLE is high but PSEL is low at time %0t", $time);

   /*property penable_deassert;
    @(posedge vif.PCLK) disable iff (!vif.PRESETn)
    (vif.PSEL && vif.PENABLE && vif.PREADY) |=> !vif.PENABLE;
  endproperty
  
  assert property(penable_deassert)
  else $error("Protocol Error: PENABLE stuck high after PREADY at time %0t", $time);

  property addr_stable;
    @(posedge vif.PCLK) disable iff (!vif.PRESETn)
    (vif.PSEL && vif.PENABLE && !vif.PREADY) |=> $stable(vif.PADDR);
  endproperty
  
  assert property(addr_stable)
  else $error("Stability Error: PADDR changed during wait state at time %0t", $time);

  property write_stable;
    @(posedge vif.PCLK) disable iff (!vif.PRESETn)
    (vif.PSEL && vif.PENABLE && !vif.PREADY) |=> $stable(vif.PWRITE);
  endproperty
  
  assert property(write_stable)
  else $error("Stability Error: PWRITE changed during wait state at time %0t", $time);

  property wdata_stable;
    @(posedge vif.PCLK) disable iff (!vif.PRESETn)
    (vif.PSEL && vif.PENABLE && vif.PWRITE && !vif.PREADY) |=> $stable(vif.PWDATA);
  endproperty
  
  assert property(wdata_stable)
  else $error("Stability Error: PWDATA changed during write wait at time %0t", $time);

  property addr_valid;
    @(posedge vif.PCLK) disable iff (!vif.PRESETn)
    (vif.PSEL && !vif.PENABLE) |-> !$isunknown(vif.PADDR);
  endproperty
  
  assert property(addr_valid)
  else $error("Invalid Signal: PADDR has X/Z values at time %0t", $time);

  property write_valid;
    @(posedge vif.PCLK) disable iff (!vif.PRESETn)
    (vif.PSEL && !vif.PENABLE) |-> !$isunknown(vif.PWRITE);
  endproperty
  
  assert property(write_valid)
  else $error("Invalid Signal: PWRITE has X/Z values at time %0t", $time);

  property wdata_valid;
    @(posedge vif.PCLK) disable iff (!vif.PRESETn)
    (vif.PSEL && vif.PWRITE) |-> !$isunknown(vif.PWDATA);
  endproperty
  
  assert property(wdata_valid)
  else $error("Invalid Signal: PWDATA has X/Z values during write at time %0t", $time);

  property strb_zero_read;
    @(posedge vif.PCLK) disable iff (!vif.PRESETn)
    (vif.PSEL && !vif.PWRITE) |-> (vif.PSTRB == '0);
  endproperty
  
  assert property(strb_zero_read)
  else $error(" Strobe Error: PSTRB should be 0 during read at time %0t", $time);

  property reset_check;
    @(posedge vif.PCLK)
    (!vif.PRESETn) |-> (!vif.PSEL && !vif.PENABLE);
  endproperty
  
  assert property(reset_check)
  else $error(" Reset Error: Control signals not cleared during reset at time %0t", $time); */

endmodule
