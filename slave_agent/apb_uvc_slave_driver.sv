/////////////////////////////////////////////////////////////////////////
// Company        : SCALEDGE 
// Engineer       : Aditya Mishra 
// Create Date    : Wed Sep 27 14:15:03 2023
// Last Modified  : 03-11-2023 10:56:07
// Modified By    : SATYAJEET SAKARIYA
// File Name   	  : apb_uvc_slave_driver.sv
// Class Name 	  : apb_uvc_slave_driver 
// Project Name	  : APB_UVC
// Description	  : This slave driver will response for teh request
//                  genrated by the master.
//////////////////////////////////////////////////////////////////////////

`ifndef APB_UVC_SLAVE_DRIVE_SV
`define APB_UVC_SLAVE_DRIVE_SV 

//-----------------------------------------------------------------------------
//class : apb_uvc_slave_driver 
//-----------------------------------------------------------------------------

class apb_uvc_slave_driver extends uvm_driver #(apb_uvc_slave_seq_item);

  //UVM factory registration.
  //uvm_driver is Component that's why we are using `uvm_component_utils macro.
  `uvm_component_utils(apb_uvc_slave_driver)

  //callback registration - used for error injection
  `uvm_register_cb(apb_uvc_slave_driver,apb_uvc_pready_callback)

  //interface
  virtual apb_slv_inf       apb_s_vif;
          apb_uvc_slave_cfg apb_s_cfg_h;
          REQ               apb_s_trans_h;
  // New constructore description.
  function new (string name="apb_uvc_slave_driver",uvm_component parent=null);
    super.new(name,parent);
  endfunction

//------------------------------------------------------------------------------
// Function : Build phase
//------------------------------------------------------------------------------
  function void build_phase (uvm_phase phase);
    `uvm_info(get_full_name(),"Starting of Build Phase",UVM_LOW)
    super.build_phase(phase);
    if(!uvm_config_db #(apb_uvc_slave_cfg)::get(this,
                                                 "",
                                                 "apb_s_cfg_h",
                                                 apb_s_cfg_h))begin
      `uvm_fatal(get_name(),"configuration fail !!!! .Config not reached to the slave driver")
    end
    apb_s_vif = apb_s_cfg_h.apb_s_vif;
    `uvm_info(get_full_name(),"Ending of Build Phase",UVM_LOW)
  endfunction

//------------------------------------------------------------------------------
// Task : clear
//------------------------------------------------------------------------------ 
  task clear ();
    `uvm_info(get_name(),"Starting of Clear Task",UVM_DEBUG)
    if(!apb_s_vif.rstn) begin
      `uvm_info(get_name(),"[clear task] reset asserted.",UVM_DEBUG)
    // set the slave signal to the known state.
      apb_s_vif.PREADY  <= 0;
      apb_s_vif.PSLVERR <= 0;
      apb_s_vif.PRDATA  <= 0;
    // wait for reste deassert.
      @(posedge apb_s_vif.rstn);
      `uvm_info(get_name(),"[clear task] reset deasserted.",UVM_DEBUG)
    end
    `uvm_info(get_name(),"Ending of Clear Task",UVM_DEBUG)
  endtask

//------------------------------------------------------------------------------
// Task : run_phase
//------------------------------------------------------------------------------
  task run_phase (uvm_phase phase);
    `uvm_info(get_full_name(),"Starting of Run Phase",UVM_LOW)
    clear();
    forever begin
      `uvm_info(get_name(),"Start of forever loop",UVM_DEBUG)
      fork
      //Process 1 : it routs the signal acording to the protocol
        driver();
      //Process 2 : it wait for the reset assertion.
        begin
          @(negedge apb_s_vif.rstn);
        end
      join_any
      disable fork;
      clear();
    end
  endtask

//------------------------------------------------------------------------------
// Task : driver
//------------------------------------------------------------------------------
  task driver ();
    `uvm_info(get_name(),"Start of driving task",UVM_DEBUG)
    forever begin
      `uvm_info(get_name(),"Before get next item call",UVM_DEBUG)
      seq_item_port.get_next_item(req);
     // `uvm_info(get_name(), $sformatf("After get next item call before clone %p" , req),UVM_NONE)

      $cast(apb_s_trans_h,req.clone());
      apb_s_trans_h.set_id_info(req);
    //  `uvm_info(get_name(), $sformatf("After get next item call req %p" , apb_s_trans_h),UVM_NONE)
      if(apb_s_cfg_h.apb_state_e == WAIT_STATE) begin
        repeat(apb_s_cfg_h.delay_cycle)
          @(posedge apb_s_vif.clk);
        void'(std::randomize(apb_s_cfg_h.delay_cycle));
      end
      
      `uvm_do_callbacks(apb_uvc_slave_driver,apb_uvc_pready_callback,pready_control);     //callback for error injection
      apb_s_vif.apb_slv_drv_cb.PREADY  <= 1;
      apb_s_vif.apb_slv_drv_cb.PSLVERR <= apb_s_trans_h.apb_pslverr;
      apb_s_vif.apb_slv_drv_cb.PRDATA  <= apb_s_trans_h.apb_prdata;
      `uvm_info(get_name(),"Before item done call",UVM_DEBUG)
      seq_item_port.item_done();
      `uvm_info(get_name(),"After item done call",UVM_DEBUG)
    end
  endtask : driver


endclass  : apb_uvc_slave_driver

`endif //APB_UVC_SLAVE_DRIVE_SV 

