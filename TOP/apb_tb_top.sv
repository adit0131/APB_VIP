/////////////////////////////////////////////////////////////////////////
// Company        : SCALEDGE 
// Engineer       : Aditya Mishra 
// Create Date    : Wed Sep 27 14:21:52 2023
// Last Modified  : Tue Oct  3 14:34:15 2023
// Modified By    : Aditya Mishra 
// File Name   	  : apb_tb_top.sv
// Module Name 	  : 
// Project Name	  : APB_VIP 
// Description	  : 
//////////////////////////////////////////////////////////////////////////

`ifndef APB_TB_TOP_SV
`define APB_TB_TOP_SV

module apb_tb_top();

  import apb_test_pkg::*;
// import the UVM package
  import uvm_pkg::*;
// include the uvm_macros.svh
	`include "uvm_macros.svh"

  bit clk=1;
  bit rstn;

  apb_mas_inf m_inf(clk,rstn);
  apb_slv_inf s_inf(clk,rstn); 

 
//--------------------------------------------------------------------------------------------
//           DUT instantiation
//--------------------------------------------------------------------------------------------


//--------------------------------------------------------------------------------------------
//           Reset Task
//--------------------------------------------------------------------------------------------

  task reset(int i);
    repeat(i)begin
    //  repeat($urandom_range(2,15))@(negedge clk);
      repeat(8)@(negedge clk);
        rstn = 1'b0;
      @(posedge clk)
      rstn = 1'b1;
    end
  endtask : reset 

//-------------------------------------------------------------------------------------------
//           Clock Genration
//-------------------------------------------------------------------------------------------
  
  initial forever #2 clk = ~clk;

//--------------------------------------------------------------------------------------------
//           set config_db
//--------------------------------------------------------------------------------------------
   initial begin
     uvm_config_db #(virtual apb_mas_inf)::set(uvm_root::get(),"*","vif_0",m_inf);   //uvm_root::get()
	   uvm_config_db #(virtual apb_slv_inf)::set(uvm_root::get(),"*","vif_0",s_inf);   //uvm_root::get()
   end
//--------------------------------------------------------------------------------------------
//           Aplying initial reset
//--------------------------------------------------------------------------------------------

   initial begin
     rstn = 1'b0;
     repeat(2)@(posedge clk);
     rstn = 1'b1;
     if($test$plusargs("UVM_TESTNAME=apb_reset_test"))
       reset(1);
   end
//--------------------------------------------------------------------------------------------
//           Calling test
//--------------------------------------------------------------------------------------------

   initial begin
      run_test();
   end

endmodule

`endif 
