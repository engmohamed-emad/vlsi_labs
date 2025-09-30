// This is the SystemVerilog interface that we will use to connect
// our design to our UVM testbench.
interface dut_if;
  logic clock, reset, enable;
  logic [2:0] count; // 3-bit counter output
endinterface

`include "uvm_macros.svh"
// 3-bit async reset, enable counter
module dut(dut_if dif);
  import uvm_pkg::*;


  
 always @(posedge dif.clock or negedge dif.clock) begin
    if (dif.reset) begin
      dif.count = 3'b000;
      `uvm_info("DUT",
                 $sformatf(" RESET clk = %b Applied reset=%0b enable=%0b -> Counter=%0d",dif.clock,dif.reset, dif.enable, dif.count),
                UVM_MEDIUM) 
    end else if (dif.enable) begin
      if(dif.clock)
        begin
      dif.count = dif.count + 1'b1;
        end 
       `uvm_info("DUT",
                 $sformatf(" PLUS clk = %b Applied reset=%0b enable=%0b -> Counter=%0d",dif.clock,dif.reset, dif.enable, dif.count),
                UVM_MEDIUM) 
    end
    else
       `uvm_info("DUT",
                 $sformatf(" STOP clk = %b Applied reset=%0b enable=%0b -> Counter=%0d",dif.clock,dif.reset, dif.enable, dif.count),
                UVM_MEDIUM) 
      
  end



endmodule
