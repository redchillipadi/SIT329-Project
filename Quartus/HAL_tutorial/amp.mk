# Created by the Intel FPGA Monitor Program
# DO NOT MODIFY

############################################
# Global Macros

DEFINE_COMMA			:= ,

############################################
# Compilation Macros

# Programs
AS		:= nios2-elf-as.exe
CC		:= nios2-elf-gcc.exe
LD		:= nios2-elf-ld.exe
OC		:= nios2-elf-objcopy.exe
RM		:= rm -f

# Flags
USERCCFLAGS	:= -g -O1 -ffunction-sections -fverbose-asm -fno-inline -mno-cache-volatile
USERLDFLAGS	:= 
ARCHASFLAGS	:= --gstabs -I "C:/intelFPGA_lite/21.1/nios2eds/components/altera_nios2/sdk/inc/"
ARCHCCFLAGS	:= -mno-hw-mul -mno-hw-div -I "C:/intelFPGA_lite/21.1/nios2eds/components/altera_nios2/HAL/inc/" -DSYSTEM_BUS_WIDTH=32 -DALT_SINGLE_THREADED -D_JTAG_UART_BASE=4280291328u
ARCHLDFLAGS	:=
ARCHLDSCRIPT	:= --script="C:/intelFPGA_lite/21.1/University_Program/Monitor_Program/build/null"
ASFLAGS		:= $(ARCHASFLAGS)
CCFLAGS		:= -Wall -c $(USERCCFLAGS) $(ARCHCCFLAGS)
LDFLAGS		:= $(ARCHLDFLAGS) $(ARCHLDSCRIPT) $(USERLDFLAGS)
OCFLAGS		:= -O srec

# Files
HDRS		:=
SRCS		:= getting_started.c
OBJS		:= $(patsubst %, %.o, $(SRCS))

############################################
# GDB Macros

############################################
# System Macros

# Programs
SYS_PROG_QP_PROGRAMMER	:= quartus_pgm.exe
SYS_PROG_QP_HPS			:= quartus_hps.exe
SYS_PROG_SYSTEM_CONSOLE	:= system-console.exe
SYS_PROG_NII_GDB_SERVER	:= nios2-gdb-server.exe

# Flags
SYS_FLAG_CABLE			:= -c "DE-SoC [USB-1]"
SYS_FLAG_USB			:= "USB-1"
SYS_FLAG_JTAG_INST		:= --instance
SYS_FLAG_NII_HALT		:= --stop

# Files
SYS_FILE_SOF			:= "C:/intelFPGA_lite/21.1/University_Program/Computer_Systems/DE0-Nano-SoC/DE0-Nano-SoC_Computer/verilog/DE0_Nano_SoC_Computer.sof"
SYS_SCRIPT_JTAG_ID		:= --script="C:/intelFPGA_lite/21.1/University_Program/Monitor_Program/bin/jtag_instance_check.tcl"
SYS_FILE_ARM_PL			:= --preloader "C:/intelFPGA_lite/21.1/University_Program/Monitor_Program/arm_tools/u-boot-spl.de0-nano-soc.srec"
SYS_FLAG_ARM_PL_ADDR	:= --preloaderaddr 0xffff14f0

############################################
# Compilation Targets

COMPILE: getting_started.srec

getting_started.srec: getting_started.elf
	$(RM) $@
	$(OC) $(OCFLAGS) $< $@

GENERATE_BSP: BSP/setting.bsp

getting_started.elf: makefile BSP/setting.bsp
	make

BSP/setting.bsp: 
	nios2-bsp HAL BSP "C:/intelFPGA_lite/21.1/University_Program/Computer_Systems/DE0-Nano-SoC/DE0-Nano-SoC_Computer/verilog/Computer_System.sopcinfo" --set hal.enable_c_plus_plus false --set hal.make.bsp_cflags_optimization -O1 --cpu-name Nios2

makefile: 
	nios2-app-generate-makefile.exe --bsp-dir BSP/ --set OBJDUMP_INCLUDE_SOURCE 1 --set APP_CFLAGS_OPTIMIZATION -O1 --elf-name "getting_started.elf" --src-files "getting_started.c"

CLEAN:
ifneq (,$(wildcard ./Makefile))
	make clean_all
endif
	$(RM) makefile
	$(RM) getting_started.elf getting_started.srec
	$(RM) -rf BSP/

############################################
# System Targets

DETECT_DEVICES:
	$(SYS_PROG_QP_PROGRAMMER) $(SYS_FLAG_CABLE) --auto

ARM_RUN_PRELOADER:
	$(SYS_PROG_QP_HPS) $(SYS_FLAG_CABLE) -o GDBSERVER -gdbport0 $(SYS_ARG_GDB_PORT) $(SYS_FILE_ARM_PL) $(SYS_FLAG_ARM_PL_ADDR) 

DOWNLOAD_SYSTEM:
	$(SYS_PROG_QP_PROGRAMMER) $(SYS_FLAG_CABLE) -m jtag -o P\;$(SYS_FILE_SOF)@$(SYS_ARG_JTAG_INDEX) 

CHECK_JTAG_ID:
	$(SYS_PROG_SYSTEM_CONSOLE) $(SYS_SCRIPT_JTAG_ID) $(SYS_FLAG_USB) $(SYS_FILE_SOF) 

HALT_NII:
	$(SYS_PROG_NII_GDB_SERVER) $(SYS_FLAG_CABLE) $(SYS_FLAG_JTAG_INST) $(SYS_ARG_JTAG_INDEX) $(SYS_FLAG_NII_HALT) 

