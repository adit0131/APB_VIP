/////////////////////////////////////////////////////////////////////////
// Company        : SCALEDGE 
// Engineer       : Aditya Mishra 
// Create Date    : Wed Sep 27 13:54:02 2023
// Last Modified  : Tue Oct  3 15:05:56 2023
// Modified By    : Aditya Mishra 
// File Name   	  : apb_mas_base_seq.sv
// Class Name 	  : apb_mas_base_seq 
// Project Name	  : APB_VIP
// Description	  : 
//////////////////////////////////////////////////////////////////////////

`ifndef APB_MAS_BASE_SEQ_SV
`define APB_MAS_BASE_SEQ_SV

//-----------------------------------------------------------------------
//class : apb_mas_base_seq
//-----------------------------------------------------------------------
class  apb_mas_base_seq extends uvm_sequence #(apb_mas_seq_item); 

//UVM factory registration.
//uvm_sequence is object that's why we are using `uvm_object_utils macro.
  `uvm_object_utils(apb_mas_base_seq)

// New constructor declarion.
  function new (string name="apb_mas_base_seq");
    super.new(name);
  endfunction

endclass

`endif 
