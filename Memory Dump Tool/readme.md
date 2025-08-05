# Memory Dump Tool

A comprehensive memory analysis tool that displays memory contents in both hexadecimal and ASCII formats, implemented in NASM x86_64 assembly language for Linux systems.

## 🚀 Features

- **Dual Format Display**: Shows memory in both hex and ASCII side-by-side
- **Flexible Range**: Dump 1-256 bytes of memory
- **Address Input**: Accepts hexadecimal memory addresses
- **Safe Access**: Built-in sample data for safe testing
- **Formatted Output**: Professional hex dump format similar to `hexdump -C`
- **Input Validation**: Comprehensive error checking for addresses and sizes

## 🔍 How Memory Dumps Work

Memory dumps reveal the raw binary content of memory locations:
- **Hexadecimal View**: Shows exact byte values in base-16
- **ASCII View**: Displays printable characters, dots for non-printable
- **Address Column**: Shows the memory address for each line
- **16-byte Lines**: Standard format showing 16 bytes per line

## 📋 Requirements

- **Operating System**: Ubuntu 24.02 or compatible Linux distribution
- **Assembler**: NASM (Netwide Assembler)
- **Linker**: GNU ld (part of binutils)
- **Architecture**: x86_64

## 🛠️ Installation

### Install Dependencies

```bash
sudo apt update
sudo apt install nasm build-essential
```

### Build the Program

```bash
make build
```

## 🎯 Usage

### Interactive Mode

```bash
make run
```

### Direct Execution

```bash
./memory_dump
```

### Example Session

```
Memory Dump Tool
================
Sample data available at address: 0000000000402000

Enter memory address (hex, e.g., 400000): 402000
Enter number of bytes to dump (1-256): 64

Address   Hex Dump                         ASCII
--------  -------------------------------  ----------------
00402000  48 65 6C 6C 6F 2C 20 57 6F 72 6C 64 21 20 54 68  | Hello, World! Th
00402010  69 73 20 69 73 20 73 61 6D 70 6C 65 20 64 61 74  | is is sample dat
00402020  61 20 66 6F 72 20 6D 65 6D 6F 72 79 20 64 75 6D  | a for memory dum
00402030  70 20 64 65 6D 6F 6E 73 74 72 61 74 69 6F 6E 2E  | p demonstration.
```

## 📊 Output Format

### Memory Dump Layout

```
Address   Hex Dump                         ASCII
--------  -------------------------------  ----------------
XXXXXXXX  XX XX XX XX XX XX XX XX XX XX XX  | CCCCCCCCCCCCCCCC
```

Where:
- **Address**: 8-digit hexadecimal memory address
- **Hex Dump**: Up to 16 bytes in hexadecimal format
- **ASCII**: Printable characters or dots for non-printable bytes

### Example Outputs

| Data Type | Hex View | ASCII View |
|-----------|----------|------------|
| Text | `48 65 6C 6C 6F` | `Hello` |
| Numbers | `31 32 33 34 35` | `12345` |
| Binary | `00 01 02 03 04` | `.....` |
| Mixed | `41 0A 42 43 00` | `A.BC.` |

## 🧪 Testing

### Run Basic Test

```bash
make test
```

### Run Demo Mode

```bash
make demo
```

### Advanced Testing

```bash
make test-advanced
```

### Security Testing

```bash
make security-test
```

### Manual Testing Examples

```bash
# Test with sample data (address shown by program)
./memory_dump
# Enter the sample data address and try different sizes

# Test different dump sizes
# 16 bytes - single line
# 64 bytes - multiple lines  
# 256 bytes - maximum size
```

## 🔧 Technical Details

### Memory Access Strategy

1. **Built-in Sample Data**: Program includes safe sample data for testing
2. **Address Validation**: Converts and validates hexadecimal addresses
3. **Size Validation**: Ensures dump size is within 1-256 byte range
4. **Safe Reading**: Attempts to read from specified memory location

### Algorithm Details

```
For each 16-byte line:
  1. Display 8-digit hex address
  2. Read up to 16 bytes from memory
  3. Display each byte in hex format
  4. Display ASCII representation
  5. Advance to next line
```

### Performance Characteristics

- **Time Complexity**: O(n) where n is number of bytes to dump
- **Space Complexity**: O(1) constant space usage
- **Memory Access**: Direct memory reading via pointer dereferencing
- **Output Rate**: ~1000 bytes/second formatted output

## 🏗️ Architecture

### Memory Layout

```
.data section:
├── User interface messages
├── Error messages
├── Format strings and separators
├── Hex character lookup table
└── Sample data for safe testing

.bss section:
├── addr_buffer     - Hex address input (32 bytes)
├── size_buffer     - Size input (16 bytes)
├── target_addr     - Parsed memory address
├── dump_size       - Number of bytes to dump
└── Output formatting buffers

.text section:
├── _start              - Program entry point
├── show_sample_info    - Display sample data address
├── get_address         - Parse hex address input
├── get_size           - Parse size input
├── dump_memory        - Main dump loop
├── dump_hex_line      - Format hex output
├── dump_ascii_line    - Format ASCII output
└── Helper functions   - Hex/decimal conversion
```

### Register Usage

- **RAX**: System calls, memory addresses, data processing
- **RBX**: Input lengths, byte counts, temporary storage
- **RCX**: Loop counters, byte processing counts
- **RDX**: Error codes, character processing, validation
- **RSI**: Source memory pointers, buffer indexing
- **RDI**: Destination pointers, system call parameters
- **R8/R9**: Temporary values for hex conversion

