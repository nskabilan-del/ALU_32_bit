# 32-Bit ALU Using Verilog HDL

## Overview

This project implements a **32-bit Arithmetic Logic Unit (ALU)** using Verilog HDL and a modular RTL design approach.

The ALU performs three arithmetic operations:

* **Addition**
* **Subtraction**
* **Multiplication**

The design uses dedicated arithmetic modules and multiplexer modules to create the complete ALU datapath. A randomized testbench is included to verify the design using **20 different input combinations**.

The project is simulated using **ModelSim**.

---

## Project Structure

```text
.
├── add.v              # 32-bit addition module
├── sub.v              # 32-bit subtraction module
├── mul.v              # 32-bit multiplication module
├── mux32one.v         # 2:1 32-bit multiplexer
├── mux32two.v         # 4:1 32-bit result multiplexer
├── alu32.v            # Top-level ALU
├── tb_mux32.v         # ALU testbench
└── README.md
```

---

## Design Specifications

| Parameter  |   Value | Description                  |
| ---------- | ------: | ---------------------------- |
| Data Width | 32 bits | Width of operands and result |
| `a`        | 32 bits | First operand                |
| `b`        | 32 bits | Second operand               |
| `f`        |  2 bits | ALU operation select         |
| `r`        | 32 bits | ALU result                   |
| Test Cases |      20 | Randomized test iterations   |

---

# Architecture

The design is divided into independent functional blocks.

```text
                         +-------------+
                    a -->|             |
                    b -->|     ADD     |----+
                         +-------------+    |
                                            |
                         +-------------+    |
                    a -->|             |    |
                 b / 1 -->|    SUB     |----+----> Result MUX ---> r
                         +-------------+    |
                                            |
                         +-------------+    |
                    a -->|             |    |
                    b -->|     MUL     |----+
                         +-------------+

                              f[1:0]
                                |
                                v
                         Operation Select
```

The arithmetic blocks operate concurrently, and the result multiplexer selects the required output according to `f`.

---

# Module Description

## 1. Addition Module — `add.v`

The `add` module performs 32-bit unsigned addition.

### Interface

| Signal | Direction | Width | Description     |
| ------ | --------- | ----: | --------------- |
| `i0`   | Input     |    32 | First operand   |
| `i1`   | Input     |    32 | Second operand  |
| `sum`  | Output    |    32 | Addition result |

### Logic

```verilog
assign sum = i0 + i1;
```

---

## 2. Subtraction Module — `sub.v`

The `sub` module performs 32-bit subtraction.

### Interface

| Signal | Direction | Width | Description        |
| ------ | --------- | ----: | ------------------ |
| `i0`   | Input     |    32 | First operand      |
| `i1`   | Input     |    32 | Second operand     |
| `diff` | Output    |    32 | Subtraction result |

### Logic

```verilog
assign diff = i0 - i1;
```

---

## 3. Multiplication Module — `mul.v`

The `mul` module performs 32-bit multiplication.

### Interface

| Signal | Direction | Width | Description           |
| ------ | --------- | ----: | --------------------- |
| `i0`   | Input     |    32 | First operand         |
| `i1`   | Input     |    32 | Second operand        |
| `prod` | Output    |    32 | Multiplication result |

### Logic

```verilog
assign prod = i0 * i1;
```

Only the lower 32 bits of the multiplication result are provided at the output.

---

# Multiplexer Modules

## 4. Operand Multiplexer — `mux32one.v`

This module is intended to operate as a 2:1 multiplexer between:

```text
i0 → b
i1 → 32'd1
```

and is controlled by `f[0]`.

### Intended Selection

| `sel` | Output |
| :---: | ------ |
|  `0`  | `i0`   |
|  `1`  | `i1`   |

### Current RTL

The supplied implementation currently contains:

```verilog
assign out = i0;
```

Therefore, **the current implementation always selects `i0`**, regardless of `sel`.

As a result, in the current design:

```text
ain = b
bin = b
```

and the subtraction path performs:

```text
a - b
```

rather than switching between `a - b` and `a - 1`.

> **Note:** If the intended behavior is a true 2:1 multiplexer, the implementation should use the `sel` signal.

---

## 5. Result Multiplexer — `mux32two.v`

This module selects one of the three arithmetic results.

### Inputs

| Input | Connected Signal | Operation      |
| ----- | ---------------- | -------------- |
| `i0`  | `add`            | Addition       |
| `i1`  | `sub`            | Subtraction    |
| `i2`  | `mul`            | Multiplication |

### Selection

| `sel` | Selected Result |
| :---: | --------------- |
|  `00` | Addition        |
|  `01` | Subtraction     |
|  `10` | Multiplication  |
|  `11` | Multiplication  |

The implementation:

