# FPGA-based-SPI-Master-Slave
# SPI Master Controller - FPGA Implementation

**Institute Of Technology, Nirma University**  
**Department of Electronics and Communication Engineering**  
**Course: 2EC202 - FPGA-based System Design**  
**Student ID: 22BEC030 [Semester-IV]**

A Verilog implementation of SPI (Serial Peripheral Interface) Master controller designed and verified on FPGA using Intel Quartus II and ModelSim simulation.

## 📋 Abstract

SPI (Serial Peripheral Interface) is a commonly accepted 4-wire standard configuration for synchronous serial communication used primarily for short-distance wired communication between a microcontroller and peripheral ICs. This project focuses on the implementation of an SPI Master using the simplest configuration of SPI which is a single master, single slave system, on a Field-Programmable Gate Array (FPGA).

The communication protocol establishes a master-slave relationship where the master is the controlling device, and the slave (sensor, display, or memory chip) takes instruction from the master. SPI uses four wires for communication: **MOSI**, **MISO**, **SCLK**, and **SS/CS**.

**Keywords:** SPI Master, MISO, MOSI, Slave select, Full-duplex serial, FPGA

## 🎯 Project Overview

This academic project demonstrates the implementation of SPI Master functionality with the following characteristics:

- **Configuration**: Single Master, Single Slave
- **Data Width**: 8-bit parallel input/output
- **Communication**: Full-duplex synchronous serial
- **Platform**: FPGA (Field-Programmable Gate Array)
- **Tools**: Intel Quartus II, ModelSim-Altera

## 📚 Literature Survey

SPI is a full-duplex synchronous serial communication protocol, allowing data to be simultaneously transmitted in both directions. Originally developed by **Motorola in the mid-1980s** for inter-chip communication.

### Key Research Findings:

- **Evolution**: SPI has evolved from single integrated circuit communication to support various microcontrollers, sensors, displays, and memory devices
- **Applications**: Widely used in flash memory, sensors, real-time clocks, analog-to-digital converters, SD card readers, RFID modules, and 2.4 GHz wireless transceivers
- **Protocol Modes**: Four SPI modes (0, 1, 2, 3) with different clock polarity and phase configurations
- **Performance Research**: Various clocking schemes explored to enhance data rates, minimize latency, and reduce power consumption
- **Verification**: Functional verification achievable through simulation using EDA tools

### SPI Signal Lines:

| Signal | Full Name | Direction | Description |
|--------|-----------|-----------|-------------|
| **MOSI** | Master Output/Slave Input | Master → Slave | Data transmission line |
| **MISO** | Master Input/Slave Output | Slave → Master | Data reception line |
| **SCLK** | Serial Clock | Master → Slave | Clock signal for synchronization |
| **SS/CS** | Slave Select/Chip Select | Master → Slave | Slave selection (active low) |

## 🏗️ Module Architecture

### Port Configuration

```verilog
module SPI_master (
    input sclk,                    // Serial clock from master
    input [7:0] data_in,          // Data to be transmitted from master
    output reg [7:0] data_out,    // Output for data received from slave
    input miso,                   // Master In Slave Out
    output reg ss,                // Slave select (active low)
    input ss_initiate,            // Transmission initiation signal
    output reg mosi               // Master Out Slave In
);
```

### Internal Registers
- **Counter `i`**: Tracks MOSI bit transmission (0-7)
- **Counter `j`**: Tracks MISO bit reception (0-7)
- **State Control**: Manages transmission phases

## ⚡ Methodology & Algorithm

### Operational Flow Algorithm:

1. **Initialize** i and j registers to 0
2. **Initialize** ss signal to 1 (deselect slave)
3. **On rising edge** of sclk, check conditions:
   - `ss_initiate == 1`
   - `i < 8` 
   - `j < 8`
4. **If conditions met:**
   - Select slave: `ss = 0`
   - Shift data: `mosi = data_in[i]`
   - Capture data: `data_out[j] = miso`
   - Increment counters: `i++, j++`
5. **If conditions not met:**
   - Deselect slave: `ss = 1`
   - Set high impedance: `mosi = Z, data_out = Z`
6. **Repeat** until transmission complete (8 bits)

### State Machine Behavior

```
IDLE → TRANSMISSION → COMPLETE → IDLE
  ↑                               ↓
  ← ← ← ← ← ← ← ← ← ← ← ← ← ← ← ← ←
```

## 🛠️ Development Environment

### Required Tools:
- **Intel Quartus II** (Version 13.0 or later)
- **ModelSim-Altera Edition** (Included with Quartus II)
- **FPGA Development Board** (For hardware implementation)

### Project Setup:

**1. Quartus II Project Creation:**
```
File → New Project Wizard
- Project Directory: Select appropriate location
- Add SPI_master.v as design file
- Select target FPGA device family
- Compile: Processing → Start Compilation
```

**2. Simulation Setup:**
```
Tools → Run Simulation Tool → RTL Simulation
- ModelSim launches automatically
- Design loads into simulator workspace
- Ready for manual input testing
```

## 🧪 Testing & Verification

### Manual Testing Approach

This project was verified using **ModelSim manual input methodology** rather than automated testbenches, providing hands-on control over signal timing and behavior observation.

### ModelSim Testing Procedure:

