/////////////////////////////////////////////////////////////////////////
// Company        : SCALEDGE 
// Engineer       : Aditya Mishra 
// Create Date    : Mon Oct  9 15:30:20 2023
// Last Modified  : Thu Oct 19 07:53:49 2023
// Modified By    : Neel Pambhar
// File Name   	  : apb_uvc_define.sv
// Project Name	  : APB_VIP 
// Description	  : 
//////////////////////////////////////////////////////////////////////////

`ifndef APB_UVC_DEFINE_SV
`define APB_UVC_DEFINE_SV

`define timeout 10
`define APB_ADDR_WIDTH 32
`define APB_DATA_WIDTH 32
`define APB_STROB_WIDTH (`APB_DATA_WIDTH)/8
`define APB_WAKEUP 0

 typedef enum bit {WAIT_STATE , NO_WAIT_STATE } apb_state ;

 // enum for read or write operation 
 // 0 = for read 
 // 1 = for write
 typedef enum bit {READ ,WRITE } apb_operation_kind ;

 // enum for memory initialization. 
 // 0 = all data will be zero
 // 1 = all data will be randomized 
 typedef enum bit {MY_STORAGE_INIT_ZERO,MY_STORAGE_INIT_RAND} mem_init_type_kind ;

`endif //APB_UVC_DEFINE_SV
