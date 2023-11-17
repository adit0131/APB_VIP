/////////////////////////////////////////////////////////////////////////
// Company        : SCALEDGE 
// Engineer       : Mohamadadnan Popatpotra 
// Create Date    : Wed Sep 27 14:06:18 2023
// Last Modified  : Thu Nov  9 18:59:24 2023
// Modified By    : Aditya Mishra
// File Name   	  : apb_uvc_master_agent
// Project Name	  : 
// Description	  : 
//////////////////////////////////////////////////////////////////////////

`ifndef APB_UVC_MASTER_AGENT_SV
`define APB_UVC_MASTER_AGENT_SV

//------------------------------------------------------------------------
// Class : apb_uvc_master_agent
//------------------------------------------------------------------------

class apb_uvc_master_agent extends uvm_agent;

    //factory registration
    `uvm_component_utils(apb_uvc_master_agent)

    //sub components of agent
    apb_uvc_master_cfg       apb_m_cfg_h;
    apb_uvc_master_driver    apb_m_drv_h;
    apb_uvc_master_monitor   apb_m_mon_h;
    apb_uvc_master_sequencer apb_m_seqr_h;

    //interface
    virtual apb_mas_inf apb_m_vif;
    
   function new ( string name = "apb_uvc_master_agent" , uvm_component parent );  
     super.new(name , parent);
   endfunction

    //function build phase
    function void build_phase(uvm_phase phase);
        if(!uvm_config_db#(apb_uvc_master_cfg)::get(this,
                                                   "" ,
                                                   "apb_m_cfg_h",
                                                   apb_m_cfg_h )  ) begin
            `uvm_fatal("[MASTER_CONFIG]","apb_m_cfg_h did not get. Have you set it ?")
        end
        apb_m_cfg_h.print();
        if(apb_m_cfg_h.is_active == UVM_ACTIVE) begin
            apb_m_drv_h = apb_uvc_master_driver::type_id::create("apb_m_drv_h",this);
            apb_m_seqr_h = apb_uvc_master_sequencer::type_id::create("apb_m_seqr_h",this);
            apb_m_drv_h.apb_m_cfg_h = apb_m_cfg_h ;
        end

        apb_m_mon_h = apb_uvc_master_monitor::type_id::create("apb_m_mon_h",this);         
        apb_m_mon_h.apb_m_cfg_h = apb_m_cfg_h ;

    endfunction

    //connect phase
    function void connect_phase(uvm_phase phase);
        

        if(apb_m_cfg_h.is_active == UVM_ACTIVE) 
        begin
            apb_m_drv_h.seq_item_port.connect(apb_m_seqr_h.seq_item_export);
        end
        

    endfunction

endclass
`endif 
