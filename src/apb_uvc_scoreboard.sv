/////////////////////////////////////////////////////////////////////////
// Company        : SCALEDGE 
// Engineer       : Satyajeet Sakariya 
// Create Date    : Wed Oct 25 15:49:18 2023
// Last Modified  : 08-11-2023 11:56:41
// Modified By    : SATYAJEET SAKARIYA
// File Name   	  : apb_scoreboard.sv
// Class Name     : apb_scoreboard
// Project Name	  : APB_VIP
// Description	  : This class does comparision of WDATA and RDATA 
//////////////////////////////////////////////////////////////////////////

//-----------------------------------------------------------------------------
//class : apb_scoreboard 
//-----------------------------------------------------------------------------
class apb_scoreboard extends uvm_scoreboard;

//factory registration
   `uvm_component_utils(apb_scoreboard)

//taking analysis port to get data from master and slave monitor
   `uvm_analysis_imp_decl(_mas_mon_sb)   
   `uvm_analysis_imp_decl(_slv_mon_sb)   
    
    uvm_analysis_imp_mas_mon_sb #(apb_uvc_master_seq_item, apb_scoreboard) item_collect_mas;
    uvm_analysis_imp_slv_mon_sb #(apb_uvc_slave_seq_item,  apb_scoreboard) item_collect_slv;

//taking event to detect reset from slave monitor
    uvm_event reset_ev; 
    
//taking handles of master and tranasction class
    apb_uvc_master_seq_item mas_tx;
    apb_uvc_slave_seq_item  slv_tx;

//master and slave configuration class
    apb_uvc_env_cfg apb_env_cfg_h[];
   int              number_of_uvc;


//taking memory to store data for reference model
    bit [`APB_DATA_WIDTH-1:0] mem [int]; 

// tmp var to store data
    bit[`APB_DATA_WIDTH-1:0] mas_wdata_q[$];
    bit[`APB_DATA_WIDTH-1:0] slv_wdata_q[$];
    bit[`APB_DATA_WIDTH-1:0] mas_rdata_q[$];
    bit[`APB_DATA_WIDTH-1:0] slv_rdata_q[$];


//taking q array to store transaction from both the slave and master  
    apb_uvc_master_seq_item mas_q[$];
    apb_uvc_slave_seq_item  slv_q[$];
    

  function new(string name = "apb_scoreboard", uvm_component parent = null);
    super.new(name, parent);
    item_collect_mas = new("item_collect_mas", this);
    item_collect_slv = new("item_collect_slv", this);

  endfunction


//-----------------------------------------------------------------------------
// BUILD PHASE
//-----------------------------------------------------------------------------  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
      mas_tx     = apb_uvc_master_seq_item::type_id::create("mas_tx");
      slv_tx     =  apb_uvc_slave_seq_item::type_id::create("slv_tx");

      if(!uvm_config_db #(int)::get(this,
                                   "*",
                                   "no_uvc",
                                   number_of_uvc))
      `uvm_fatal("[ENV CONFIG]","cannot get() number of uvc from uvm_config_db. Have you set() it?")
      
      apb_env_cfg_h = new[number_of_uvc];
      reset_ev = new("reset_ev") ;
      foreach(apb_env_cfg_h[i])begin      
      if(!uvm_config_db #(apb_uvc_env_cfg)::get(null,
                                                $sformatf("*.apb_uvc_env_h_%0d",i),
                                                $sformatf("apb_uvc_env_cfg_h"),
                                                apb_env_cfg_h[i]))
        `uvm_fatal("[ENV_CONFIG]","Fail to get env_cfg_h in Scoreboard. Have set it ?")
     end
  endfunction


//method to write in reference memory 
  function void reference_mem_write(apb_uvc_master_seq_item req);
    if(req.apb_paddr > apb_env_cfg_h[1].slave_mem_depth) 
    begin
      req.apb_pslverr = 1'b1;
    end

    if(req.apb_operation_kind_e == READ)
    begin
        if(!mem.exists(req.apb_paddr))
            req.apb_pslverr = 1'b1;
    end  
  
    if(req.apb_pslverr) begin
        `uvm_error(get_type_name,"expected Pslverr in write transaction");
    end
    else begin
        if(req.apb_operation_kind_e == WRITE)
        begin
            mem[req.apb_paddr] = req.apb_pwdata;
        //    $display("this is exp mem  %p",mem);
            mas_wdata_q.push_back(req.apb_pwdata);
        end
    end
  endfunction

//-----------------------------------------------------------------------------
//class : WRITE METHOD FOR MASTER AND SLAVE
//-----------------------------------------------------------------------------
  function void write_mas_mon_sb(apb_uvc_master_seq_item req);
    //$display("this is paddr is %d | rdata in mas %d ",req.apb_paddr,req.apb_prdata);
    mas_q.push_back(req);
    if(req.apb_operation_kind_e == READ && !req.apb_pslverr)
    begin
     // mas_rdata_q.push_back(req.apb_prdata);
    //  $display("this is paddr is %d | rdata q in mas %d ",req.apb_paddr,req.apb_prdata);
      //$display("this is paddr is %d | rdata q in mas %p ",req.apb_paddr,mas_rdata_q);
    end

    if(req.apb_operation_kind_e == WRITE)
    begin
        reference_mem_write(req);
    end
  endfunction


  function void write_slv_mon_sb(apb_uvc_slave_seq_item req);
    slv_q.push_back(req);
    if(req.apb_operation_kind_e == WRITE)
    begin
      slv_wdata_q.push_back(req.apb_pwdata); 
    end

  endfunction


//-----------------------------------------------------------------------------
//class : RUN PHASE
//-----------------------------------------------------------------------------
  task run_phase (uvm_phase phase);
   super.run_phase(phase);
    // reset_ev = uvm_event_pool::get_global("ev_rst");
    forever 
    begin
      fork

        begin
          //reset_ev.wait_trigger;
         `uvm_warning(get_type_name,"RESET detected !!!");          
        end

        begin
          wait(mas_q.size > 0 && slv_q.size > 0);
        
          if(mas_q.size > 0 && slv_q.size > 0) 
          begin
            mas_tx = mas_q.pop_front();
            slv_tx = slv_q.pop_front();
           // $display("this is prdata in sb %d",mas_tx.apb_prdata);
            if(slv_tx.apb_operation_kind_e == WRITE)
            begin
                if(mas_tx.apb_pwdata == slv_tx.apb_pwdata) begin
                    `uvm_info(get_type_name,"WDATA is appropriate      : PASS !!!", UVM_LOW);
                end
                else begin
                    `uvm_error(get_type_name,"WDATA is not appropriate : FAIL !!!");
                end
            end
            
            if(mas_tx.apb_operation_kind_e == READ)
            begin
                if(mas_rdata_q.pop_back == mem[mas_tx.apb_paddr]) begin
                //if(mas_tx.apb_prdata == mem[mas_tx.apb_paddr]) begin
                    `uvm_info(get_type_name,"RDATA is appropriate      : PASS !!!", UVM_LOW);
                end
                else begin
                    `uvm_error(get_type_name,"RDATA is not appropriate : FAIL !!!");
                end
            end 
          end    
        end

      join_any
      disable fork;
    end
  endtask

endclass


