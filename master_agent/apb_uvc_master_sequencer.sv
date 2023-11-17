/////////////////////////////////////////////////////////////////////////
// Company        : SCALEDGE 
// Engineer       : Aditya Mishra 
// Create Date    : Wed Sep 27 13:54:02 2023
// Last Modified  : Fri Oct 20 01:29:24 2023
// Modified By    : Neel Pambhar
// File Name   	  : apb_mas_seqr.sv
// Class Name 	  : apb_mas_seqr  
// Project Name	  : APB_VIP
// Description	  : 
//////////////////////////////////////////////////////////////////////////

`ifndef APB_UVC_MASTER_SEQUENCER
`define APB_UVC_MASTER_SEQUENCER

//-----------------------------------------------------------------------
//class : apb_uvc_master_sequencer
//-----------------------------------------------------------------------
class  apb_uvc_master_sequencer extends uvm_sequencer #(apb_uvc_master_seq_item); 

//UVM factory registration.
//uvm_sequencer is Component that's why we are using `uvm_component_utils macro.
  `uvm_component_utils(apb_uvc_master_sequencer)

// New constructor declarion.
  function new (string name="apb_uvc_master_sequencer",uvm_component parent=null);
    super.new(name,parent);
  endfunction

endclass

`endif
