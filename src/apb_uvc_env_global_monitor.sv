/////////////////////////////////////////////////////////////////////////
// Company        : SCALEDGE 
// Engineer       : Aditya Mishra 
// Create Date    : Wed Sep 27 14:11:55 2023
// Last Modified  : 07-11-2023 15:07:16
// Modified By    : SATYAJEET SAKARIYA
// File Name   	  : apb_uvc_env_global_monitor.sv
// Class Name 	  : 
// Project Name	  : 
// Description	  : 
//////////////////////////////////////////////////////////////////////////

`ifndef APB_UVC_ENV_GLOBAL_MONITOR_SV
`define APB_UVC_ENV_GLOBAL_MONITOR_SV


covergroup apb_bus_pin_cg with function sample(bit val);

    option.per_instance = 1;

     BIT_TOGGEL_CB : coverpoint val {
        bins txn_cb_01 = (0=>1);
        bins txn_cb_10 = (1=>0);
     }

endgroup

class apb_uvc_env_global_monitor extends uvm_component;

    //factory registration
    `uvm_component_utils(apb_uvc_env_global_monitor)

    //virtual interface
    virtual apb_mas_inf vif;
    
    int max_range_addr = 2^`APB_ADDR_WIDTH ; 
    int max_range_data = 2^`APB_DATA_WIDTH ; 

    //env transaction
    apb_uvc_env_seq_item trans_h;
    
    apb_bus_pin_cg  wdata_cg[];
    apb_bus_pin_cg  addr_cg[];

    int posedge_count;

    //constructor new description


//coverage group 
    covergroup apb_cov with function sample(apb_uvc_env_seq_item trans_h, virtual apb_mas_inf vif);
        
        option.comment = " <<<<<<<<<< APB COVERAGE >>>>>>>>>> ";
        //coverpoint for covering PADDR according to the range, along with PSEL
        PADDR_CP : coverpoint trans_h.apb_paddr iff(vif.rstn){
            option.comment = "ADDR COVERAGE";
            bins addr_low_cb = {1'b1,[0: (max_range_addr/3)]}; 
            bins addr_med_cb = {1'b1,[(max_range_addr/3)+1 : 2*(max_range_addr/3)]};
            bins addr_high_cb = {1'b1,[2*(max_range_addr/3)+1 : max_range_addr ]};
        }
    
        //coverpoint for covering PWDATA according to the range, along with PSEL
        PWDATA_CP : coverpoint trans_h.apb_pwdata iff(vif.rstn){
            option.comment = "PWDATA COVERAGE";
            bins wdata_low_cb = {1'b1,[0:(max_range_data/3)]};
            bins wdata_med_cb = {1'b1,[ ( max_range_data/3 ):2*( max_range_addr/3 )]};
            bins wdata_high_cb = {1'b1,[ 2*(max_range_data/3 ):( max_range_data )]};
        }

        //coverpoint for covering PRDATA according to the range, along with PSEL
        PRDATA_CP : coverpoint trans_h.apb_prdata iff(vif.rstn){
            option.comment = "PRDATA COVERGAGE";
            bins rdata_low_cb = {1'b1,[0:(max_range_data/3)]};
            bins rdata_med_cb = {1'b1,[ ( max_range_data/3 ):2*( max_range_addr/3 )]};
            bins rdata_high_cb = {1'b1,[ 2*(max_range_data/3 ):( max_range_data )]};
        }
/*
        //coverpoint to cover transition of PWRITE signal i.e write=>read & read=>write, along with PSEL
        PWRITE_TRANS_CP : coverpoint {vif.PSEL, vif.PWRITE} iff(vif.rstn){
            option.comment = "PWRITE TRANSITION";
            bins trans_w_w_r = (2'b11 => {1,1} => {1,0});
            bins trans_r_r_w = ({1,0} => {1,0} => {1,1});
        } */

        //coverpoint for covering PWRITE signal 
        PWRITE_CP : coverpoint trans_h.apb_operation_kind_e iff(vif.rstn) {
             bins write = {WRITE};
             bins read  = {READ};
         }

        //coverpoint for covering PESEL signal
        PSEL_CP : coverpoint vif.PSEL iff(vif.rstn);

        //coverpoint for covering PENABLE signal
        PENABLE_CP : coverpoint vif.PENABLE iff(vif.rstn);
        
        //coverpoint for covering PREADY signal
        PREADY_CP : coverpoint vif.PREADY iff(vif.rstn);

        //cross coverage for all the phases for the protocol FSM
        PHASES : coverpoint {vif.PSEL , vif.PENABLE , vif.PREADY} iff(vif.rstn){
            option.comment = "CROSS COVERAGE OF PSEL,PENABLE,PREADY";
            bins hand_shake_cb = {3'b111};
            wildcard bins setup_phase_cb = (3'b000 => 3'b10? );
            wildcard bins access_phase_cb = (3'b10? => 3'b11?);
        }

/*        //cross coverage for back 2 back operation 
        B2B_WR : coverpoint { vif.PSEL , vif.PENABLE , vif.PREADY , vif.PWRITE } iff(vif.rstn){
            option.comment = "B2B COVERAGE";
            bins b2b_w_cb = {4'b1111};
            bins b2b_r_cb = (4'b1111[*2]);
            bins b2b_wr_cb = (4'b1111 =>4'b1110 => 4'b1111 =>4'b1110 );
        }
*/

        //coverpoint for covering PPROT signal
        PPROT_CP : coverpoint trans_h.apb_pprot iff(vif.rstn);

        //coverpoint for covering PPROT signal
        PSTROBE_CP : coverpoint trans_h.apb_pstrob iff(vif.rstn)
        {
            wildcard bins strobe_read[] = {5'b1????};
        }

        //coverpoint for wait and no_wait states
        STATE_CP : coverpoint trans_h.apb_state_e iff(vif.rstn) 
        {
            bins wait_cb = { WAIT_STATE };
            bins no_wait_cb = { NO_WAIT_STATE };
        }

        //normally reset coverpoint
        RESET: coverpoint vif.rstn;

       //coverpoint for covering the reset which is given on the fly to check design working properly or not
        RESET_ON_FLY_CP : coverpoint {vif.rstn , vif.PSEL, vif.PENABLE , vif.PREADY, vif.PWRITE } 
        {
           wildcard bins rest_on_the_fly_write = ( 5'b11101 [*2:6] => 5'b000?0 ) ; 
           wildcard bins reset_on_the_fly_read = ( 5'b11100 [*2:6] => 5'b000?0 ) ;
        }

       /* 
        //coverpoint for covering write and read operation without wait state 
        WRITE_READ_NO_WAIT_CP : cross PWRITE_CP, STATE_CP iff(vif.rstn) {
            bins write_no_wait_state =  binsof(PWRITE_CP.write) && binsof(STATE_CP.no_wait_cb)  ; 
            bins read_no_wait_State =   binsof(PWRITE_CP.read) && binsof(STATE_CP.no_wait_cb) ;  
        }
        


        
        //coverpoint for covering write and read operation with wait state 
        WRITE_READ_WAIT_CP : cross PWRITE_CP, STATE_CP iff(vif.rstn) {
            bins write_wait_state =  binsof(PWRITE_CP.write) && binsof(STATE_CP.wait_cb)  ; 
            bins read_wait_State =   binsof(PWRITE_CP.read) && binsof(STATE_CP.wait_cb) ;  
=======
        //coverpoint for covering write operation without wait state
        WRITE_READ_NO_WAIT_CP : cross PWRITE_CP,STATE_CP iff(vif.rstn)
        {
            bins write_no_wait_state = binsof(PWRITE_CP.write) && binsof(STATE_CP.no_wait_cb)  ; 
            bins read_no_wait_State =  binsof(PWRITE_CP.read) && binsof(STATE_CP.no_wait_cb);  
>>>>>>> 0dcee8eee0102ed629ebe5a62844f252cf47fb66
        }
        */

       
       //coverpoint for covering write operation without wait state
        WRITE_READ_NO_WAIT_CP : coverpoint {vif.PSEL , vif.PENABLE , vif.PREADY , vif.PWRITE} iff(vif.rstn) {
            bins write_no_wait_state = ( 4'b1101 => 4'b1111 ) ; 
            bins read_no_wait_State = ( 4'b1100  =>  4'b1110 );
        }

        
        //coverpoint for covering write operation with wait state
        WRTIE_READ_WAIT_CP : coverpoint {vif.PSEL , vif.PENABLE , vif.PREADY , vif.PWRITE} iff(vif.rstn) 
        {
            bins write_wait_state = ( 4'b1101 [*2:`timeout] => 4'b1111  ); 
            bins read_wait_State  = ( 4'b1100 [*2:`timeout] => 4'b1110  ); 
        } 
        

        //coverpoint for covering PSLVERR during the write,read operation with and without wait state
        SLVERR_W_R_CP : coverpoint {vif.PSEL , vif.PENABLE , vif.PREADY , vif.PSLVERR , vif.PWRITE} 
        {
            bins valid_PSLVERR_write_operation = { 5'b11111  } ;  
            bins read_wait_State = { 5'b11101  };
            bins write_wait_state_no_err = { 5'b11110  };
            bins read_wait_state_no_err = { 5'b11100  };  
        }

        //cross coverage for slave error and PPROT signal together    
        PSLVERRXPPROT : cross SLVERR_W_R_CP, PPROT_CP iff(vif.rstn);

        //cross coverage for slave error and PPROT and write read with wait
        PSLVERRXPPROT_X_WR_WAIT : cross PSLVERRXPPROT, WRTIE_READ_WAIT_CP iff(vif.rstn);

        //cross coverage for slave error and PPROT and write read without wait
        PSLVERRXPPROT_X_WR_NO_WAIT : cross PSLVERRXPPROT, WRITE_READ_NO_WAIT_CP iff(vif.rstn);
        
        //cross coverage for PWRITE, PWDATA, PADDR together occuring 
        WRITE_WDATA_ADDR : cross PWRITE_CP, PWDATA_CP, PADDR_CP iff(vif.rstn) {
            ignore_bins wdata_not_req_for_read_operation  = binsof (PWRITE_CP.read) ;
        }

        //cross coverage for PWRITE, PRDATA, PADDR together occuring 
        READ_RDATA_ADDR : cross PWRITE_CP, PRDATA_CP, PADDR_CP iff(vif.rstn) {
            ignore_bins rdata_not_req_for_write_operation  = binsof(PWRITE_CP.write)  ;
        }
    
        //cross coverage for PPROT AND PSTROBE signal occuring together
        STROBE_X_PPROT : cross PPROT_CP, PSTROBE_CP iff(vif.rstn);

        //cross coverage for PPROT AND PSTROBE AND SLVERR for write read, all three occuring together 
        STROBE_X_PPROT_X_SLVERR : cross PPROT_CP, PSTROBE_CP, SLVERR_W_R_CP iff(vif.rstn);

    endgroup
 

    function new(string name="apb_uvc_env_global_monitor",uvm_component parent=null);
       
        super.new(name,parent);
        $display("in new   ffdf ");
        if(!uvm_config_db #(virtual apb_mas_inf)::get(this,"*","vif_0",vif))
            `uvm_fatal("APB_UVC_ENV_GLOBAL_MONITOR","virtual interface not get")
        apb_cov = new();
        $display("in new   ffdf ");
        wdata_cg = new[`APB_DATA_WIDTH];
        addr_cg  = new[`APB_ADDR_WIDTH];
        $display(" %p sd %p " , wdata_cg.size() , addr_cg.size() );
        $display("%p" , vif);
        foreach(wdata_cg[i])
          wdata_cg[i] = new();
        foreach(addr_cg[i])
          addr_cg[i] = new();

    endfunction

    //build phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        if(!uvm_config_db #(virtual apb_mas_inf)::get(this,"*","vif_0",vif))
            `uvm_fatal("APB_UVC_ENV_GLOBAL_MONITOR","virtual interface not get")

        trans_h = apb_uvc_env_seq_item::type_id::create("trans_h");

    endfunction

  
    
 
    task run_phase (uvm_phase phase);
        forever @(posedge vif.clk) begin
            trans_h = new();
            fork          
            begin
                foreach(vif.PWDATA[i])
                    wdata_cg[i].sample(vif.PWDATA[i]);
                foreach(vif.PADDR[i])
                    addr_cg[i].sample(vif.PADDR[i]);
            end
            begin
                wait(vif.PSEL)
                if(vif.PWRITE)
                begin
                    trans_h.apb_operation_kind_e = WRITE;
                    trans_h.apb_pwdata = vif.PWDATA; //in case of only write operation we have to compare wdata too.
                end                
                else
                    trans_h.apb_operation_kind_e = READ;

                trans_h.apb_paddr      = vif.PADDR;
                trans_h.apb_pstrob     = vif.PSTROB;
                trans_h.apb_pprot      = vif.PPROT;

                @(posedge vif.PENABLE)

                wait(vif.PREADY)

                trans_h.apb_pslverr     = vif.PSLVERR;
                if(!vif.PWRITE)
                    trans_h.apb_prdata = vif.PRDATA;
                
            end

            join
        end
  endtask

    function void extract_phase(uvm_phase phase);
        super.extract_phase(phase);
        $display();
        $display("<<<<<<<<<< COVERAGE >>>>>>>>>>");
        $display("Overall Coverage for apb_cov is %f",apb_cov.get_coverage());
        $display();
    endfunction

endclass  : apb_uvc_env_global_monitor

`endif //APB_UVC_ENV_GLOBAL_MONITOR_SV

