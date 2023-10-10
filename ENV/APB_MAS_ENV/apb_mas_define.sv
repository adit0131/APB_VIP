/////////////////////////////////////////////////////////////////////////
// Company        : SCALEDGE 
// Engineer       : Aditya Mishra 
// Create Date    : Mon Oct  9 15:30:20 2023
// Last Modified  : Mon Oct  9 15:48:53 2023
// Modified By    : Aditya Mishra 
// File Name   	  : apb_mas_define.sv
// Project Name	  : APB_VIP 
// Description	  : 
//////////////////////////////////////////////////////////////////////////

`ifndef APB_MAS_DEFINE_SV
`define APB_MAS_DEFINE_SV

`define APB_ADDR_WIDTH 32
`define APB_DATA_WIDTH 32
`define APB_STROB_WIDTH (`APB_DATA_WIDTH)/8
`define APB_WAKEUP 0

`endif 
