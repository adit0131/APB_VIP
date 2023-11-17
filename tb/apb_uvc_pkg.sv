/////////////////////////////////////////////////////////////////////////                                                                     2 // Company        : SCALEDGE
// Company        : SCALEDGE
// Engineer       : Aditya Mishra
// Create Date    : Wed Oct 25 12:44:07 2023
// Last Modified  : Thu Nov 16 11:49:37 2023
// Modified By    : Aditya Mishra
// File Name      : apb_uvc_pkg.sv
// Package Name   : apb_uvc_pkg
// Project Name   : APB_UVC
// Description    :
//////////////////////////////////////////////////////////////////////////


`ifndef APB_UVC_PKG_SV
`define APB_UVC_PKG_SV

package apb_uvc_pkg;
  
   import uvm_pkg::*;
   import apb_uvc_test_pkg::*;
   import apb_uvc_env_top_pkg::*;
   import apb_uvc_seq_pkg::*;
   import apb_uvc_master_pkg::*;
   import apb_uvc_slave_pkg::*;
    
   `include "uvm_macros.svh"
 /**  `include "../include/apb_uvc_define.sv"
   `include "apb_mas_inf.sv"
   `include "apb_slv_inf.sv"
*/ 
endpackage
   
`endif //APB_UVC_PKG
