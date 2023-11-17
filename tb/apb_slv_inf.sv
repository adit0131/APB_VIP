/////////////////////////////////////////////////////////////////////////                                                                     2 // Company        : SCALEDGE
// Company        : SCALEDGE
// Engineer       : Aditya Mishra
// Create Date    : Mon Oct 23 15:23:48 2023
// Last Modified  : Mon Nov 13 11:51:43 2023
// Modified By    : Aditya Mishra
// File Name      : apb_slv_inf.sv
// Class Name     :
// Project Name   :
// Description    :
//////////////////////////////////////////////////////////////////////////

`ifndef APB_SLV_INF_SV
`define APB_SLV_INF_SV

interface apb_slv_inf (input clk,
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
  logic                           PREADY;   //Indicates the Slave is ready to accsept.

  clocking apb_slv_drv_cb@(posedge clk);
    default input #1 output #0;
     input   PSEL;
     input   PENABLE;
     input   PADDR;
     input   PWDATA;
     input   PWRITE;
     input   PSTROB;
     input   PPROT;
     output  PSLVERR;
     output  PRDATA;
     output  PREADY;
  endclocking

  clocking apb_slv_mon_cb@(posedge clk);
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
 
  // modport for driver
  modport apb_slv_drv_mp( clocking apb_slv_drv_cb , input rstn );

 // modport for monitor
  modport apb_slv_mon_mp( clocking apb_slv_mon_cb , input rstn );


endinterface                    
`endif 
