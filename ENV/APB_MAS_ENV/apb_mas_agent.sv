/////////////////////////////////////////////////////////////////////////
// Company        : SCALEDGE 
// Engineer       : Aditya Mishra 
// Create Date    : Wed Sep 27 14:06:18 2023
// Last Modified  : Thu Oct  5 13:06:27 2023
// Modified By    : Aditya Mishra 
// File Name   	  : apb_mas_agent.sv
// Class Name 	  : 
// Project Name	  : 
// Description	  : 
//////////////////////////////////////////////////////////////////////////

`ifndef APB_MAS_AGENT_SV
`define APB_MAS_AGENT_SV

//------------------------------------------------------------------------
// Class : apb_mas_agent
//------------------------------------------------------------------------

class apb_mas_agent extends uvm_agent;

//UVM factory registration.
//uvm_agent is component that's why we are using `uvm_component_utils macro.
  `uvm_component_utils(apb_mas_agent)

// New constructore description.
  function new (string name="apb_mas_agent",uvm_component parent=null);
    super.new(name,parent);
  endfunction

endclass


`endif 
