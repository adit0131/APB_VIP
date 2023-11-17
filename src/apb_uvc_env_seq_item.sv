/////////////////////////////////////////////////////////////////////////
// Company        : SCALEDGE 
// Engineer       : MOHAMADADNAN POPATPOTRA 
// Create Date    : 03-11-2023 14:18:30
// Last Modified  : 07-11-2023 15:07:42
// Modified By    : SATYAJEET SAKARIYA
// File Name   	  : apb_uvc_env_seq_item.sv
// Class Name 	  : 
// Project Name	  : 
// Description	  : 
//////////////////////////////////////////////////////////////////////////

`ifndef APB_UVC_ENV_SEQ_ITEM_SV
`define APB_UVC_ENV_SEQ_ITEM_SV

    //`include "../include/apb_uvc_define.sv"

//-----------------------------------------------------------------------
//class : apb_uvc_env_seq_item
//-----------------------------------------------------------------------

 //typedef enum bit {WAIT_STATE , NO_WAIT_STATE } apb_state ;
 //typedef enum bit {READ ,WRITE } apb_operation_kind ;

class apb_uvc_env_seq_item extends uvm_sequence_item;  
  
    //factory registration
    `uvm_object_utils(apb_uvc_env_seq_item)

    
    // New Constructor declartion.
    function new (string name="apb_uvc_env_seq_item");
        super.new(name);
    endfunction
  
  
    bit [(`APB_ADDR_WIDTH-1):0]   apb_paddr;
    bit [(`APB_DATA_WIDTH-1):0]   apb_pwdata;
    bit [(`APB_DATA_WIDTH-1):0]   apb_prdata;
    bit [(`APB_STROB_WIDTH-1):0]  apb_pstrob;
    bit [2:0]                     apb_pprot;
    apb_state                     apb_state_e ;
    apb_operation_kind            apb_operation_kind_e ;
    bit                           apb_pslverr;

    constraint c1{soft apb_paddr > 0; apb_paddr <32;};

  
//----------------------------------------------------------------------------
// Function : do_print
//----------------------------------------------------------------------------
 virtual function void do_print (uvm_printer printer);
   super.do_print(printer);

   //printer.uvm_print_field_enum
   printer.print_int("apb_paddr"  , apb_paddr  , $bits(apb_paddr)  , UVM_HEX);
   printer.print_int("apb_pwdata" , apb_pwdata , $bits(apb_pwdata) , UVM_HEX);
   printer.print_int("apb_prdata" , apb_prdata , $bits(apb_prdata) , UVM_HEX);
   printer.print_int("apb_pstrob" , apb_pstrob , $bits(apb_pstrob) , UVM_HEX);
   printer.print_int("apb_pprot"  , apb_pprot  , $bits(apb_pprot)  , UVM_HEX);

 endfunction :do_print


//----------------------------------------------------------------------------
// Function : do_copy
//----------------------------------------------------------------------------
  virtual function void do_copy (uvm_object rhs);
    apb_uvc_master_seq_item rhs_;
    super.do_copy(rhs);
    if ($cast(rhs_,rhs))  begin 
   
      this.apb_paddr   = rhs_.apb_paddr ;
      this.apb_pwdata  = rhs_.apb_pwdata ;
      this.apb_prdata  = rhs_.apb_prdata ;
      this.apb_pstrob  = rhs_.apb_pstrob ;
      this.apb_pprot   = rhs_.apb_pprot ;
      $cast(this.apb_state_e,rhs_.apb_state_e) ;
      $cast(this.apb_operation_kind_e,rhs_.apb_operation_kind_e) ; end
    else
      `uvm_error(get_full_name , "casting faill ")


  endfunction :do_copy


//----------------------------------------------------------------------------
// Function : do_compare
//----------------------------------------------------------------------------
  virtual function bit do_compare (uvm_object rhs,uvm_comparer comparer);  
    apb_uvc_master_seq_item rsh_;
    
    if($cast(rsh_ , rhs )) begin
      return ( (super.do_compare( rsh_ , comparer ) ) && 
               (this.apb_paddr  == rsh_.apb_paddr )   &&
               (this.apb_pwdata == rsh_.apb_pwdata ) &&
               (this.apb_prdata == rsh_.apb_prdata ) &&
               (this.apb_pstrob == rsh_.apb_pstrob ) &&
               (this.apb_pprot  == rsh_.apb_pprot  ) &&
               (this.apb_pstrob == rsh_.apb_pstrob ) &&
               (this.apb_state_e == rsh_.apb_state_e ) &&
               (this.apb_operation_kind_e == rsh_.apb_operation_kind_e )                     
               ) ;
    end
    else 
      `uvm_fatal(get_full_name ,  " casting faill , for compare " )

    do_compare = super.do_compare(rhs,comparer);

  endfunction :do_compare

endclass: apb_uvc_env_seq_item

`endif 
