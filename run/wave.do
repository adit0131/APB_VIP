onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /apb_tb_top/clk
add wave -noupdate /apb_tb_top/rstn
add wave -noupdate -expand -group Master /apb_tb_top/m_inf/PSEL
add wave -noupdate -expand -group Master /apb_tb_top/m_inf/PENABLE
add wave -noupdate -expand -group Master /apb_tb_top/m_inf/PADDR
add wave -noupdate -expand -group Master /apb_tb_top/m_inf/PWDATA
add wave -noupdate -expand -group Master /apb_tb_top/m_inf/PWRITE
add wave -noupdate -expand -group Master /apb_tb_top/m_inf/PSTROB
add wave -noupdate -expand -group Master /apb_tb_top/m_inf/PPROT
add wave -noupdate -expand -group Master /apb_tb_top/m_inf/PSLVERR
add wave -noupdate -expand -group Master /apb_tb_top/m_inf/PRDATA
add wave -noupdate -expand -group Master /apb_tb_top/m_inf/PREADY
add wave -noupdate -expand -group {Slave } /apb_tb_top/s_inf/PSEL
add wave -noupdate -expand -group {Slave } /apb_tb_top/s_inf/PENABLE
add wave -noupdate -expand -group {Slave } /apb_tb_top/s_inf/PADDR
add wave -noupdate -expand -group {Slave } /apb_tb_top/s_inf/PWDATA
add wave -noupdate -expand -group {Slave } /apb_tb_top/s_inf/PWRITE
add wave -noupdate -expand -group {Slave } /apb_tb_top/s_inf/PSTROB
add wave -noupdate -expand -group {Slave } /apb_tb_top/s_inf/PPROT
add wave -noupdate -expand -group {Slave } /apb_tb_top/s_inf/PSLVERR
add wave -noupdate -expand -group {Slave } /apb_tb_top/s_inf/PRDATA
add wave -noupdate -expand -group {Slave } /apb_tb_top/s_inf/PREADY
add wave -noupdate -expand -group ASSERTION /apb_tb_top/bind_mod/assert__CONTROL_SIGNALS_KNOWN
add wave -noupdate -expand -group ASSERTION /apb_tb_top/bind_mod/assert__PSEL_TO_PENB
add wave -noupdate -expand -group ASSERTION /apb_tb_top/bind_mod/assert__PRDY_TO_PENB
add wave -noupdate -expand -group ASSERTION /apb_tb_top/bind_mod/assert__CLOCK
add wave -noupdate -expand -group ASSERTION /apb_tb_top/bind_mod/assert__PRDY_TIMEOUT
add wave -noupdate -expand -group ASSERTION /apb_tb_top/bind_mod/assert__PSEL_PENB_LOW
add wave -noupdate -expand -group ASSERTION /apb_tb_top/bind_mod/assert__PSTRB_LOW_READ
add wave -noupdate -expand -group ASSERTION /apb_tb_top/bind_mod/assert__RESET_ASSERTED
add wave -noupdate -expand -group ASSERTION /apb_tb_top/bind_mod/assert__PSEL_ACTIVE_SIGNALS_STABLE
add wave -noupdate -expand -group ASSERTION /apb_tb_top/bind_mod/assert__WDATA_KNOWN
add wave -noupdate -expand -group ASSERTION /apb_tb_top/bind_mod/assert__RDATA_KNOWN
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {24 ns} 0} {{Cursor 2} {96 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 281
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {121 ns}
