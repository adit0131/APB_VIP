/////////////////////////////////////////////////////////////////////////
// Company        : SCALEDGE 
// Engineer       : Aditya Mishra 
// Create Date    : Wed Sep 27 14:15:03 2023
// Last Modified  : 03-11-2023 10:57:32
// Modified By    : SATYAJEET SAKARIYA
// File Name   	  : apb_uvc_slave_seq_item.sv
// Class Name 	  : apb_uvc_slave_seq_item
// Project Name	  : APV_VIP 
// Description	  : This sequence item has the trantaction packet which 
// need to transfer from monitor to scoreboard and also from driver to 
// interface.
//////////////////////////////////////////////////////////////////////////

`ifndef APB_UVC_SLAVE_SEQ_ITEM_SV
`define APB_UVC_SLAVE_SEQ_ITEM_SV

//------------------------------------------------------------------------
// Class: apb_uvc_slave_seq_item
//------------------------------------------------------------------------
class apb_uvc_slave_seq_item extends uvm_sequence_item;  

//***************************************************************************  
//UVM Fectory registretion.
//uvm_sequence_item is object that's why we are using `uvm_object_utils macro.
//***************************************************************************
  `uvm_object_utils(apb_uvc_slave_seq_item)

// New Constructor declartion.
  function new (string name="apb_uvc_slave_seq_item");
    super.new(name);
  endfunction

        bit [(`APB_ADDR_WIDTH-1):0]   apb_paddr;
        bit [(`APB_DATA_WIDTH-1):0]   apb_pwdata;
  rand  bit [(`APB_DATA_WIDTH-1):0]   apb_prdata;
        bit [(`APB_STROB_WIDTH-1):0]  apb_pstrob;
        bit [2:0]                     apb_pprot;
        apb_operation_kind            apb_operation_kind_e ;
  rand  bit                           apb_pslverr;

//----------------------------------------------------------------------------
// Function : do_print
//----------------------------------------------------------------------------
 virtual function void do_print (uvm_printer printer);
   super.do_print(printer);
   printer.print_int("paddr",apb_paddr,$bits(apb_paddr),UVM_HEX);
   printer.print_int("pwdata",apb_pwdata,$bits(apb_pwdata),UVM_HEX);
   printer.print_int("prdata",apb_prdata,$bits(apb_prdata),UVM_HEX);
   printer.print_int("pstrob",apb_pstrob,$bits(apb_pstrob),UVM_HEX);
   printer.print_int("pprot",apb_pprot,$bits(apb_pprot),UVM_HEX);
 endfunction

//----------------------------------------------------------------------------
// Function : do_copy
//----------------------------------------------------------------------------
  virtual function void do_copy (uvm_object rhs);
    apb_uvc_slave_seq_item rhs_ ;
    if ($cast(rhs_,rhs))  begin 
      this.apb_paddr   = rhs_.apb_paddr ;
      this.apb_pwdata  = rhs_.apb_pwdata ;
      this.apb_prdata  = rhs_.apb_prdata ;
      this.apb_pstrob  = rhs_.apb_pstrob ;
      this.apb_pprot   = rhs_.apb_pprot ;
      this.apb_operation_kind_e = rhs_.apb_operation_kind_e ;
      this.apb_pslverr   = rhs_.apb_pslverr ;
      end
    else
      `uvm_error(get_full_name , "casting faill ")
    super.do_copy(rhs);
  endfunction

//----------------------------------------------------------------------------
// Function : do_compare
//----------------------------------------------------------------------------
  virtual function bit do_compare (uvm_object rhs,uvm_comparer comparer);  
    apb_uvc_slave_seq_item rhs_ ;
    if($cast(rhs_ , rhs )) begin
      return ( (super.do_compare( rhs_ , comparer ) ) && 
               (this.apb_paddr  == rhs_.apb_paddr )   &&
               (this.apb_pwdata == rhs_.apb_pwdata ) &&
               (this.apb_prdata == rhs_.apb_prdata ) &&
               (this.apb_pstrob == rhs_.apb_pstrob ) &&
               (this.apb_pprot  == rhs_.apb_pprot  ) &&
               (this.apb_pstrob == rhs_.apb_pstrob ) &&
               (this.apb_operation_kind_e == rhs_.apb_operation_kind_e )                     
               ) ;
    end
    else 
      `uvm_fatal(get_full_name ,  " casting faill , for compare " )
    do_compare = super.do_compare(rhs,comparer);
  endfunction

endclass

`endif 

