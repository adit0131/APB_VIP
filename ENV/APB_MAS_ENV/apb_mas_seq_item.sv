/////////////////////////////////////////////////////////////////////////
// Company        : SCALEDGE 
// Engineer       : Aditya Mishra 
// Create Date    : Wed Sep 27 13:54:02 2023
// Last Modified  : Tue Oct  3 14:55:19 2023
// Modified By    : Aditya Mishra 
// File Name   	  : apd_mas_seq_item.sv
// Class Name 	  : apb_mas_seq_item  
// Project Name	  : APB_VIP
// Description	  : 
//////////////////////////////////////////////////////////////////////////

`ifndef APB_MAS_SEQ_ITEM_SV
`define APB_MAS_SEQ_ITEM_SV

//-----------------------------------------------------------------------
//class : apb_mas_seq_item
//-----------------------------------------------------------------------

class apb_mas_seq_item extends uvm_sequence_item;  

//***************************************************************************  
//UVM Fectory registretion.
//uvm_sequence_item is object that's why we are using `uvm_object_utils macro.
//***************************************************************************
  `uvm_object_utils(apb_mas_seq_item)

// New Constructor declartion.
  function new (string name="apb_mas_seq_item");
    super.new(name);
  endfunction

endclass

`endif 
