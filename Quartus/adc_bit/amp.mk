# Created by the Intel FPGA Monitor Program
# DO NOT MODIFY

############################################
# Global Macros

DEFINE_COMMA			:= ,

############################################
# Compilation Macros

# Programs
AS		:= nios2-elf-as
CC		:= nios2-elf-gcc
LD		:= nios2-elf-ld
OC		:= nios2-elf-objcopy
RM		:= rm -f

# Flags
USERCCFLAGS	:= -g -O1 -ffunction-sections -fverbose-asm -fno-inline -mno-cache-volatile
USERLDFLAGS	:= 
ARCHASFLAGS	:= --gstabs -I "/home/adrian/intelFPGA_lite/21.1/nios2eds/components/altera_nios2/sdk/inc/"
ARCHCCFLAGS	:= -mno-hw-mul -mno-hw-div -I "/home/adrian/intelFPGA_lite/21.1/nios2eds/components/altera_nios2/HAL/inc/" -DSYSTEM_BUS_WIDTH=32 -DALT_SINGLE_THREADED
ARCHLDFLAGS	:= --defsym nasys_stack_top=0x4000 --defsym nasys_program_mem=0x2000 --defsym nasys_data_mem=0x2000
ARCHLDSCRIPT	:= --script="/home/adrian/intelFPGA_lite/21.1/University_Program/Monitor_Program/build/nios_cpp_build.ld"
ASFLAGS		:= $(ARCHASFLAGS)
CCFLAGS		:= -Wall -c $(USERCCFLAGS) $(ARCHCCFLAGS)
LDFLAGS		:= $(patsubst %, -Wl$(DEFINE_COMMA)%, $(ARCHLDFLAGS)) $(patsubst %, -Wl$(DEFINE_COMMA)%, $(ARCHLDSCRIPT)) $(USERLDFLAGS)
OCFLAGS		:= -O srec

# Files
HDRS		:=
SRCS		:= adc_bit.c
OBJS		:= $(patsubst %, %.o, $(SRCS))

############################################
# GDB Macros

############################################
# System Macros

# Programs
SYS_PROG_QP_PROGRAMMER	:= quartus_pgm
SYS_PROG_QP_HPS			:= quartus_hps
SYS_PROG_SYSTEM_CONSOLE	:= system-console
SYS_PROG_NII_GDB_SERVER	:= nios2-gdb-server

# Flags
SYS_FLAG_CABLE			:= -c "DE-SoC [1-3]"
SYS_FLAG_USB			:= "1-3"
SYS_FLAG_JTAG_INST		:= --instance
SYS_FLAG_NII_HALT		:= --stop

# Files
SYS_FILE_SOF			:= "/home/adrian/Documents/SIT329-Project/Quartus/adc_method1/output_files/adc_method1.sof"
SYS_SCRIPT_JTAG_ID		:= --script="/home/adrian/intelFPGA_lite/21.1/University_Program/Monitor_Program/bin/jtag_instance_check.tcl"
SYS_FILE_ARM_PL			:= --preloader "/home/adrian/intelFPGA_lite/21.1/University_Program/Monitor_Program/arm_tools/u-boot-spl.de10-nano.srec"
SYS_FLAG_ARM_PL_ADDR	:= --preloaderaddr 0xffff14f0

############################################
# Compilation Targets

COMPILE: adc_bit.srec

adc_bit.srec: adc_bit.elf
	$(RM) $@
	$(OC) $(OCFLAGS) $< $@

adc_bit.elf: $(OBJS)
	$(RM) $@
	$(CC) $(OBJS) $(LDFLAGS) -o $@

%.c.o: %.c $(HDRS)
	$(RM) $@
	$(CC) $(CCFLAGS) $< -o $@

%.s.o: %.s $(HDRS)
	$(RM) $@
	$(AS) $(ASFLAGS) $< -o $@

CLEAN: 
	$(RM) adc_bit.srec adc_bit.elf $(OBJS)

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

