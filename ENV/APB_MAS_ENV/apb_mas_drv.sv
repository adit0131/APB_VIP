//////////////////////////////////////////////////////////////////////////////
// Company        : SCALEDGE 
// Engineer       : Aditya Mishra 
// Create Date    : Wed Sep 27 14:05:22 2023
// Last Modified  : Tue Oct  3 15:23:31 2023
// Modified By    : Aditya Mishra 
// File Name   	  : apb_mas_drv.sv
// Class Name 	  : apb_mas_drv  
// Project Name	  : APB_VIP 
// Description	  : 
///////////////////////////////////////////////////////////////////////////////

`ifndef APB_MAS_DRV_SV
`define APB_MAS_DRV_SV

//-----------------------------------------------------------------------------
//class : apb_mas_drv
//-----------------------------------------------------------------------------
class apb_mas_drv extends uvm_driver #(apb_mas_seq_item);

//UVM factory registration.
//uvm_sequencer is Component that's why we are using `uvm_component_utils macro.
  `uvm_component_utils(apb_mas_drv)

// New constructore description.
  function new (string name="apb_mas_drv",uvm_component parent=null);
    super.new(name,parent);
  endfunction

//------------------------------------------------------------------------------
// Function : Build phase
//------------------------------------------------------------------------------
  function void build_phase (uvm_phase phase);
    `uvm_info(get_full_name(),"Starting of Build Phase",UVM_LOW)
    super.build_phase(phase);
    if(!uvm_config_db #(apb_mas_agent_cfg)::get(this,
                                                "",
                                                "apb_master_agent_config",
                                                m_agent_cfg))
      `uvm_fatal("[MASTER_CONFIG]","m_agent_cfg can not get in master driver class");
    `uvm_info(get_full_name(),"Ending of Build Phase",UVM_LOW)
  endfunction

//------------------------------------------------------------------------------
// Task : clear
//------------------------------------------------------------------------------ 
  task clear ();
    `uvm_info(get_full_name(),"Starting of Clear Task",UVM_DEBUG)
  endtask

//------------------------------------------------------------------------------
// Task : run_phase
//------------------------------------------------------------------------------
  task run_phase (uvm_phase phase);
    `uvm_info(get_full_name(),"Starting of Run Phase",UVM_LOW)
    super.run_phase(phase);

  endtask

endclass
`endif 
