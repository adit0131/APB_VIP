/////////////////////////////////////////////////////////////////////////
// Company        : SCALEDGE 
// Engineer       : Aditya Mishra 
// Create Date    : Wed Sep 27 13:54:02 2023
// Last Modified  : Tue Oct 10 11:42:04 2023
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

  rand bit [(`APB_ADDR_WIDTH-1):0]   apb_paddr;
  rand bit [(`APB_DATA_WIDTH-1):0]   apb_pwdata;
       bit [(`APB_DATA_WIDTH-1):0]   apb_prdata;
  rand bit [(`APB_STROB_WIDTH-1):0]  apb_pstrob;
  rand bit [2:0]                     apb_pprot;

//----------------------------------------------------------------------------
// Function : do_print
//----------------------------------------------------------------------------
 virtual function void do_print (uvm_printer printer);
   super.do_print(printer);

 endfunction

//----------------------------------------------------------------------------
// Function : do_copy
//----------------------------------------------------------------------------
  virtual function void do_copy (uvm_object rhs);
    apb_mas_seq_item rhs_;
    super.do_copy(rhs);
    $cast(rhs_,rhs);

  endfunction

//----------------------------------------------------------------------------
// Function : do_compare
//----------------------------------------------------------------------------
  virtual function void do_compare (uvm_object rsh,uvm_comparer comparer);  
    apb_mas_seq_item rsh_;
    do_compare = super.do_compare(rsh,comparer);
    $cast(rhs_,rhs);

  endfunction

endclass

`endif 
