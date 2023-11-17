/////////////////////////////////////////////////////////////////////////
// Company        : SCALEDGE 
// Engineer       : MOHAMADADNAN POPATPOTRA 
// Create Date    : 31-10-2023 12:34:27
// Last Modified  : 31-10-2023 12:36:23
// Modified By    : Mohamadadnan Popatpotra
// File Name   	  : apb_uvc_psel_change_callback.sv
// Class Name 	  : 
// Project Name	  : 
// Description	  : 
//////////////////////////////////////////////////////////////////////////

`ifndef APB_UVC_PSEL_CHANGE_CALLBACK_SV
`define APB_UVC_PSEL_CHANGE_CALLBACK_SV

class apb_uvc_psel_change_callback extends uvm_callback;

    //factory registration
    `uvm_object_utils(apb_uvc_psel_change_callback)

    //virtual interface
    virtual apb_mas_inf m_inf;

    //flag for controlling the task occurance
    bit psel_flag;

    //constructor new 
    function new(string name="apb_uvc_psel_change_callback");
        super.new(name);
        if(!uvm_config_db#(virtual apb_mas_inf)::get(null,"*","vif_0",m_inf))
            `uvm_fatal("APB_UVC_MAS_DRV_CALLBACK","interface not get");

    endfunction

    
    virtual task psel_change;
        if(psel_flag != 1) begin
            m_inf.PSEL = 1'b0;
            psel_flag = 1;
        end
    endtask

   
endclass: apb_uvc_psel_change_callback

`endif
