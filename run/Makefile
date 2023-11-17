#Makefile
export SHELL = /bin/csh -f

ifndef USE_SIMULATOR
  ifeq ($(filter help rm,$(MAKECMDGOALS)),)
    $(error 'USE_SIMULATOR=<simulator>' argument must be provided)
  endif
endif


mode                 = svlog
control              = svlog
simulator            = $(USE_SIMULATOR)-$(mode)

ifndef DESIGNWARE_HOME
  $(error DESIGNWARE_HOME is not defined)
endif

design_dir           = ${DESIGNWARE_HOME}/design_dir
include_dir          = ${design_dir}/include
src_dir              = ${design_dir}/src

ASSERTION 					:=../tb/apb_assertions.sv 

TOP                 := ../tb/apb_tb_top.sv	

PKG                 := ../master_agent/apb_uvc_master_pkg.sv ../slave_agent/apb_uvc_slave_pkg.sv ../env/apb_uvc_env_top_pkg.sv ../seq/apb_uvc_seq_pkg.sv ../test/apb_uvc_test_pkg.sv ../tb/apb_uvc_pkg.sv

INCLUDE             := +incdir+../src +incdir+../seq +incdir+../master_agent +incdir+../seq/MAS_APB_SEQ +incdir+../slave_agent +incdir+../seq/SLV_APB_SEQ +incdir+../test +incdir+../tb +incdir+../env  +incdir+../include 

VIP	                := +incdir+${src_dir}/sverilog/mti +incdir+${include_dir}/sverilog +incdir+${src_dir}/verilog/mti +incdir+${include_dir}/verilog  
vcs_incdir_options = +incdir+${src_dir}/sverilog/vcs +incdir+${include_dir}/sverilog +incdir+${src_dir}/verilog/vcs +incdir+${include_dir}/verilog  
mti_incdir_options = +incdir+${src_dir}/sverilog/mti +incdir+${include_dir}/sverilog +incdir+${src_dir}/verilog/mti +incdir+${include_dir}/verilog  

# Top module name change everytime
TOP_M 	            := apb_tb_top 
ifdef UVM_HOME
  uvm_home_dir = $(UVM_HOME)
else
  ifeq ($(findstring vcs,${simulator}),vcs)
    ifdef VCS_HOME
      uvm_home_dir = $(VCS_HOME)/etc/uvm
    endif
  endif
  ifeq ($(findstring mti,${simulator}),mti)
    ifdef MTI_HOME
      mti_latest_uvm_ver = $(shell /bin/egrep 'mtiUvm +=' $(MTI_HOME)/modelsim.ini | /bin/sed -e 's,^.*/,,g')
      uvm_home_dir = $(MTI_HOME)/verilog_src/${mti_latest_uvm_ver}
    endif
  endif
endif

os_uname = $(strip $(shell /bin/uname -s))
mach_uname = $(strip $(shell /bin/uname -m))

ifeq ($(os_uname),Linux)

  bitarch            = $(shell /bin/uname -i)
  ld                 = cc
  elf                =
  ncverilog_flags    =
  ncvlog_flags       =
  ncvhdl_flags       =
  ifdef FORCE_32BIT
    bitarch = _32
  endif
  ifeq ($(findstring _64,$(bitarch)),_64)
    ifeq ($(findstring SuSE-release,$(shell /bin/sh -c '/bin/ls /etc/SuSE-release 2> /dev/null')),SuSE-release)
      platform       = suse64
    else
      platform       = amd64
    endif
    vmm_platform     = linux_x86_64
    uvm_platform     = 64bit
    novas_platform   = LINUX64
    vcsflags         =
    vcs_bitmode      = -full64
    ncverilog_flags  = +nc64bit
    ncvlog_flags     = -64BIT
    ncvhdl_flags     = -64BIT
    ccflags          = 
    ccflags_dyn      = -fPIC
    ldflags_dyn      = -shared
    mti_tool_path    = linux_x86_64
    export MTI_VCO_MODE = 64
  else
    ifeq ($(findstring SuSE-release,$(shell /bin/sh -c '/bin/ls /etc/SuSE-release 2> /dev/null')),SuSE-release)
      platform       = suse32
    else
      platform       = linux
    endif
    vmm_platform     = linux
    uvm_platform     =
    novas_platform   = LINUX
    vcsflags         =
    vcs_bitmode      =
    ccflags          = -m32
    ccflags_dyn      = -m32 -fPIC
    ldflags_dyn      = -m32 -shared
    mti_tool_path    = "bin"
    export MTI_VCO_MODE = 32
  endif
  vcslibs            =
  mtilibs            = -lc
  vuser_entry        =
  cpplibs            = -lm
  dyn_ext            = so
  dyn_path_var       = LD_LIBRARY_PATH
