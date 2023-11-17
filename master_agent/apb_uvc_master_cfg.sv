/////////////////////////////////////////////////////////////////////////
// Company        : SCALEDGE 
// Engineer       : Mohamadadnan Popatpotra 
// Create Date    : Wed Sep 27 14:15:03 2023
// Last Modified  : Thu Nov  9 18:56:33 2023
// Modified By    : Aditya Mishra
// File Name   	  : apb_uvc_master_cfg.sv
// Class Name 	  : apv_uvc_master_cfg
// Project Name	  : APB_UVC
// Description	  : This class contains the configuration flags and this will 
// be created inside the master agent.
//////////////////////////////////////////////////////////////////////////

`ifndef APB_UVC_MASTER_CFG_SV
`define APB_UVC_MASTER_CFG_SV

//------------------------------------------------------------------------
// Class apb_uvc_master_cfg
//------------------------------------------------------------------------

class apb_uvc_master_cfg extends uvm_object;

    //enum for controlling the agent type
   uvm_active_passive_enum is_active = UVM_ACTIVE;

    //timeout i.e number of cycles for master to wait before ending transaction
    bit [7:0] timeout = 100;

    //factory registration
    `uvm_object_utils(apb_uvc_master_cfg)
    
    //virtual interface
     virtual apb_mas_inf apb_m_vif;

    //new constructor description
    function new(string name="apb_uvc_master_cfg");
        super.new(name);
    endfunction
    
//----------------------------------------------------------------------------
// Function : do_print
//----------------------------------------------------------------------------
 virtual function void do_print (uvm_printer printer);
   super.do_print(printer);
   printer.print_string("is_active",is_active.name);
   printer.print_int("timeout",timeout,$bits(timeout),UVM_DEC);
 endfunction

endclass

`endif
