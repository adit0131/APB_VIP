/////////////////////////////////////////////////////////////////////////
// Company        : SCALEDGE 
// Engineer       : Aditya Mishra 
// Create Date    : Mon Oct  9 15:49:18 2023
// Last Modified  : Mon Nov 13 11:51:01 2023
// Modified By    : Aditya Mishra
// File Name   	  : apb_mas_inf.sv
// Interface Name : apb_mas_inf
// Project Name	  : APB_VIP
// Description	  : 
//////////////////////////////////////////////////////////////////////////

`ifndef APB_MAS_INF_SV
`define APB_MAS_INF_SV


interface apb_mas_inf (input clk,
                       input rstn);

//Master as Source Signas.  
  logic                           PSEL;     //Indicates the selection of slave
  logic                           PENABLE;  //Indicates the Transfer.
  logic [(`APB_ADDR_WIDTH-1):0]   PADDR;    //Indicates teh Adderes Bus.
  logic [(`APB_DATA_WIDTH-1):0]   PWDATA;   //Indicates the Write Data Bus.
  logic                           PWRITE;   //Indicates the direction of opration for Read or Write.
  logic [(`APB_STROB_WIDTH-1):0]  PSTROB;   //Indicates the Strobe signal for data spars selection.
  logic [2:0]                     PPROT;    //Indicates the protect signal which enables the sequre transfer for bus.
//slave as Source Signals.
  logic                           PSLVERR;  //Indicate the error.
  logic [(`APB_DATA_WIDTH-1):0]   PRDATA;   //indicates the Read Data Bus.
  logic                           PREADY ;   //Indicates the Slave is ready to accsept.

  clocking apb_m_drv_cb @(posedge clk);
    default input #1 output #0;
     output PSEL;
     output PENABLE;
     output PADDR;
     output PWDATA;
     output PWRITE;
     output PSTROB;
     output PPROT;
     input  PSLVERR;
     input  PRDATA;
     input  PREADY;
  endclocking

  clocking apb_mas_mon_cb @(posedge clk);
    default input #1 output #0;
    input  PSEL;
    input  PENABLE;
    input  PADDR;
    input  PWDATA;
    input  PWRITE;
    input  PSTROB;
    input  PPROT;
    input  PSLVERR;
    input  PRDATA;
    input  PREADY;
  endclocking
 
endinterface                    
`endif 
