/////////////////////////////////////////////////////////////////////////
// Company        : SCALEDGE 
// Engineer       : Satyajeet Sakariya 
// Create Date    : Wed Oct 25 15:49:18 2023
// Last Modified  : Thu Nov 16 11:22:53 2023
// Modified By    : Aditya Mishra
// File Name   	  : apb_assertions.sv
// Module Name    : apb_assertions
// Project Name	  : APB_VIP
// Description	  : this module contains assertions
//////////////////////////////////////////////////////////////////////////

//-----------------------------------------------------------------------------
//module : apb_assertions 
//-----------------------------------------------------------------------------


import uvm_pkg::*;
`include "apb_uvc_define.sv"
`include "uvm_macros.svh"


module apb_assertions
// Taking signal as input to monitor
( input bit clk,
        bit PRESET,
        logic                          PSEL,     
        logic                          PENABLE,  
        logic [(`APB_ADDR_WIDTH-1):0]  PADDR,    
        logic [(`APB_DATA_WIDTH-1):0]  PWDATA,   
        logic                          PWRITE,   
        logic [(`APB_STROB_WIDTH-1):0] PSTROB,   
        logic [2:0]                    PPROT,    
        logic                          PSLVERR,  
        logic [(`APB_DATA_WIDTH-1):0]  PRDATA,   
        logic                          PREADY);

//-----------------------------------------------------------------------------------------------------
//assertion sequence and properties 
//-----------------------------------------------------------------------------------------------------

// property to check control signals are in known state if Psel is asserted
    property CONTROL_SIGNALS_KNOWN;
      @(posedge clk) disable iff (!PRESET) PSEL |-> (!$isunknown(PADDR) && !$isunknown(PWRITE) && !$isunknown(PENABLE));
    endproperty

    assert property (CONTROL_SIGNALS_KNOWN)
       `uvm_info(" apb_assertions","CONTROL_SIGNALS_KNOWN PASS !!!",UVM_LOW)
    else
       `uvm_error(" apb_assertions","CONTROL_SIGNALS_KNOWN FAILED !!!!")      
//----------------------------------------------------------------------------------------------------

// prop to check penb high after one cycle of psel  
    property PSEL_TO_PENB;
      @(posedge clk) disable iff (!PRESET) PENABLE |-> $past(PSEL,1);
    endproperty 
 
    assert property (PSEL_TO_PENB) 
       `uvm_info("apb_assertions","PSEL_TO_PENB PASS !!!",UVM_LOW)
    else
       `uvm_error("apb_assertions","PSEL_TO_PENB FAILED !!!!")    
//----------------------------------------------------------------------------------------------------


// prop to check penb low after getting PREADY
    property PRDY_TO_PENB;
      @(posedge clk) disable iff (!PRESET) ($rose(PREADY) && PSEL) |=> !PENABLE
    endproperty 

    assert property (PRDY_TO_PENB) 
       `uvm_info("apb_assertions","PRDY_TO_PENB PASS !!!",UVM_LOW)
    else
       `uvm_error("apb_assertions","PRDY_TO_PENB FAILED !!!!")   
//----------------------------------------------------------------------------------------------------


//Assertion for clock 
   realtime time_period = 10ns;
   property CLOCK;
      realtime current_time;
      @(posedge clk) disable iff(!PRESET) (1,current_time = $realtime) |=> (time_period == ($realtime - current_time));
   endproperty 

   assert property(CLOCK)
      `uvm_info(" apb_assertions","CLOCK PASSED!!",UVM_LOW)
   else
      `uvm_error(" apb_assertions","CLOCK FAILED!!! ");
//----------------------------------------------------------------------------------------------------


