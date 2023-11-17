/////////////////////////////////////////////////////////////////////////
// Company        : SCALEDGE 
// Engineer       : MOHAMADADNAN POPATPOTRA 
// Create Date    : 31-10-2023 10:52:12
// Last Modified  : 31-10-2023 12:39:17
// Modified By    : Mohamadadnan Popatpotra
// File Name   	  : apb_uvc_data_change_callback.sv
// Class Name 	  : 
// Project Name	  : 
// Description	  : 
//////////////////////////////////////////////////////////////////////////

`ifndef APB_UVC_DATA_CHANGE_CALLBACK_SV
`define APB_UVC_DATA_CHANGE_CALLBACK_SV

class apb_uvc_data_change_callback extends uvm_callback;

    //factory registration
    `uvm_object_utils(apb_uvc_data_change_callback)

    //virtual interface
    virtual apb_mas_inf m_inf;

    //flag for controlling the task occurance
    bit data_flag;

    //constructor new 
    function new(string name="apb_uvc_data_change_callback");
        super.new(name);
        if(!uvm_config_db#(virtual apb_mas_inf)::get(null,"*","vif_0",m_inf))
            `uvm_fatal("APB_UVC_MAS_DRV_CALLBACK","interface not get");

    endfunction

    //task for controlling the psel control signal
    virtual task data_change;
        if(data_flag != 1) begin
            //@(posedge m_inf.clk)
            m_inf.PADDR = $urandom_range(100,0);
            m_inf.PWDATA = $urandom_range(200,0);
            data_flag = 1;
        end
    endtask

endclass: apb_uvc_data_change_callback

`endif