```verilog
assign out = ((sel == 2'b00) ? i0 :
              (sel == 2'b01) ? i1 :
              (sel == 2'b10 || sel == 2'b11) ? i2 :
              2'bxx);
```

Therefore:

```text
00 → ADD
01 → SUB
10 → MUL
11 → MUL
```

---

# Top-Level ALU — `alu32.v`

The `alu32` module integrates all arithmetic and multiplexer blocks.

### Interface

| Signal | Direction | Width | Description      |
| ------ | --------- | ----: | ---------------- |
| `a`    | Input     |    32 | First operand    |
| `b`    | Input     |    32 | Second operand   |
| `f`    | Input     |     2 | Operation select |
| `r`    | Output    |    32 | ALU result       |

---

# ALU Operation

Based on the current RTL implementation:

|  `f` | Operation      | Result  |
| :--: | -------------- | ------- |
| `00` | Addition       | `a + b` |
| `01` | Subtraction    | `a - b` |
| `10` | Multiplication | `a × b` |
| `11` | Multiplication | `a × b` |

### Example

For:

```text
a = 20
b = 5
```

The expected results are:

```text
f = 00 → r = 25
f = 01 → r = 15
f = 10 → r = 100
f = 11 → r = 100
```

---

# Testbench

## `tb_mux32.v`

The testbench performs randomized functional testing of the ALU.

For each iteration, random values are generated for:

```verilog
a = $random;
b = $random;
f = $random;
```

The testbench executes:

```verilog
repeat(20)
```

Therefore, **20 randomized test cases** are generated during the simulation.

---

## Simulation Output

The testbench displays the values in hexadecimal format:

```verilog
$display(
    "a=%0h,b=%0h,f=%b,r=%0h",
    a,b,f,r
);
```

Example output format:

```text
a=5A23B100,b=00000020,f=00,r=5A23B120
a=00000100,b=00000010,f=01,r=000000F0
a=00000008,b=00000004,f=10,r=00000020
```

The actual values will vary because the testbench uses `$random`.

---

# Verification Flow

```text
             Start Simulation
                    |
                    v
            Generate Random A
                    |
                    v
            Generate Random B
                    |
                    v
            Generate Random F
                    |
                    v
             Apply to ALU
                    |
                    v
             Wait #1 Time Unit
                    |
                    v
            Display A, B, F, R
                    |
                    v
             Repeat 20 Times
                    |
                    v
              End Simulation
```

---

# Simulation

## ModelSim / QuestaSim

Create the working library:

```tcl
vlib work
```

Compile the testbench:

```tcl
vlog tb_mux32.v
```

The testbench includes the required RTL modules through `alu32.v`.

Start the simulation:

```tcl
vsim tb_mux32
```

Add all signals to the waveform:

```tcl
add wave *
```

Run the simulation:

```tcl
run -all
```

---

# Verification Strategy

The testbench uses **randomized stimulus** rather than manually defined input values.

This provides multiple combinations of:

```text
32-bit operand A
32-bit operand B
2-bit operation select
```

The simulation output can then be compared with the expected arithmetic operation.

---

# Key RTL Concepts Demonstrated

This project demonstrates several important RTL design concepts:

* Hierarchical module design
* Parameterized Verilog modules
* Continuous assignments
* Arithmetic operators
* Multiplexer-based datapath design
* Module instantiation
* Randomized testbench stimulus
* `$display` for simulation debugging
* ModelSim waveform analysis

---

# Features

* 32-bit datapath
* Parameterized data width
* Addition operation
* Subtraction operation
* Multiplication operation
* Modular arithmetic units
* Dedicated result-selection multiplexer
* Randomized verification
* 20 simulation test cases
* ModelSim-compatible design

---

# Applications

This type of ALU design can be used as a foundation for:

* CPU datapaths
* Processor arithmetic units
* Embedded processors
* FPGA-based processor designs
* RTL design practice
* VLSI design projects
* Digital system design
* Verilog verification exercises

---

# Future Enhancements

The design can be extended with additional ALU operations such as:

* AND
* OR
* XOR
* NOT
* Increment
* Decrement
* Shift left
* Shift right
* Comparison
* Carry flag
* Zero flag
* Overflow flag
* Sign flag

The testbench can also be improved by adding a **self-checking reference model**, allowing the simulation to automatically report whether each test case passes or fails.

---

# Tools & Technologies

| Tool / Technology | Purpose               |
| ----------------- | --------------------- |
| Verilog HDL       | RTL Design            |
| ModelSim          | Functional Simulation |
| QuestaSim         | Alternative Simulator |
|gvim               | Code Editor           |

---

# Author

**Kabilan N S**

**Digital Design | RTL Design | Verilog HDL | VLSI Design & Verification**