else
  $(error Unsupported platform)
endif

nobuild = 0
ifdef NOBUILD
  ifeq ($(findstring output/csrc,$(shell /bin/sh -c '/bin/ls -d output/csrc 2> /dev/null')),output/csrc)
    nobuild = 1
  endif
endif

buildonly = 0
ifdef BUILDONLY
  buildonly = 1
endif

norun = 0
ifdef NORUN
  norun = 1
endif

incdir = 0
ifdef INCDIR
  incdir = 1
endif

cencrypt = 0
ifdef CENCRYPT
  cencrypt = 1
endif

noclean = 0
ifdef NOCLEAN
  noclean = 1
endif

ifndef VERBOSE
  vcs_quiet = -q
else
  cds_quiet = -parseinfo include
endif

ifdef DEBUG_OPTS
  sim_run_debug = +svt_debug_opts
  export SLI_DEBUG_SERVER = file
endif

ifdef AUX_VCSFLAGS
  aux_vcsflags       = $(AUX_VCSFLAGS)
else
  aux_vcsflags       =
endif

ifdef AUX_MTIFLAGS
  aux_mtiflags       = $(AUX_MTIFLAGS)
else
  aux_mtiflags       =
endif

ifndef TEST
	TEST := apb_uvc_sanity_test
endif
	
ifndef VERBOSITY
	VERBOSITY := UVM_LOW
endif

ifdef SEED
  vcs_run_seed = +ntb_random_seed=$(SEED)
  mti_run_seed = -sv_seed $(SEED)
endif

ifdef TRACE 
	mti_trace := +UVM_CONFIG_DB_TRACE
else
	mti_trace :=
endif



lib_dir          = ${design_dir}/lib/${platform}

dw_vip_path         = vip/svt/amba_svt/R-2020.12

# For Wave Form Creation In Verdi
pa = 0
ifdef PA
  override PA = fsdb
  ifeq ($(PA),fsdb)
    pa = fsdb
    ifdef NOVAS_HOME
      ifndef VERDI_HOME
        VERDI_HOME = $(NOVAS_HOME)
      endif
    endif
    ifndef VERDI_HOME
      $(error The PA FSDB option requires the VERDI_HOME environment variable to be properly set)
    endif
    sim_run_debug += +svt_enable_pa=fsdb
    vcs_pa_options = +plusarg_save -debug_access+pp+dmptf+thread -debug_region=cell+encrypt -notice
    vcs_pa_options += -P ${VERDI_HOME}/share/PLI/VCS/${novas_platform}/novas.tab ${VERDI_HOME}/share/PLI/VCS/${novas_platform}/pli.a
    vcs_pa_defines = '+define+SVT_FSDB_ENABLE +define+WAVES_FSDB +define+WAVES=\"fsdb\"'
  else
    pa = 1
    sim_run_debug += +svt_enable_pa
    vcs_pa_options =
    vcs_pa_defines =
  endif
else
  vcs_pa_options =
  vcs_pa_defines =
