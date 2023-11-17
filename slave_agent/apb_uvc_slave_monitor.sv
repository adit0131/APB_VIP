/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Company        : SCALEDGE 
// Engineer       : SATYAJEET SAKARIYA 
// Create Date    : Wed Sep 27 14:15:03 2023
// Last Modified  : 08-11-2023 11:02:20
// Modified By    : SATYAJEET SAKARIYA
// File Name   	  : apb_uvc_slave_monitor.sv
// Class Name 	  : apb_uvc_slave_monitor
// Project Name	  : APB UVC
// Description	  : this componenet samples value from interface given by slave and sends to the scoreboard
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

`ifndef APB_UVC_SLAVE_MONITOR_SV
`define APB_UVC_SLAVE_MONITOR_SV

//-----------------------------------------------------------------------------
//class : apb_uvc_slave_monitor 
//-----------------------------------------------------------------------------
class apb_uvc_slave_monitor extends uvm_monitor;

//factory registration   
   `uvm_component_utils(apb_uvc_slave_monitor)

//transaction to store sampled values
    apb_uvc_slave_seq_item req;

//virtual interface
    virtual apb_slv_inf apb_s_vif;

//event sync scoreboard and second event to tell scoreboard that reset is asserted
   uvm_event reset_ev;
 //  uvm_event sync_ev;
    
// config object get info about depth of mem
    apb_uvc_slave_cfg apb_s_cfg_h;

//analysis port to broadcast tx and one to send tx to sqr
    uvm_analysis_port  #(apb_uvc_slave_seq_item) apb_slvmon_ap_exp;
    uvm_analysis_port  #(apb_uvc_slave_seq_item) apb_slvmon_sqr;

//instance class of mem 
    apb_uvc_my_storage mem_h;

// taking associative array to keep track of written addrs
    int addr_list [int];

//new method
    function new(string name = "apb_uvc_slave_monitor", uvm_component parent );
        super.new(name,parent);
    endfunction

//-----------------------------------------------------------------------------
// build phase
//-----------------------------------------------------------------------------
    function void build_phase(uvm_phase phase);
       `uvm_info(get_full_name(),"Starting of Build Phase",UVM_LOW)
        
        apb_slvmon_ap_exp = new("apb_slvmon_ap_exp",this);
        apb_slvmon_sqr    = new("apb_slvmon_sqr",this);
        
        if(!uvm_config_db #(apb_uvc_slave_cfg)::get(this,"","apb_s_cfg_h",apb_s_cfg_h))
          `uvm_fatal(get_name(),"configuration fail !!!! Config not reached to the slave monitor")
        reset_ev = new("reset_ev");
       // apb_s_vif = apb_s_cfg_h.apb_s_vif ;
    endfunction

//-----------------------------------------------------------------------------
// task to calculate pslverr
//-----------------------------------------------------------------------------
    task pslverr(apb_uvc_slave_seq_item req);
       
       if(req.apb_paddr > apb_s_cfg_h.mem_depth)
        req.apb_pslverr = 1'b1;

/*
       if(req.apb_operation_kind_e == READ)
       begin
        if(!addr_list.exists(req.apb_paddr))
          req.apb_pslverr = 1'b1;       
       end
*/         

       if(req.apb_operation_kind_e == READ)
       begin
        if(req.apb_pstrob != 0)
          req.apb_pslverr = 1'b1;
       end


       if(apb_s_cfg_h.has_secure_mem)
       begin
         if(req.apb_pprot[1])
         begin
           if(req.apb_paddr inside {[apb_s_cfg_h.secure_mem_lower_range:apb_s_cfg_h.secure_mem_upper_range]})
              req.apb_pslverr = 1'b1;
         end
       end
    endtask

//-----------------------------------------------------------------------------
//run phase
//-----------------------------------------------------------------------------
    task run_phase(uvm_phase phase);
     //   reset_ev = uvm_event_pool::get_global("ev_rst"); 
   //     sync_ev  = uvm_event_pool::get_global("ev_sync"); 
    
        forever@(apb_s_vif.apb_slv_mon_cb)
   //     sync_ev.trigger();
        begin
          fork
         
            begin
                wait(!apb_s_vif.rstn);
                 // calling reset API to initialize mem        
                    mem_h.init();
                    addr_list.delete();
               //     reset_ev.trigger();
                wait( apb_s_vif.rstn);
            end

            begin
                wait(apb_s_vif.rstn);
                    monitor();
                    apb_slvmon_ap_exp.write(req);           
                    apb_slvmon_sqr.write(req);           
            end
          join_any
          disable fork;
        end
       `uvm_info(get_full_name(),"Ending of Run Phase",UVM_LOW)        
    endtask

//-----------------------------------------------------------------------------
//task for sampling signals
//-----------------------------------------------------------------------------
    task monitor();
       @(posedge apb_s_vif.apb_slv_mon_cb.PENABLE);
        // creating tx
        req = apb_uvc_slave_seq_item::type_id::create("req");
        // assigning mode of operation to the enum
        begin

            if(apb_s_vif.apb_slv_mon_cb.PWRITE)
                req.apb_operation_kind_e = WRITE;
            else
                req.apb_operation_kind_e = READ;

           // $display("this is mode : %s",req.apb_operation_kind_e.name);
        //sampling values in tx
            req.apb_paddr      = apb_s_vif.apb_slv_mon_cb.PADDR;
            req.apb_pstrob     = apb_s_vif.apb_slv_mon_cb.PSTROB;
            req.apb_pprot      = apb_s_vif.apb_slv_mon_cb.PPROT;
            req.apb_pwdata     = apb_s_vif.apb_slv_mon_cb.PWDATA;
        //sampling pwdata acording to pstrob
/*            if(req.apb_operation_kind_e == WRITE)
            begin
            //  $display($time, "write  112233   %p" , req );
              for(int i = 0; i< `APB_STROB_WIDTH; i++)
              begin
                if(req.apb_pstrob[i])
                  req.apb_pwdata[8*i +:8] = apb_s_vif.apb_slv_mon_cb.PWDATA[8*i +:8];
              end
            end
*/
        //calculating pslverr if there is
            pslverr(req);
        //    $display("------------------------------------------------------------------------------------------------------------------------this is pslverr = %b",req.apb_pslverr);
            
        // calling APIs of mem
            if(req.apb_operation_kind_e == READ)
             begin
                if(!req.apb_pslverr)                
                  req.apb_prdata = mem_h.read(req.apb_paddr);
                  $display("********************** addr %d |  rdata from mem is %d ",req.apb_paddr,req.apb_prdata);
             end
            if(req.apb_operation_kind_e == WRITE)
             begin
                if(!req.apb_pslverr) 
                begin
                  mem_h.write(req.apb_paddr,req.apb_pwdata);
                  addr_list[req.apb_paddr] = 1;
                end
             end
        end
    endtask
endclass
`endif

