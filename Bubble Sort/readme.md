# 🔄 Bubble Sort in Assembly

**GROUP 7 Project** - A complete implementation of the bubble sort algorithm in NASM 64-bit assembly language.

## 🎯 Overview

This program implements the classic bubble sort algorithm to sort an array of integers in ascending order. It demonstrates fundamental assembly programming concepts including loops, conditionals, array manipulation, and system calls.

## ✨ Features

- **Interactive Input**: Prompts user for array size and elements
- **Input Validation**: Ensures array size is between 1-20 elements
- **Bubble Sort Algorithm**: Complete implementation with optimization
- **Before/After Display**: Shows original and sorted arrays
- **Error Handling**: Graceful handling of invalid inputs
- **Professional Output**: Clean, formatted display

## 🚀 Quick Start

### Prerequisites
- Ubuntu 24.02 (or compatible Linux distribution)
- NASM assembler
- GNU linker (ld)
- GDB debugger (optional)

### Installation
```bash
# Clone or extract the project
cd Bubble-Sort/

# Install dependencies if needed
make install-deps

# Build the program
make build

# Run the program
make run
```

## 📋 Usage Examples

### Basic Usage
```bash
$ make run
=== Bubble Sort in Assembly ===
Enter array size (1-20): 5
Enter element 1: 64
Enter element 2: 34
Enter element 3: 25
Enter element 4: 12
Enter element 5: 22

Original array: 64 34 25 12 22
Sorted array: 12 22 25 34 64
```

### Large Array Example
```bash
$ make run
=== Bubble Sort in Assembly ===
Enter array size (1-20): 8
Enter element 1: 5
Enter element 2: 2
Enter element 3: 8
Enter element 4: 1
Enter element 5: 9
Enter element 6: 3
Enter element 7: 7
Enter element 8: 4

Original array: 5 2 8 1 9 3 7 4
Sorted array: 1 2 3 4 5 7 8 9
```

## 🏗️ Project Structure

```
Bubble-Sort/
├── server.asm          # Main assembly source code
├── Makefile           # Build automation
└── README.md          # This documentation
```

## 🔧 Build System

The project uses a comprehensive Makefile with the following targets:

| Target | Description |
|--------|-------------|
| `make build` | Compile and link the program |
| `make run` | Execute the bubble sort program |
| `make debug` | Run with GDB debugger |
| `make clean` | Remove generated files |
| `make help` | Show available commands |

## 🧠 Algorithm Details

### Bubble Sort Implementation
The program implements the classic bubble sort algorithm:

1. **Outer Loop**: Runs n-1 passes through the array
2. **Inner Loop**: Compares adjacent elements
3. **Swapping**: Exchanges elements if they're in wrong order
4. **Optimization**: Each pass reduces the comparison range

### Time Complexity
- **Best Case**: O(n) - when array is already sorted
- **Average Case**: O(n²) - typical performance
- **Worst Case**: O(n²) - when array is reverse sorted

### Space Complexity
- **Space**: O(1) - sorts in-place with constant extra space

## 💾 Technical Specifications

### Assembly Features Used
- **64-bit Registers**: Full x86_64 register set
- **System Calls**: Linux syscalls for I/O operations
- **Memory Management**: Static allocation with bounds checking
- **Function Calls**: Structured subroutines with stack management
- **String Processing**: Custom string-to-integer conversion
- **Array Operations**: Direct memory addressing and manipulation

### Input/Output Handling
- **Input Validation**: Checks for valid array size (1-20)
- **Number Parsing**: Converts ASCII strings to integers
- **Formatted Output**: Professional display with spacing
- **Error Messages**: Clear feedback for invalid inputs

## 🎮 Interactive Features

### User Interface
- Welcome message with program title
- Step-by-step element input prompts
- Clear display of original array
- Formatted display of sorted results
- Error handling with helpful messages

### Input Validation
- Array size must be between 1 and 20
- Elements can be any valid integers
- Graceful handling of invalid inputs
- Clear error messages for out-of-range values

## 🐛 Debugging

### Using GDB
```bash
# Build with debug symbols
make build

# Start debugging session
make debug

# Set breakpoints
(gdb) break bubble_sort
(gdb) break display_array

# Run and analyze
(gdb) run
(gdb) info registers
(gdb) x/10dw array
```

### Common Issues
- **Segmentation Fault**: Check array bounds and memory access
- **Invalid Results**: Verify integer conversion functions
- **Input Errors**: Ensure proper string termination

## 🔍 Code Structure

### Main Functions
- `_start`: Program entry point and main flow
- `get_array_size`: Input validation and size collection
- `get_array_elements`: Element input with prompts
- `bubble_sort`: Core sorting algorithm implementation
- `display_array`: Formatted array output
- `string_to_int`: ASCII to integer conversion
- `int_to_string`: Integer to ASCII conversion

### Memory Layout
- **Text Section**: Program instructions
- **Data Section**: String constants and messages
- **BSS Section**: Uninitialized variables and buffers

## 🎯 Educational Value

This project demonstrates:
- **Algorithm Implementation**: Classic sorting algorithm in assembly
- **Memory Management**: Direct memory access and manipulation
- **I/O Operations**: System calls for user interaction
- **Control Flow**: Nested loops and conditional branching
- **Data Conversion**: String/integer conversion routines
- **Error Handling**: Input validation and error recovery

## 📊 Performance Notes

### Optimization Features
- **Early Termination**: Could be enhanced with swap detection
- **Memory Efficiency**: In-place sorting with minimal overhead
- **Register Usage**: Efficient use of x86_64 registers

### Scalability
- Current limit: 20 elements (easily adjustable)
- Memory usage: ~100 bytes for 20 integers
- Fast execution for small to medium arrays