endif
ifdef WAVES
  ifeq ($(WAVES),1)
    override WAVES = dve
  endif
  vcs_waves_options  = +plusarg_save -debug_access+pp+dmptf+thread -debug_region=cell+encrypt -notice
  mti_waves_defines  =
  mti_waves_options  =
  ifeq ($(WAVES),fsdb)
    ifdef NOVAS_HOME
      ifndef VERDI_HOME
        VERDI_HOME = $(NOVAS_HOME)
      endif
    endif
    ifndef VERDI_HOME
      $(error The WAVES FSDB option requires the VERDI_HOME environment variable to be properly set)
    endif
    vcs_waves_defines = '+define+SVT_FSDB_ENABLE +define+WAVES_FSDB +define+WAVES=\"fsdb\"'
    vcs_waves_options += -P ${VERDI_HOME}/share/PLI/VCS/${novas_platform}/novas.tab ${VERDI_HOME}/share/PLI/VCS/${novas_platform}/pli.a
    mti_waves_defines = +define+SVT_FSDB_ENABLE +define+WAVES_FSDB +define+WAVES=fsdb
    mti_waves_options += -pli ${VERDI_HOME}/share/PLI/MODELSIM/${novas_platform}/novas_fli.so
    vcs_waves_cmd =
  else
  ifeq ($(WAVES),verdi)
    ifdef NOVAS_HOME
      ifndef VERDI_HOME
        VERDI_HOME = $(NOVAS_HOME)
      endif
    endif
    ifndef VERDI_HOME
      $(error The FSDB option requires the VERDI_HOME environment variable to be properly set)
    endif
    vcs_waves_defines = '+define+WAVES_FSDB +define+WAVES=\"fsdb\"'
    vcs_waves_options += -P ${VERDI_HOME}/share/PLI/VCS/${novas_platform}/novas.tab ${VERDI_HOME}/share/PLI/VCS/${novas_platform}/pli.a
    vcs_waves_cmd = ; nWave -ssf test_top.fsdb
  else
  ifeq ($(WAVES),dve)
    vcs_waves_defines  = '+define+WAVES_DVE +define+WAVES=\"dve\"'
    vcs_waves_cmd = -assert dumpoff +vpdfile+vcdplus.vcd -vcd vcdplus.vcd; touch vpdplus.vpd vcdplus.vcd; cp vpdplus.vpd wavesdump; if ( -z wavesdump ) cp vcdplus.vcd wavesdump; rm -f verilog.dump; ln -s wavesdump verilog.dump; dve ${vcs_bitmode}
    ifeq ($(findstring waves.tcl,$(shell /bin/sh -c '/bin/ls ${tbench_dir}/waves.tcl 2> /dev/null')),waves.tcl)
      ifeq ($(findstring verilog.dump,$(shell /bin/grep '\-file verilog.dump' ${tbench_dir}/waves.tcl)),verilog.dump)
        vcs_waves_cmd += -session ${tbench_dir}/waves.tcl
      else
        vcs_waves_cmd += -session ${tbench_dir}/waves.tcl -vpd verilog.dump
      endif
    else
      vcs_waves_cmd += -vpd verilog.dump
    endif
  else
    vcs_waves_defines  = '+define+WAVES_VCD +define+WAVES=\"dve\"'
    vcs_waves_cmd = -assert dumpoff +vpdfile+vpdplus.vpd -vcd vcdplus.vcd
  endif
  endif
  endif
else
  vcs_waves_defines  =
  vcs_waves_options  =
  ncv_waves_defines  =
  ncv_waves_options  =
  mti_waves_defines  =
  mti_waves_options  =
  vcs_waves_cmd      =
endif

all	:
	make rm lib comp sim

rm	:
	rm -rf work log/*.log .nfs* log/.nfs*

runcov :
	lib comp_cov regression html

lib :
	vlib work

# for compiling and view output on command prompt

comp :
	vlog  -coveropt 3 +acc +cover $(PKG) $(ASSERTION) $(TOP) $(INCLUDE) $(mti_incdir_options) -l ./log/compile.log +define+SVT_UVM_TECHNOLOGY +define+QUESTA +define+MODELTECH +define+SYNOPSYS_SV

vcscomp	:
	vcs -l ./log/compile.log $(PKG) $(ASSERTION) $(TOP) $(INCLUDE) ${vcs_incdir_options} ${vcs_waves_defines} ${vcs_pa_defines} ${vcs_waves_options} ${vcs_pa_options} ${vcs_lca_option} +define+SVT_UVM_TECHNOLOGY +define+SYNOPSYS_SV ${vcslibs} +incdir+${UVM_HOME}/src; \

qsim :
	vsim -vopt -assertdebug $(TOP_M) -l ./log/$(TEST)_log.log -permit_unmatched_virtual_intf ${mti_run_seed} -c -sv_lib ${DESIGNWARE_HOME}/vip/common/latest/C/lib/${platform}/VipCommonNtb -sv_lib uvm_dpi +UVM_TESTNAME=$(TEST) +UVM_VERBOSITY=$(VERBOSITY) ${mti_trace} 

sim :
	vsim -vopt -assertdebug $(TOP_M) -l log/$(TEST)_log.log -permit_unmatched_virtual_intf ${mti_run_seed} -c -do "run -all; exit" -sv_lib ${DESIGNWARE_HOME}/vip/common/latest/C/lib/${platform}/VipCommonNtb -sv_lib uvm_dpi +UVM_TESTNAME=$(TEST) +UVM_VERBOSITY=$(VERBOSITY) ${mti_trace} 

help : 
	@echo "Usage: make comp [ sim | qsim ] [TRACE=1] [SEED=<value>] [TEST=<scenario>] [VERBOSITY= <UVM_VERBOSITY>....]"
	@echo "       sim is valid for on terminal simulation"
	@echo "       qsim is valid for on questasim simulation"
	@echo "       Valid UVM_VERBOSITY are: UVM_NONE UVM_LOW UVM_MEDIEM UVM_HIGH UVM_DEBUGE"
	@echo "       Valid scenarios are:  apb_uvc_sanity_test apb_uvc_write_read_test apb_uvc_random_test"