**1. Signal Monitoring Setup:**
```tcl
# Add all signals to waveform window
add wave -noupdate /SPI_master/sclk
add wave -noupdate /SPI_master/ss_initiate
add wave -noupdate /SPI_master/ss
add wave -noupdate -radix hexadecimal /SPI_master/data_in
add wave -noupdate -radix hexadecimal /SPI_master/data_out
add wave -noupdate /SPI_master/mosi
add wave -noupdate /SPI_master/miso
add wave -noupdate -radix unsigned /SPI_master/i
add wave -noupdate -radix unsigned /SPI_master/j
```

**2. Manual Input Test Sequences:**

**Basic Transmission Test:**
```tcl
# Generate clock signal
force sclk 0 0ns, 1 10ns -repeat 20ns

# Set test data
force data_in 8'hAA 0ns
force miso 0 0ns
force ss_initiate 0 0ns

# Initiate transmission
force ss_initiate 1 40ns
run 200ns

# Observe results in waveform
```

**Slave Response Test:**
```tcl
# Simulate slave data transmission
force miso 1 50ns, 0 70ns, 1 90ns, 0 110ns, 1 130ns, 0 150ns, 1 170ns, 0 190ns
force ss_initiate 1 40ns
run 300ns

# Verify full-duplex operation
examine data_out
```

### Verification Results

**✅ Verified Behaviors:**
- SS signal properly toggles (active low during transmission)
- MOSI shifts out data_in bits sequentially (MSB first)
- MISO data captured correctly in data_out
- 8-bit transmission completes in exactly 8 clock cycles
- High impedance state set after transmission completion

## 📊 Results Analysis

### RTL Schematic
The synthesized RTL shows the register-based implementation with:
- 8-bit counters for bit tracking
- State control logic for transmission phases
- Tri-state buffers for high impedance outputs

### Technology Mapping
TTL analysis demonstrates efficient resource utilization:
- Minimal logic elements required
- Register-based design for reliable operation
- Clock domain properly managed

### Waveform Analysis
Simulation waveforms confirm:
- Proper SPI timing relationships
- Clock-synchronous data transfer
- Correct slave select assertion/deassertion
- Full-duplex operation verification

**🎥 Working Demonstration:** [View Implementation Video](https://youtube.com/shorts/LuTS7woPn2Q?si=KWzcBWHQfiMoqcQA)

## ⚠️ Limitations & Analysis

### Protocol Limitations:

1. **Wire Count**: Requires 4 wires vs. 2 for I²C/UART
2. **No Acknowledgment**: Lacks data reception confirmation
3. **No Error Checking**: Missing built-in error detection (unlike UART parity)
4. **Single Master**: Only supports one master device
5. **Distance**: Limited to short-distance communication
6. **No Security**: Lacks data security features

### Implementation Limitations:

- Fixed 8-bit data width
- Single slave support only
- No built-in error recovery
- Basic SPI Mode 0 operation

## 🚀 Future Enhancements

### Potential Improvements:
- [ ] **Multi-slave support** with individual SS lines
- [ ] **Configurable data width** (16-bit, 32-bit)
- [ ] **SPI mode selection** (CPOL/CPHA configuration)
- [ ] **Error detection mechanisms** (CRC, parity)
- [ ] **FIFO buffers** for continuous operation
- [ ] **Interrupt-driven operation**
- [ ] **Multi-master arbitration**

## 📁 Project Structure

```
spi-master-fpga/
├── src/
│   └── SPI_master.v          # Main Verilog module
├── quartus/
│   ├── SPI_master.qpf        # Quartus project file
│   ├── SPI_master.qsf        # Quartus settings
│   └── output_files/         # Compilation results
├── simulation/
│   └── modelsim/            # ModelSim simulation files
├── docs/
│   ├── FPGA_Report.pdf      # Complete project report
│   ├── waveforms/           # Captured waveforms
│   └── schematics/          # RTL diagrams
├── README.md
└── requirements.txt
```

## 📋 Dependencies

**Development Tools:**
```txt
# Intel FPGA Development Suite
quartus-ii>=13.0              # Intel Quartus II
modelsim-altera               # ModelSim-Altera (included)

# Optional Tools
gtkwave>=3.3                  # Waveform viewer (alternative)
python>=3.7                   # For automation scripts
tcl>=8.5                      # ModelSim scripting
```

**Target Hardware:**
- Intel/Altera FPGA development board
- Logic analyzer (for hardware verification)
- Oscilloscope (for timing analysis)

## 📖 References

1. [Circuit Basics - SPI Communication Protocol](https://www.circuitbasics.com/basics-of-the-spi-communication-protocol/)
2. [IJARSCT - SPI Implementation Research](https://ijarsct.co.in/Paper14295.pdf)
3. Motorola SPI Block Guide, 1985
4. IEEE Standards for Digital Interface
5. Intel Quartus II Handbook
6. ModelSim User Guide

## 🎓 Academic Context

This project was developed as part of the **FPGA-based System Design** course (2EC202) in the Department of Electronics and Communication Engineering at **Institute of Technology, Nirma University**. 

The implementation demonstrates practical understanding of:
- Digital communication protocols
- FPGA design methodology  
- Hardware description languages (Verilog)
- Simulation and verification techniques
- Academic research and documentation

## 📄 License

This project is developed for educational purposes as part of university coursework. Feel free to use for learning and reference.

## 📞 Contact

**Student:** 22BEC030  
**Institution:** Nirma University  
**Department:** Electronics and Communication Engineering  
**Course:** FPGA-based System Design (2EC202)

For technical questions about this implementation, please refer to the complete project report or reach out through academic channels.

---

**Note:** This implementation serves as an educational demonstration of SPI protocol concepts and FPGA design methodology. The project successfully demonstrates core SPI functionality with room for enhancement in production applications.
