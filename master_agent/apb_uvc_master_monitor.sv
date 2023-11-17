//////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Company        : SCALEDGE 
// Engineer       : Satyajeet Sakariya 
// Create Date    : Wed Sep 27 14:05:54 2023
// Last Modified  : 08-11-2023 11:16:49
// Modified By    : SATYAJEET SAKARIYA
// File Name   	  : apb_uvc_master_monitor.sv
// Class Name 	  : apb_uvc_master_monitor
// Project Name	  : APB UVC
// Description	  : this componenet samples value from interface given by slave and sends to the scoreboard
//////////////////////////////////////////////////////////////////////////////////////////////////////////////

`ifndef APB_UVC_MASTER_MONITOR_SV
`define APB_UVC_MASTER_MONITOR_SV

//-----------------------------------------------------------------------------
//class : apb_uvc_master_monitor 
//-----------------------------------------------------------------------------
class apb_uvc_master_monitor extends uvm_monitor;

//UVM factory registration
   `uvm_component_utils(apb_uvc_master_monitor)

//interface
    virtual apb_mas_inf apb_m_vif;
//   uvm_event sync_ev1;

// handle of config Class 
    apb_uvc_master_cfg  apb_m_cfg_h;

//transaction handle to store samples data
    apb_uvc_master_seq_item req;

//analysis port to broadcast transaction
    uvm_analysis_port #(apb_uvc_master_seq_item) mas_mon_ap; 
        
//new constructor description
	  function new(string name="apb_uvc_master_monitor",uvm_component parent);
		    super.new(name,parent);
	  endfunction

//----------------------------------------------------------------------------
//build_phase
//----------------------------------------------------------------------------
	  function void build_phase(uvm_phase phase);
		    super.build_phase(phase);
       `uvm_info(get_full_name(),"Starting of Build Phase",UVM_LOW)

        //apb_m_vif  = apb_m_cfg_h.apb_m_vif;
        mas_mon_ap = new("mas_mon_ap",this);
       
        if(!uvm_config_db #(apb_uvc_master_cfg)::get(this,"","apb_m_cfg_h",apb_m_cfg_h))
          `uvm_fatal(get_name(),"configuration fail !!!! Config not reached to the master monitor")
       
        if(!uvm_config_db #(virtual apb_mas_inf)::get(this,
                                                           "",
                                                           "vif_0",
                                                           apb_m_vif))
               `uvm_fatal("[VIF CONFIG]","cannot get()interface apb_mas_vif from uvm_config_db. Have you set() it?")

       `uvm_info(get_full_name(),"Ending of Build Phase",UVM_LOW)
	  endfunction	

//----------------------------------------------------------------------------
//run phase
//----------------------------------------------------------------------------
    task run_phase(uvm_phase phase);
      //  sync_ev1  = uvm_event_pool::get_global("ev_sync1"); 
    
       `uvm_info(get_full_name(),"Starting of Run Phase",UVM_LOW)
        forever@(apb_m_vif.apb_mas_mon_cb)
        //forever@(posedge apb_m_vif.apb_mas_mon_cb)
        begin
          fork
            begin
              wait(!apb_m_vif.rstn);
               `uvm_info(get_full_name(),"RESET ASSERTED !!!",UVM_LOW)               
              wait( apb_m_vif.rstn);
            end
            begin
              wait(apb_m_vif.rstn);            
              monitor();
              mas_mon_ap.write(req); 
           //   $display("this is paddr is %d | rdata in mas %d ",req.apb_paddr,req.apb_prdata);
              
             // $display("--------------------------------------pkt sent to sb[mas mon]");
              //$display("----------------rdata in mas mon is %d",req.apb_prdata);
            end
          join_any
          disable fork;
        end
       `uvm_info(get_full_name(),"Ending of Run Phase",UVM_LOW)
    endtask

//----------------------------------------------------------------------------
//task for sampling signals
//----------------------------------------------------------------------------
    task monitor();
     //   @(apb_m_vif.apb_mas_mon_cb)
        //creating tx 
        req = apb_uvc_master_seq_item::type_id::create("req");        
        //waiting for psel to assert
        //@(posedge apb_m_vif.apb_mas_mon_cb.PENABLE)
        wait(apb_m_vif.apb_mas_mon_cb.PSEL);
        //@(posedge apb_m_vif.apb_mas_mon_cb.PENABLE);
        //sampling value of PWRITE to decide mode of operation
        begin
            if(apb_m_vif.apb_mas_mon_cb.PWRITE)
            begin
                req.apb_operation_kind_e = WRITE;
                req.apb_pwdata = apb_m_vif.apb_mas_mon_cb.PWDATA; //in case of only write operation we have to compare wdata too.
            end                
            else
                req.apb_operation_kind_e = READ;

            req.apb_paddr      = apb_m_vif.apb_mas_mon_cb.PADDR;

            req.apb_pstrob     = apb_m_vif.apb_mas_mon_cb.PSTROB;
            req.apb_pprot      = apb_m_vif.apb_mas_mon_cb.PPROT;
            
        //wait for Prdy to get valid values of pslverr and prdata BEFRE TIMEOUT          
            begin
            fork
              begin
                repeat(apb_m_cfg_h.timeout)
                    @(apb_m_vif.apb_mas_mon_cb);
                `uvm_error(get_name(),"PREADY not asserted in time !!!!")                 
              end

              begin
                wait(apb_m_vif.apb_mas_mon_cb.PENABLE);
                wait(apb_m_vif.apb_mas_mon_cb.PREADY);  
                  req.apb_pslverr  = apb_m_vif.apb_mas_mon_cb.PSLVERR;
                  //$display("------------------------------------------------------------------------------------------------------------------------this is pslverr = %b",req.apb_pslverr);
                  
                  if(!apb_m_vif.apb_mas_mon_cb.PWRITE)
                    req.apb_prdata = apb_m_vif.apb_mas_mon_cb.PRDATA;
             // $display("this is paddr is %d | rdata in mas %d ",req.apb_paddr,req.apb_prdata);

              end
            join_any
            disable fork;
            end
        end
    endtask
    
endclass
`endif

