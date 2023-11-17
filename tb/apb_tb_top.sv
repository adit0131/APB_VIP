/////////////////////////////////////////////////////////////////////////
// Company        : SCALEDGE 
// Engineer       : Aditya Mishra 
// Create Date    : Wed Sep 27 14:21:52 2023
// Last Modified  : Fri Nov 17 12:16:30 2023
// Modified By    : Aditya Mishra
// File Name   	  : apb_tb_top.sv
// Module Name 	  : 
// Project Name	  : APB_VIP 
// Description	  : 
//////////////////////////////////////////////////////////////////////////

`ifndef APB_TB_TOP_SV
`define APB_TB_TOP_SV

`include "uvm_pkg.sv"
`include "svt_apb.uvm.pkg"
`include "svt_apb_if.svi"
`include "../include/apb_uvc_define.sv"
`include "apb_mas_inf.sv"
`include "apb_slv_inf.sv"

module apb_tb_top();

  /** Import UVM Package */
  import uvm_pkg::*;
  
  /** Import the SVT UVM Package */
  import svt_uvm_pkg::*;
  
  /** Import the APB VIP */
  import svt_apb_uvm_pkg::*;
  
  /** include the uvm_macros.svh */
	`include "uvm_macros.svh"
  
  /** include test pkg or Your Design UVC PKG */
  import apb_uvc_pkg::*;
  
  /** Parameter defines the clock frequency */
  parameter simulation_cycle = 50;
  
  /** Signal to generate the clock */
  bit clk;
  
  /** Signal to generate the reset */
  bit rstn;

  /** VIP Interfaces */
  apb_mas_inf m_inf(clk,rstn);

  /** VIP Interfaces */
  apb_slv_inf s_inf(clk,rstn);

  /** VIP Interfacec */
  svt_apb_if apb_if();

  /** VIP Interface ports mapping */
  assign apb_if.pclk = clk;
  always@(*) apb_if.psel = m_inf.PSEL;
  always@(*) apb_if.penable = m_inf.PENABLE;
  always@(*) apb_if.paddr   = m_inf.PADDR;
  always@(*) apb_if.pwdata  = m_inf.PWDATA;
  always@(*) apb_if.pwrite  = m_inf.PWRITE;
  always@(*) apb_if.pstrb  = m_inf.PSTROB;
  always@(*) apb_if.pprot   = m_inf.PPROT;
/*always@(*) m_inf.PRDATA  = apb_if.prdata;
  always@(*) m_inf.PSLVERR = apb_if.pslverr;
  always@(*) m_inf.PREADY  = apb_if.pready;
*/ 

  /** VIP Interface ports mapping */
  always@(*) s_inf.PSEL = m_inf.PSEL;
  always@(*) s_inf.PENABLE = m_inf.PENABLE;
  always@(*) s_inf.PADDR   = m_inf.PADDR;
  always@(*) s_inf.PWDATA  = m_inf.PWDATA;
  always@(*) s_inf.PWRITE  = m_inf.PWRITE;
  always@(*) s_inf.PSTROB  = m_inf.PSTROB;
  always@(*) s_inf.PPROT   = m_inf.PPROT;
  always@(*) m_inf.PRDATA  = s_inf.PRDATA;
  always@(*) m_inf.PSLVERR = s_inf.PSLVERR;
  always@(*) m_inf.PREADY  = s_inf.PREADY;
 
  /**
   * Assign the reset pin from the reset interface to the reset pins from the VIP
   * interface.
   */
  assign apb_if.presetn = rstn;
  
  /** Factory Variable */
  uvm_factory factory_h = uvm_factory::get();

//--------------------------------------------------------------------------------------------
//           DUT instantiation
//--------------------------------------------------------------------------------------------

//--------------------------------------------------------------------------------------------
//           ASSERTION BINDING
//--------------------------------------------------------------------------------------------
    
     apb_assertions bind_mod(clk,rstn, m_inf.apb_mas_mon_cb.PSEL,
                                           m_inf.apb_mas_mon_cb.PENABLE,
                                           m_inf.apb_mas_mon_cb.PADDR,
                                           m_inf.apb_mas_mon_cb.PWDATA,
                                           m_inf.apb_mas_mon_cb.PWRITE,
                                           m_inf.apb_mas_mon_cb.PSTROB,
                                           m_inf.apb_mas_mon_cb.PPROT,
                                           m_inf.apb_mas_mon_cb.PSLVERR,
                                           m_inf.apb_mas_mon_cb.PRDATA,
                                           m_inf.apb_mas_mon_cb.PREADY); 


//--------------------------------------------------------------------------------------------
//           Reset Task
//------------------------------------------------------------------------------------------

  task reset(int i);
    repeat(i)begin
      repeat($urandom_range(2,15))@(negedge clk);
    //  repeat(8)@(negedge clk);
        rstn = 1'b0;
      @(posedge clk)
      rstn = 1'b1;
    end
  endtask : reset 
//------------------------------------------------------------------------------------------
//    Optionally dump the sim variable for waveform display
//------------------------------------------------------------------------------------------
`ifdef WAVES_FSDB
  initial begin
    $fsdbDumpfile("test_top");
    $fsdbDumpvars;
  end
`elsif WAVES_VCD
  initial begin
    $dumpvars;
  end
`elsif WAVES
  initial begin
    $vcdpluson;
  end
`endif
 
//-------------------------------------------------------------------------------------------
//           Clock Genration
//-------------------------------------------------------------------------------------------
  
  initial forever #(simulation_cycle/2) clk = ~clk;

//--------------------------------------------------------------------------------------------
//           set config_db
//--------------------------------------------------------------------------------------------
   initial begin
    /**
     * Provide the APB SV interfaces to the APB System ENV. This step establishes the
     * connection between the APB System ENV and the HDL Interconnect wrapper, through the
     * APB interfaces.
     */
     uvm_config_db#(svt_apb_vif)::set(uvm_root::get(), "uvm_test_top.top_env.apb_master_env", "vif", apb_if);
     uvm_config_db #(virtual apb_mas_inf)::set(uvm_root::get(),"*","vif_0",m_inf);   //uvm_root::get()
	   uvm_config_db #(virtual apb_slv_inf)::set(uvm_root::get(),"*","vif_1",s_inf);   //uvm_root::get()
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
      factory_h.print();
      run_test();
   end

endmodule

`endif 
