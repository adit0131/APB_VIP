/////////////////////////////////////////////////////////////////////////
// Company        : SCALEDGE 
// Engineer       : Aditya Mishra 
// Create Date    : Wed Sep 27 14:15:03 2023
// Last Modified  : Thu Nov  9 17:14:25 2023
// Modified By    : Aditya Mishra
// File Name   	  : apb_uvc_slave_cfg.sv
// Class Name 	  : apv_uvc_slave_cfg
// Project Name	  : APB_UVC
// Description	  : This class contains the configuration flags and this will 
// be created inside the slave agent.
//////////////////////////////////////////////////////////////////////////

`ifndef APB_UVC_SLAVE_CFG_SV
`define APB_UVC_SLAVE_CFG_SV

//------------------------------------------------------------------------
// Class : apb_uvc_slave_cfg
//------------------------------------------------------------------------

class apb_uvc_slave_cfg extends uvm_object;

// UVM Factory registration.
// apb_uvc_slave_cfg is a object that's why we using `uvm_object_utils macro.

  `uvm_object_utils(apb_uvc_slave_cfg)

// New constructore declaration.
  function new (string name="apb_uvc_slave_cfg");
    super.new(name);
  endfunction

// is_active :
//     To set agent is Active or Passive.
  uvm_active_passive_enum is_active = UVM_ACTIVE;


//delay_cycle :
//     based on this we can delay our ready signal.
  bit [4:0] delay_cycle = 0;

//has_secure_mem ;
//    if mem is going to have secure locations
  bit has_secure_mem = 0;
  
//secure_mem_range :
//     to set how much of memory will be secure and how much non secure
  int secure_mem_upper_range = 0;
  int secure_mem_lower_range = 16;

//apb_state:
//     based on this we can decide whather it is in wait state or not.
  apb_state  apb_state_e = NO_WAIT_STATE;

//mem_init_type_e :
//     thissconfig to initialize the mem type
  mem_init_type_kind  mem_init_type_e = MY_STORAGE_INIT_ZERO;

//mem_depth : 
//    to set depth of local mem 
 int mem_depth = 1024 ;
 
//virtual interface
  virtual apb_slv_inf apb_s_vif;

//----------------------------------------------------------------------------
// Function : do_print
//----------------------------------------------------------------------------
 virtual function void do_print (uvm_printer printer);
   super.do_print(printer);
   printer.print_string("is_active",is_active.name);
   printer.print_int("delay_cycle",delay_cycle,$bits(delay_cycle),UVM_HEX);
   printer.print_int("has_secure_mem",has_secure_mem,$bits(has_secure_mem),UVM_HEX);
   printer.print_int("secure_mem_lower_range",secure_mem_lower_range,$bits(secure_mem_lower_range),UVM_HEX);
   printer.print_int("secure_mem_upper_range",secure_mem_upper_range,$bits(secure_mem_upper_range),UVM_HEX);
   printer.print_string("apb_state_e",apb_state_e.name);
   printer.print_string("mem_init_type_e",mem_init_type_e.name);
   printer.print_int("mem_depth",mem_depth,$bits(mem_depth),UVM_HEX);
 endfunction

endclass  : apb_uvc_slave_cfg

`endif // APB_UVC_SLAVE_CFG_SV

