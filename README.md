# Assembly Programming Assignment (CAT 2)
## ICS 3203: Assembly Language Programming

### Student Details
- **Name:** Bill Gichuru
- **Registration Number:** 151339
- **Course:** BSc. Computer Science
- **Unit:** ICS 3203 - Assembly Language Programming
- **Semester:** 3.2
- **Academic Year:** 2023/2024

## Project Overview
This repository contains four assembly language programs that demonstrate various aspects of system-level programming using x86_64 assembly on Linux. Each task focuses on different fundamental concepts of assembly programming.

## Tasks Description

### Task 1: String Length Calculator
- **Objective:** Implement a program that calculates string length
- **Features:**
  - Uses null-terminated string
  - Custom string length calculation routine
  - Displays result in ASCII format
- **Key Concepts:**
  - String manipulation
  - Memory addressing
  - Loop implementation
  - Character counting

### Task 2: Number Comparison
- **Objective:** Compare two numbers and display their relationship
- **Features:**
  - Compares two integer values
  - Displays appropriate message based on comparison
  - Handles three cases: greater than, less than, and equal
- **Key Concepts:**
  - Numeric comparison
  - Conditional branching
  - Message output handling

### Task 3: Basic Calculator
- **Objective:** Perform basic arithmetic operations
- **Features:**
  - Adds two numbers
  - Converts numeric result to ASCII
  - Displays formatted output
- **Key Concepts:**
  - Arithmetic operations
  - Number-to-ASCII conversion
  - Result formatting

### Task 4: Water Level Control System
- **Objective:** Implement a water tank monitoring system
- **Features:**
  - Monitors water level through simulated sensor
  - Controls motor and alarm based on thresholds
  - Displays appropriate status messages
- **Key Concepts:**
  - System control logic
  - Threshold-based decisions
  - Status monitoring
  - Bit manipulation

## Technical Requirements

### Development Environment
- Operating System: Linux (Ubuntu/Debian recommended)
- Assembler: NASM (Netwide Assembler)
- Linker: LD (GNU Linker)
- Architecture: x86_64

### Building Instructions
1. Install required tools:
   ```bash
   sudo apt-get update
   sudo apt-get install nasm
   ```

2. Assemble source files:
   ```bash
   nasm -f elf64 task1.asm -o task1.o
   nasm -f elf64 task2.asm -o task2.o
   nasm -f elf64 task3.asm -o task3.o
   nasm -f elf64 task4.asm -o task4.o
   ```

3. Link object files:
   ```bash
   ld task1.o -o task1
   ld task2.o -o task2
   ld task3.o -o task3
   ld task4.o -o task4
   ```

4. Set executable permissions:
   ```bash
   chmod +x task1 task2 task3 task4
   ```

### Execution Instructions
Run each program using:
```bash
./task1
./task2
./task3
./task4
```

## Program Structure

### Memory Sections
- **Data Section:** Contains initialized data
- **BSS Section:** Contains uninitialized data
- **Text Section:** Contains executable code

### System Calls Used
- `sys_write (1)`: For output operations
- `sys_exit (60)`: For program termination

## Testing Procedures

### Task 1 Testing
- Test with different string lengths
- Verify correct length calculation
- Check ASCII output formatting

### Task 2 Testing
- Test with different number combinations
- Verify comparison logic
- Check message accuracy

### Task 3 Testing
- Test with various number pairs
- Verify calculation accuracy
- Check output formatting

### Task 4 Testing
- Test different water levels
- Verify threshold logic
- Check control register settings
- Verify status messages

## Error Handling
- Programs include basic error checking
- Proper exit codes implemented
- Input validation where applicable

## Optimizations
- Efficient register usage
- Minimal memory access
- Optimized loop structures
- Clean code organization

## License
This project is part of academic coursework and is subject to university guidelines and regulations.

