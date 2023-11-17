/////////////////////////////////////////////////////////////////////////
// Company        : SCALEDGE 
// Engineer       : Aditya Mishra 
// Create Date    : Wed Sep 27 14:08:12 2023
// Last Modified  : Thu Nov  9 18:55:04 2023
// Modified By    : Aditya Mishra
// File Name   	  : apb_mas_env_cfg.sv
// Class Name 	  : 
// Project Name	  : 
// Description	  : contains configuration variable for configure environment
//                  like uvc work as master or slave and contain veriable for 
//                  checker and coverage enable or disable.
/////////////////////////////////////////////////////////////////////////  


`ifndef APB_UVC_ENV_CFG_SV
`define APB_UVC_ENC_CFG_SV

typedef enum {HAS_MASTER ,HAS_SLAVE} apb_uvc_agent_kind ;

class apb_uvc_env_cfg extends uvm_object;

  //***************************************************************************  
  //UVM Fectory registretion.
  //uvm_sequence_item is object that's why we are using `uvm_object_utils macro.
  //***************************************************************************
   
  `uvm_object_utils( apb_uvc_env_cfg )
  
   // for enable or disable 
  bit has_coverage = 0 ;
  
  // uvc has master or slave
  // default "HAS_MASTER"
  apb_uvc_agent_kind apb_uvc_agent_kind_e = HAS_MASTER ; 
   
  // environment has checker or not 
  bit has_checker = 1;   
  
  // virtual master uvc interface 
  virtual apb_mas_inf apb_m_vif ;

  // virtual slave uvc interface
  virtual apb_slv_inf apb_s_vif ;

  //  agent is active or passive
  //  default value is "UVM_ACTIVE" 
  uvm_active_passive_enum uvc_agent_active = UVM_ACTIVE;
     
  // master agents config 
  apb_uvc_master_cfg m_cfg;
  
  // slave  agents config 
  apb_uvc_slave_cfg  s_cfg;
  
  int slave_mem_depth = 1024;
  
  bit [6:0] timeout = 100;

  // constractor new  
  function new (string name = "apb_uvc_env_cfg");  
    super.new(name);
  endfunction :new 

//----------------------------------------------------------------------------
// Function : do_print
//----------------------------------------------------------------------------
 virtual function void do_print (uvm_printer printer);
   super.do_print(printer);
   printer.print_string("apb_uvc_agent_kind_e",apb_uvc_agent_kind_e.name);
   printer.print_string("uvc_agent_active",uvc_agent_active.name);
   printer.print_int("has_coverage",has_coverage,$bits(has_coverage),UVM_HEX);
   printer.print_int("has_checker",has_checker,$bits(has_checker),UVM_HEX);
   printer.print_int("timeout",timeout,$bits(timeout),UVM_DEC);
   printer.print_int("slave_mem_depth",slave_mem_depth,$bits(slave_mem_depth),UVM_DEC);
   printer.print_object("apb_uvc_master_cfg",m_cfg);
   printer.print_object("apb_uvc_slave_cfg",s_cfg);
 endfunction

endclass

`endif //APB_UVC_ENV_CFG_SV
