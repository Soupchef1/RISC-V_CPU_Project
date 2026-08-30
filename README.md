# RISC-V_CPU_Project

## Introduction
This project began as a foundational implementation of the base RISC-V RV32I instruction set architecture. Once the core 5 stage pipeline and intruction execution developement was complete, the focus shifted heavily toward optimization. To make the CPU functional software program bootloading and video output features where added. The CPU can execute any C program that can be compiled into RV32I assembly using the RISC-V gnu toolchain.

## Key Features
* **Independent 5-Stage Pipelining:** Features Hazard detection and data forwarding. 
* **2-Bit Dynamic Branch Prediction:** Features 7KB BRAM storing branching history.
* **Integrated Cache & DDR3 Memory:** 32KB Intruction and Data Cache (Harvard architecture). 512-line deep BRAM cache structure with automatic miss-correction, seamlessly bridging the processor to the on-board 256MB DDR3 memory.
* **UART Program Bootloading:** Enables dynamic execution by allowing compiled C/Assembly binaries to be loaded directly into memory via serial connection, bypassing the need to re-synthesize the bitstream.
* **HDMI Video Output:** Drives a 720p 60Hz video stream.

<img width="1942" height="890" alt="image" src="https://github.com/user-attachments/assets/ca9a510a-7e92-4d1f-a6cc-be1f6593b166" />

---

## Target Hardware
* **Development Board:** Arty S7-25 FPGA
* **RTL Language:** SystemVerilog
* **Key Peripheral:** DDR3 memory, UART serial, HDMI.

## Verification
Directed Testbenching across major modules to ensure functionality.
UVM verification enviroment to be created in future.

## Getting Started
### Prerequisites
* AMD Vivado (for synthesis and bitstream generation)
* RISC-V GNU Compiler Toolchain (for compiling C/Assembly into bare-metal binaries)

### Running a Program
1. Generate the bitstream and program the Arty S7-25 board via Vivado.
2. Connect the HDMI output to a standard 720p 60Hz capable monitor.
3. Connect the board via micro-USB to your host machine.
4. Run the makefile.
5. Open the bootload.py program in the software folder. Modify port and bin_file_path in the script.
6. Run the bootloader, then press button 0 to start the program.

Notes: This project can be implemented on any FPGA that has OSERDES serializers and the same or more logic resources than the Spartan 7 FPGA, but minor changes have to be made for compatibility.