## 🔍 Code Structure

### Main Functions

1. **`_start`**: Program initialization and main flow control
2. **`show_sample_info`**: Displays built-in sample data address
3. **`get_address`**: Parses and validates hexadecimal address input
4. **`get_size`**: Parses and validates dump size input
5. **`dump_memory`**: Main memory dumping loop
6. **`dump_hex_line`**: Formats hexadecimal byte display
7. **`dump_ascii_line`**: Formats ASCII character display

### Memory Dump Process

```assembly
; Pseudocode representation:
for each 16-byte line:
    display_address(current_address)
    for each byte in line:
        byte_value = read_memory(current_address + offset)
        display_hex(byte_value)
        store_for_ascii(byte_value)
    display_ascii_representation()
    advance_to_next_line()
```

### Address Parsing Algorithm

```assembly
; Hex string to 64-bit address conversion:
result = 0
for each character in hex_string:
    if character is '0'-'9':
        digit = character - '0'
    elif character is 'A'-'F':
        digit = character - 'A' + 10
    elif character is 'a'-'f':
        digit = character - 'a' + 10
    else:
        return error
    result = (result << 4) | digit
```

## 🐛 Debugging

### Build with Debug Symbols

```bash
make debug
```

### Using GDB

```bash
gdb ./memory_dump
(gdb) break _start
(gdb) run
(gdb) step
(gdb) x/16x 0x402000  # Examine 16 bytes in hex
```

### Debugging Memory Issues

```bash
# Check sample data location
objdump -t memory_dump | grep sample_data

# Verify program memory layout
cat /proc/[PID]/maps
```

## 📈 Performance Optimizations

- **Efficient Hex Conversion**: Lookup table for hex digit conversion
- **Minimal Memory Allocation**: Stack-based temporary storage
- **Optimized Line Processing**: Processes 16 bytes per iteration
- **Direct Memory Access**: No unnecessary copying of data

## 🚨 Security Considerations

### Memory Access Safety

⚠️ **Warning**: This tool attempts to read from arbitrary memory addresses:

- **Segmentation Faults**: Invalid addresses will crash the program
- **Kernel Space**: Don't attempt to access kernel memory
- **Null Pointers**: Address 0x0 will cause immediate crash
- **Stack/Heap**: Be cautious with dynamic memory addresses

### Safe Usage Practices

1. **Use Sample Data**: Always test with the provided sample data first
2. **Valid Addresses**: Only use addresses within your program's memory space
3. **Small Dumps**: Start with small byte counts (16-64 bytes)
4. **Address Validation**: Verify addresses are reasonable before use

### Memory Layout Understanding

```
Program Memory Layout:
├── Code Section (.text)    - Executable instructions
├── Data Section (.data)    - Initialized data (sample_data here)
├── BSS Section (.bss)      - Uninitialized data
├── Heap                    - Dynamic allocation
└── Stack                   - Function calls, local variables
```

## 🎓 Educational Value

This implementation demonstrates:

- **Memory Management**: Direct memory access and pointer arithmetic
- **Data Representation**: Binary, hexadecimal, and ASCII formats
- **String Processing**: Hex string parsing and validation
- **System Programming**: Low-level memory operations
- **Output Formatting**: Professional hex dump presentation

## 🔧 Advanced Features

### Hex Address Formats Supported

```bash
# Various valid hex address formats:
400000      # Standard hex
0x400000    # C-style hex prefix (0x ignored)
400ABC      # Mixed case accepted
DEADBEEF    # Full 32-bit address
```

### ASCII Display Rules

| Byte Value | ASCII Display | Description |
|------------|---------------|-------------|
| 0x20-0x7E | Character | Printable ASCII |
| 0x09 | `.` | Tab (non-printable) |
| 0x0A | `.` | Newline (non-printable) |
| 0x00-0x1F | `.` | Control characters |
| 0x7F-0xFF | `.` | Extended ASCII |

## 🏃‍♂️ Quick Start

```bash
# Build and run immediately
make build && make run

# Quick test with sample data
make demo

# Advanced testing scenarios
make test-advanced
```

## 💡 Use Cases

### Debugging Applications

- **Binary Analysis**: Examine executable file structures
- **Data Structure Inspection**: View memory layout of structures
- **Buffer Analysis**: Check buffer contents and boundaries
- **Corruption Detection**: Identify memory corruption patterns

### Educational Purposes

- **Assembly Learning**: Understand memory layout and access
- **Computer Architecture**: See how data is stored in memory
- **Debugging Skills**: Learn to interpret hex dumps
- **System Programming**: Understand low-level memory operations

## 🚀 Extension Ideas

Potential enhancements for learning:

1. **File Input**: Read and dump file contents
2. **Search Function**: Find specific byte patterns
3. **Comparison Mode**: Compare two memory regions
4. **Export Options**: Save dumps to files
5. **Color Coding**: Highlight different data types

## 📄 License

This project is part of an Assembly Language Programming course. Free to use for educational purposes.

## 🤝 Contributing

This is an educational project. Suggestions for improvements in memory safety, output formatting, or feature additions are welcome.

---

**Note**: This tool is designed for educational purposes and debugging. Always exercise caution when accessing memory addresses, and use the built-in sample data for safe testing.