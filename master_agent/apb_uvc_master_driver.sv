//////////////////////////////////////////////////////////////////////////////
// Company        : SCALEDGE 
// Engineer       : Aditya Mishra 
// Create Date    : Wed Sep 27 14:05:22 2023
// Last Modified  : 08-11-2023 11:21:00
// Modified By    : SATYAJEET SAKARIYA
// File Name   	  : apb_uvc_master__driver.sv
// Class Name 	  : apb_uvc_master_driver
// Project Name	  : APB_VIP 
// Description	  : 
///////////////////////////////////////////////////////////////////////////////

`ifndef APB_MAS_DRV_SV
`define APB_MAS_DRV_SV

//-----------------------------------------------------------------------------
//class : apb_uvc_master_driver
//-----------------------------------------------------------------------------

class apb_uvc_master_driver extends uvm_driver #(apb_uvc_master_seq_item);

    //UVM factory registration.
    //uvm_sequencer is Component that's why we are using `uvm_component_utils macro.
    `uvm_component_utils( apb_uvc_master_driver) 

    //callback registration - used for error injection
    `uvm_register_cb(apb_uvc_master_driver,apb_uvc_data_change_callback)
    `uvm_register_cb(apb_uvc_master_driver,apb_uvc_psel_change_callback)
    `uvm_register_cb(apb_uvc_master_driver,apb_uvc_penable_change_callback)

    //interface
    virtual apb_mas_inf apb_m_vif;

    // handle of config Class 
    apb_uvc_master_cfg  apb_m_cfg_h;
    
    // event 
    event is_timeout ;
    
    // uvm event 
    uvm_event get_next_item; 

    // New constructore description.
    function new (string name="apb_uvc_master_driver",uvm_component parent=null);
        super.new(name,parent);
    endfunction

  //------------------------------------------------------------------------------
  // Function : Build phase
  //------------------------------------------------------------------------------
    function void build_phase (uvm_phase phase);
        `uvm_info(get_full_name(),"Starting of Build Phase",UVM_NONE)
        super.build_phase(phase);
       
       if(!uvm_config_db #(apb_uvc_master_cfg)::get(this,"","apb_m_cfg_h",apb_m_cfg_h))
          `uvm_fatal(get_name(),"configuration fail !!!! Config not reached to the master monitor")
 
        if(!uvm_config_db #(virtual apb_mas_inf)::get(this,
                                                           "",
                                                           "vif_0",
                                                           apb_m_vif))
        `uvm_fatal("[VIF CONFIG]","cannot get()interface apb_mas_vif from uvm_config_db. Have you set() it?")

        //$display("qwqwqeqewe %p" , apb_m_cfg_h );
        //apb_m_vif = apb_m_cfg_h.apb_m_vif;
        //$display("qwqwqeqewe %p" , apb_m_vif );
        `uvm_info(get_full_name(),"Ending of Build Phase",UVM_NONE)
        get_next_item = new("get_next_item ");
    endfunction

   //------------------------------------------------------------------------------
   // Task : clear
   //------------------------------------------------------------------------------ 
    task clear ();
        `uvm_info(get_full_name(),"Starting of Clear Task",UVM_DEBUG)
        
         apb_m_vif.PSEL   <= 0 ;
         apb_m_vif.PENABLE<= 0 ;
         apb_m_vif.PADDR  <= 0 ;
         apb_m_vif.PWDATA <= 0 ;
         apb_m_vif.PWRITE <= 0 ;
         apb_m_vif.PSTROB <= 0 ;
         apb_m_vif.PPROT  <= 0 ;

    endtask

    task drive_pkt( );  
      
       apb_m_vif.apb_m_drv_cb.PSEL <= 0 ; 
       seq_item_port.get_next_item(req); 
       
       get_next_item.trigger ;

         if( apb_m_vif.PSEL == 0 ) begin
           @( apb_m_vif.apb_m_drv_cb );   
           apb_m_vif.apb_m_drv_cb.PSEL <= 1 ;
         end
           
           apb_m_vif.apb_m_drv_cb.PSEL   <= 1 ;
           apb_m_vif.apb_m_drv_cb.PADDR  <= req.apb_paddr ;
           if(req.apb_operation_kind_e == WRITE) 
              apb_m_vif.apb_m_drv_cb.PWDATA <= req.apb_pwdata ;

           apb_m_vif.apb_m_drv_cb.PWRITE <= req.apb_operation_kind_e ;
           apb_m_vif.apb_m_drv_cb.PSTROB <= req.apb_pstrob ;
           apb_m_vif.apb_m_drv_cb.PPROT  <= req.apb_pprot ;

           @( apb_m_vif.apb_m_drv_cb );   

           apb_m_vif.apb_m_drv_cb.PENABLE <= 1 ; 
           `uvm_do_callbacks(apb_uvc_master_driver,apb_uvc_data_change_callback,data_change);     //callback for error injection - data
           `uvm_do_callbacks(apb_uvc_master_driver,apb_uvc_psel_change_callback,psel_change);     //callback for error injection - psel
          
          fork :TIME_OUT
             begin
               wait( apb_m_vif.PREADY == 1  );

             end

             begin               
               repeat( apb_m_cfg_h.timeout )
                 @( apb_m_vif.apb_m_drv_cb );
               
               apb_m_vif.apb_m_drv_cb.PENABLE <= 0 ;
               seq_item_port.item_done();
               get_next_item.reset();
               
               -> is_timeout ;
             end           
           join_any 

           disable TIME_OUT ;
           
           if( ! is_timeout.triggered ) begin
             @( apb_m_vif.apb_m_drv_cb) ;
             `uvm_do_callbacks(apb_uvc_master_driver,apb_uvc_penable_change_callback,penable_change);     //callback for error injection - penable
             apb_m_vif.apb_m_drv_cb.PENABLE <= 0 ;

             seq_item_port.item_done();
             get_next_item.reset();
           end                 

    endtask


   task reset_and_suspend();

      apb_m_vif.PSEL   <= 0 ;
      apb_m_vif.PENABLE<= 0 ;
      apb_m_vif.PADDR  <= 0 ;
      apb_m_vif.PWDATA <= 0 ;
      apb_m_vif.PWRITE <= 0 ;
      apb_m_vif.PSTROB <= 0 ;
      apb_m_vif.PPROT  <= 0 ;

   endtask 
   

   task reset_phase (uvm_phase phase );
     phase.raise_objection( this , $sformatf("%s" , get_full_name() ) );
       
       reset_and_suspend();
    
     phase.drop_objection(this , $sformatf("%s" , get_full_name() ) );
   endtask


    //------------------------------------------------------------------------------
    // Task : run_phase
    //------------------------------------------------------------------------------
    task run_phase (uvm_phase phase);
        `uvm_info(get_full_name(),"Starting of Run Phase",UVM_DEBUG)
        super.run_phase(phase);

        //  waiting for reset to assert
        `uvm_info( get_name() , "waiting for reset" , UVM_DEBUG )
        

        wait(apb_m_vif.rstn==0 );

        clear(); 
        // waiting for reset to deassert
        @(posedge apb_m_vif.rstn )
        `uvm_info( get_name() , "reset deasserted and start driving pkt " , UVM_DEBUG )
       
         
        forever begin 
          // in fork join_any two process running
          // one is drive pkt and secound is waiting for reset to assert 
          // if reset is asserted than stop driving things , using disable fork 
          // stop driving on interface 
          // now driving initial values. 
          // now again start driving so we use forever loop 
          fork 
            begin
              // driving pkt pon interface 
              forever
                drive_pkt();
            end
            
            begin
              // waiting for reset to assert 
              @(negedge apb_m_vif.rstn );

              
              clear();
              
              $display("%p" , get_next_item.get_num_waiters() );
              if(get_next_item.is_on()) begin
                seq_item_port.item_done();
                get_next_item.reset();
              end

            end

          join_any
          
          disable fork;
          @(posedge apb_m_vif.rstn );
                   
        end

    endtask :run_phase

endclass

`endif 
