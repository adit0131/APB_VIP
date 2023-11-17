/////////////////////////////////////////////////////////////////////////
// Company        : SCALEDGE 
// Engineer       : Aditya Mishra 
// Create Date    : Wed Sep 27 14:15:03 2023
// Last Modified  : Thu Nov  9 18:59:53 2023
// Modified By    : Aditya Mishra
// File Name   	  : apb_uvc_slave_agent.sv
// Class Name 	  : apb_uvc_slave_agent
// Project Name	  : APB_UVC
// Description	  : This slave agent have the drivr , sequencer & monitore
// components which are gointo to be created in this and get connected 
// acording to the configuration.
//////////////////////////////////////////////////////////////////////////

`ifndef APB_UVC_SLAVE_AGENT_SV
`define APB_UVC_SLAVE_AGENT_SV

//------------------------------------------------------------------------
// Class : apb_uvc_slave_agent
//------------------------------------------------------------------------

class apb_uvc_slave_agent extends uvm_agent;

//UVM factory registration.
//uvm_agent is component that's why we are using `uvm_component_utils macro.
  `uvm_component_utils(apb_uvc_slave_agent)


  apb_uvc_my_storage                             apb_s_storage_h;
  apb_uvc_slave_driver                           apb_s_drv_h;
  apb_uvc_slave_monitor                          apb_s_mon_h;
  apb_uvc_slave_sequencer                        apb_s_seqr_h;
  apb_uvc_slave_cfg                              apb_s_cfg_h;
  virtual apb_slv_inf apb_s_vif ;
  
  uvm_analysis_port #(apb_uvc_slave_seq_item)  apb_s_agent_ap;


// New constructore description.
  function new (string name="apb_uvc_slae_agent",uvm_component parent=null);
    super.new(name,parent);
    apb_s_agent_ap = new("apb_s_agent_ap",this);
  endfunction


//------------------------------------------------------------------------
// Function : build_phase
//------------------------------------------------------------------------
  function void build_phase(uvm_phase phase);
    `uvm_info(get_name(),"Start of Build Phase",UVM_NONE)
    super.build_phase(phase);
    if(!uvm_config_db#(apb_uvc_slave_cfg)::get(this,
                                               "",
                                               "apb_s_cfg_h",
                                               apb_s_cfg_h))begin
      `uvm_fatal("[SLAVE_CONFIG]","apb_s_cfg_h did not get. Have you set it ?")
    end
    apb_s_cfg_h.print();
    apb_s_storage_h = apb_uvc_my_storage::type_id::create("apb_s_storage_h",this);
    apb_s_mon_h    = apb_uvc_slave_monitor::type_id::create("apb_s_mon_h",this);
    if(apb_s_cfg_h.is_active == UVM_ACTIVE)begin
      `uvm_info(get_name(),"[UVM Active]",UVM_DEBUG)
      apb_s_drv_h = apb_uvc_slave_driver::type_id::create("apb_s_drv_h",this);
      apb_s_seqr_h= apb_uvc_slave_sequencer::type_id::create("apb_s_seqr_h",this);
    end
    `uvm_info(get_name(),"End of Build Phase",UVM_NONE)
  endfunction

//------------------------------------------------------------------------
// Function : connect_phase
//------------------------------------------------------------------------

  function void connect_phase(uvm_phase phase);
    `uvm_info(get_name(),"Start of connect phase",UVM_NONE)
    super.connect_phase(phase);
     apb_s_mon_h.mem_h = apb_s_storage_h ; 
     apb_s_seqr_h.apb_s_mem_h = apb_s_storage_h;
     if(apb_s_cfg_h.is_active == UVM_ACTIVE)begin
        apb_s_drv_h.seq_item_port.connect(apb_s_seqr_h.seq_item_export);
        apb_s_mon_h.apb_slvmon_sqr.connect(apb_s_seqr_h.apb_s_request_export);
        apb_s_drv_h.apb_s_vif = apb_s_cfg_h.apb_s_vif;
     end
     apb_s_mon_h.apb_s_vif = apb_s_cfg_h.apb_s_vif;
     // monitor to agent connection 
     apb_s_mon_h.apb_slvmon_ap_exp.connect(this.apb_s_agent_ap) ;

    `uvm_info(get_name(),"End of connect phase",UVM_NONE)
  endfunction

endclass  : apb_uvc_slave_agent

`endif //APB_UVC_SLAVE_AGENT_SV 
