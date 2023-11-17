/////////////////////////////////////////////////////////////////////////
// Company        : SCALEDGE 
// Engineer       : Aditya Mishra 
// Create Date    : Wed Sep 27 14:09:42 2023
// Last Modified  : 31-10-2023 12:38:48
// Modified By    : Mohamadadnan Popatpotra
// File Name   	  : apb_uvc_master_pkg.sv
// Package Name 	: apb_uvc_master_pkg 
// Project Name	  : APB_VIP
// Description	  : 
//////////////////////////////////////////////////////////////////////////

`ifndef APB_MAS_PKG_SV
`define APB_MAS_PKG_SV 


package apb_uvc_master_pkg;

  import uvm_pkg::*;
 
  `include "uvm_macros.svh";
  `include "../include/apb_uvc_define.sv"
  
  `include "apb_uvc_master_cfg.sv";
  `include "apb_uvc_data_change_callback.sv";
  `include "apb_uvc_psel_change_callback.sv";
  `include "apb_uvc_penable_change_callback.sv";
  `include "apb_uvc_master_seq_item.sv";
  `include "apb_uvc_master_driver.sv";
  `include "apb_uvc_master_sequencer.sv";
  `include "apb_uvc_master_monitor.sv";
  `include "apb_uvc_master_agent.sv";
 
endpackage

`endif 