//property to check if PREADY asserted in time
    property PRDY_TIMEOUT;
      @(posedge clk) disable iff (!PRESET) (PSEL&&PENABLE) |-> ##[0:`timeout] PREADY;
    endproperty  

    assert property (PRDY_TIMEOUT) 
       `uvm_info("apb_assertions","PRDY_TIMEOUT PASS !!!",UVM_LOW)
    else
       `uvm_error("apb_assertions","PRDY_TIMEOUT FAILED!!!!")  
//----------------------------------------------------------------------------------------------------


//property check if PSEL is low, Penb will be low
    property PSEL_PENB_LOW;
      @(posedge clk) disable iff (!PRESET) !PSEL |-> !PENABLE;
    endproperty  

    assert property (PSEL_PENB_LOW) 
       `uvm_info("apb_assertions","PSEL_PENB_LOW PASS !!!",UVM_LOW)
    else
       `uvm_error("apb_assertions","PSEL_PENB_LOW FAILED!!!!")
//----------------------------------------------------------------------------------------------------


// To check that PSTRB is low when PWRITE low
    property PSTRB_LOW_READ;
      @(posedge clk) disable iff(!PRESET) !PWRITE |-> !PPROT;
    endproperty

    assert property (PSTRB_LOW_READ)
       `uvm_info("apb_assertions","PSTRB_LOW_READ PASS !!!",UVM_LOW)
    else
       `uvm_error("apb_assertions","PSTRB_LOW_READ FAILED !!!!")     
//----------------------------------------------------------------------------------------------------


//signals at reset
   
    sequence CONTROL_SIGNALS_LOW;
      ((!PSEL) && (!PENABLE) && (PWDATA==0) && (PADDR==0) && ( PSTROB == 0 ) && ( PPROT == 0) ) ;
    endsequence
    property RESET_ASSERTED;
      @(negedge PRESET) 1'b1 |-> @( posedge PRESET )  CONTROL_SIGNALS_LOW ;
    endproperty  

    assert property (RESET_ASSERTED) 
       `uvm_info("apb_assertions","RESET_ASSERTED PASS !!!",UVM_LOW)
    else
       `uvm_error("apb_assertions","RESET_ASSERTED FAILED!!!!")      
//----------------------------------------------------------------------------------------------------


//signals need to be stable  
    property PSEL_ACTIVE_SIGNALS_STABLE;
      @(posedge clk) disable iff (!PRESET) PSEL |=> 
            $stable(PADDR)&&$stable(PWRITE)&&$stable(PWDATA)&&$stable(PSTROB)&&$stable(PPROT) 
                                                            [*0:(`timeout+1)] ##1 $fell(PENABLE);
    endproperty 

    assert property (PSEL_ACTIVE_SIGNALS_STABLE) 
       `uvm_info("apb_assertions","PSEL_ACTIVE_SIGNALS_STABLE PASS !!!",UVM_LOW)
    else
       `uvm_error("apb_assertions","PSEL_ACTIVE_SIGNALS_STABLE FAILED!!!!")   
//----------------------------------------------------------------------------------------------------


// checking that if write operation than wdata is in known state
    property WDATA_KNOWN ;
      @(posedge clk) disable iff (!PRESET) (PSEL && PWRITE) |-> !$isunknown(PWDATA);
    endproperty

    assert property (WDATA_KNOWN ) 
       `uvm_info("apb_assertions","WDATA_KNOWN PASS !!!",UVM_LOW)
    else
       `uvm_error("apb_assertions","WDATA_KNOWN FAILED!!!!")       
//----------------------------------------------------------------------------------------------------


// checking that if read operation than rdata is in known state
    property RDATA_KNOWN ;
      @(posedge clk) disable iff (!PRESET) (PSEL && !PWRITE && PREADY) |-> !$isunknown(PRDATA);
    endproperty
    assert property (RDATA_KNOWN ) 
       `uvm_info("apb_assertions","RDATA_KNOWN PASS !!!",UVM_LOW)
    else
       `uvm_error("apb_assertions","RDATA_KNOWN FAILED!!!!")   
endmodule

