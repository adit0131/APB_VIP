/////////////////////////////////////////////////////////////////////////                                                                     2 // Company        : SCALEDGE
// Company        : SCALEDGE
// Engineer       : Aditya Mishra
// Create Date    : Wed Oct 18 15:09:34 2023
// Last Modified  : 03-11-2023 12:14:53
// Modified By    : SATYAJEET SAKARIYA
// File Name      : apb_uvc_my_storage.sv
// Class Name     : apb_uvc_my_storage
// Project Name   : APB_UVC
// Description    :
//////////////////////////////////////////////////////////////////////////

`ifndef APB_UVC_MY_STORAGE_SV
`define APB_UVC_MY_STORAGE_SV

//-----------------------------------------------------------------------
// Class : apb_uvc_my_storage
//-----------------------------------------------------------------------

class apb_uvc_my_storage extends uvm_component;
 
//UVM factory registration.
//uvm_agent is component that's why we are using `uvm_component_utils macro.
  `uvm_component_utils(apb_uvc_my_storage)

// New constructore description.
  function new (string name="apb_uvc_my_storage",uvm_component parent=null);
    super.new(name,parent);
  endfunction

  bit [`APB_DATA_WIDTH-1:0] mem []; 
  apb_uvc_slave_cfg         apb_s_cfg_h;

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
      `uvm_fatal(get_name(),"configuration fail !!!! .Config not reached to the storage class !!!")
    end
    
    mem = new[apb_s_cfg_h.mem_depth]; // to create mem in setted size as per config
    
    `uvm_info(get_full_name(),$sformatf(" memory size created  %d" , mem.size() ),UVM_LOW)
  
    `uvm_info(get_full_name(),"Ending of Build Phase",UVM_LOW)
  endfunction


//-----------------------------------------------------------------------
// Function : write
//-----------------------------------------------------------------------
  function void write ( bit [(`APB_ADDR_WIDTH-1):0] addr,bit [(`APB_DATA_WIDTH-1):0] value);  
   // `uvm_info(get_name(),"my mem wite method start",UVM_LOW)
    mem[addr] = value;
   // `uvm_info(get_name(),$sformatf("memory addr : %h | memory data : %h ",addr,value),UVM_DEBUG)
  endfunction

//-----------------------------------------------------------------------
// Function : read
//-----------------------------------------------------------------------
  function bit [`APB_DATA_WIDTH-1:0] read ( bit [(`APB_ADDR_WIDTH-1):0] addr);  
   // `uvm_info(get_name(),"my mem read method start",UVM_LOW)
   // `uvm_info(get_name(),$sformatf("memory addr : %h | memory data : %h ",addr,mem[addr]),UVM_DEBUG)
    return(mem[addr]);
  endfunction

//-----------------------------------------------------------------------
// Function : init
//-----------------------------------------------------------------------
  function void init ();
    bit [`APB_DATA_WIDTH-1:0] rand_data;
//  $display( "  in case %p" , apb_s_cfg_h );
    case(apb_s_cfg_h.mem_init_type_e)
      MY_STORAGE_INIT_ZERO:begin
        for(int i=0; i < mem.size();i++) begin
          mem[i] = 0;
        end
      end

      MY_STORAGE_INIT_RAND:begin
        for(int i=0; i < mem.size();i++) begin
          void'(std::randomize(rand_data));
          mem[i] = rand_data;
        end
      end
    endcase
  endfunction

endclass  : apb_uvc_my_storage

`endif //APB_UVC_MY_STORAGE_SV

