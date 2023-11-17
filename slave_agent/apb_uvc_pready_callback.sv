/////////////////////////////////////////////////////////////////////////
// Company        : SCALEDGE 
// Engineer       : MOHAMADADNAN POPATPOTRA 
// Create Date    : 30-10-2023 14:27:08
// Last Modified  : Wed Nov  1 11:40:12 2023
// Modified By    : Aditya Mishra
// File Name   	  : apb_uvc_pready_callback.sv
// Class Name 	  : 
// Project Name	  : 
// Description	  : 
//////////////////////////////////////////////////////////////////////////

`ifndef APB_UVC_PREADY_CALLBACK_SV
`define APB_UVC_PREADY_CALLBACK_SV

class apb_uvc_pready_callback extends uvm_callback;

    //factory registration
    `uvm_object_utils(apb_uvc_pready_callback)

    //virtual interface
    virtual apb_slv_inf s_inf;

    //for deciding the number of times to call the callback
    integer pready_count=0;

    //constructor new 
    function new(string name="apb_uvc_pready_callback");
        super.new(name);
    endfunction

    virtual task pready_control;
        if(!uvm_config_db#(virtual apb_slv_inf)::get(null,"*","vif_0",s_inf))
            `uvm_fatal("apb_uvc_pready_callback","interface not get");

        if(pready_count < 1) begin
            @(posedge s_inf.clk)
            s_inf.PREADY = 1'b0;
            #120;
            pready_count += 1;
        end          
    endtask

endclass: apb_uvc_pready_callback 

`endif
