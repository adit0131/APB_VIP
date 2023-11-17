/////////////////////////////////////////////////////////////////////////////
// Company        : SCALEDGE 
// Engineer       : Aditya Mishra 
// Create Date    : Wed Sep 27 14:18:22 2023
// Last Modified  : 30-10-2023 15:27:52
// Modified By    : Mohamadadnan Popatpotra
// File Name   	  : apb_uvc_slave_pkg.sv
// Packeg Name 	  : apb_uvc_slave_pkg
// Project Name	  : APB_UVC
// Description	  : This package contains all of the components, transactions
// and sequences related to the apb_uvc_slave_agent.  Import this package if
// you need to use the mem_agent anywhere.
/////////////////////////////////////////////////////////////////////////////

`ifndef APB_UVC_SLAVE_PKG_SV
`define APB_UVC_SLAVE_PKG_SV

package apb_uvc_slave_pkg;
  
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  `include "../include/apb_uvc_define.sv"

// include the sequence item
  `include "apb_uvc_slave_seq_item.sv"

// include the agent congig object
  `include "apb_uvc_slave_cfg.sv"

//including the callback file
  `include "apb_uvc_pready_callback.sv"

// include the components
  `include "apb_uvc_my_storage.sv"
  `include "apb_uvc_slave_driver.sv"
  `include "apb_uvc_slave_monitor.sv"
  `include "apb_uvc_slave_sequencer.sv"
  `include "apb_uvc_slave_agent.sv"
// include the API sequences
  `include "../seq/SLV_APB_SEQ/apb_uvc_slave_base_seq.sv"

endpackage

`endif // APB_UVC_SLAVE_PKG_SV
