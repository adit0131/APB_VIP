/////////////////////////////////////////////////////////////////////////
// Company        : SCALEDGE 
// Engineer       : Aditya Mishra 
// Create Date    : Wed Sep 27 13:54:02 2023
// Last Modified  : Tue Oct  3 14:54:47 2023
// Modified By    : Aditya Mishra 
// File Name   	  : apb_mas_seqr.sv
// Class Name 	  : apb_mas_seqr  
// Project Name	  : APB_VIP
// Description	  : 
//////////////////////////////////////////////////////////////////////////

`ifndef APB_MAS_SEQR_SV
`define APB_MAS_SEQR_SV

//-----------------------------------------------------------------------
//class : apb_mas_seqr
//-----------------------------------------------------------------------
class  apb_mas_seqr extends uvm_sequencer #(apb_mas_seq_item); 

//UVM factory registration.
//uvm_sequencer is Component that's why we are using `uvm_component_utils macro.
  `uvm_component_utils(apb_mas_seqr)

// New constructor declarion.
  function new (string name="apb_mas_seqr",uvm_component parent=null);
    super.new(name,parent);
  endfunction

endclass

`endif
