/////////////////////////////////////////////////////////////////////////
// Company        : SCALEDGE 
// Engineer       : Aditya Mishra 
// Create Date    : Wed Sep 27 14:15:03 2023
// Last Modified  : Wed Oct 25 13:57:10 2023
// Modified By    : Aditya Mishra
// File Name   	  : apb_uvc_slave_sequencer.sv
// Class Name 	  : apb_uvc_slave_sequencer 
// Project Name	  : APB_UVC
// Description	  : 
//////////////////////////////////////////////////////////////////////////

`ifndef APB_UVC_SLAVE_SEQUENCRR_SV
`define APB_UVC_SLAVE_SEQUENCER_SV 

//-----------------------------------------------------------------------
//class : apb_uvc_slave_sequencr
//-----------------------------------------------------------------------
class  apb_uvc_slave_sequencer extends uvm_sequencer #(apb_uvc_slave_seq_item); 

//UVM factory registration.
//uvm_sequencer is Component that's why we are using `uvm_component_utils macro.
  `uvm_component_utils(apb_uvc_slave_sequencer)
  
  uvm_analysis_export#(apb_uvc_slave_seq_item)   apb_s_request_export;
  uvm_tlm_analysis_fifo#(apb_uvc_slave_seq_item) apb_s_request_fifo;
  apb_uvc_my_storage                             apb_s_mem_h;

// New constructor declarion.
  function new (string name="apb_uvc_slave_sequencer",uvm_component parent=null);
    super.new(name,parent);
    apb_s_request_export = new("apb_s_request_export",this);
    apb_s_request_fifo   = new("apb_s_request_fifo",this);
  endfunction

//------------------------------------------------------------------------------
// Function : connect_phase
//------------------------------------------------------------------------------
  function void connect_phase (uvm_phase phase);
    `uvm_info(get_name(),"start of connect phase",UVM_LOW)
    super.connect_phase(phase);
    apb_s_request_export.connect(apb_s_request_fifo.analysis_export);
  endfunction

endclass  : apb_uvc_slave_sequencer

`endif  //APB_UVC_SLAVE_SEQUENCR_SV
