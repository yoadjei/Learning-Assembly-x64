# Binary-to-Decimal Converter

A high-performance binary-to-decimal converter implemented in NASM x86_64 assembly language for Linux systems.

## 🚀 Features

- **Fast Binary Conversion**: Direct bit manipulation for optimal performance
- **Input Validation**: Comprehensive error checking for invalid characters
- **Overflow Protection**: Handles numbers up to 32 bits safely
- **User-Friendly Interface**: Clear prompts and error messages
- **Zero Dependencies**: Pure assembly implementation
- **Robust Error Handling**: Graceful handling of edge cases

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
./binary_converter
```

### Example Session

```
Binary to Decimal Converter
Enter a binary number (max 32 bits): 1010
Decimal equivalent: 10
```

## 📊 Examples

| Binary Input | Decimal Output | Description |
|--------------|----------------|-------------|
| `0` | `0` | Zero |
| `1` | `1` | One |
| `1010` | `10` | Ten |
| `11111111` | `255` | Max 8-bit value |
| `10000000000000000000000000000000` | `2147483648` | 2^31 |
| `11111111111111111111111111111111` | `4294967295` | Max 32-bit value |

## 🧪 Testing

### Run Test Suite

```bash
make test
```

### Manual Testing

```bash
# Test valid binary numbers
echo "1010" | ./binary_converter
echo "11110000" | ./binary_converter

# Test edge cases
echo "0" | ./binary_converter
echo "1" | ./binary_converter
```

## 🔧 Technical Details

### Algorithm

The converter uses a **right-to-left bit processing algorithm**:

1. **Input Validation**: Checks each character is '0' or '1'
2. **Length Verification**: Ensures input ≤ 32 bits
3. **Conversion Process**: 
   - Starts from rightmost bit (LSB)
   - Multiplies each '1' by corresponding power of 2
   - Accumulates the result
4. **Overflow Detection**: Monitors for arithmetic overflow

### Performance Characteristics

- **Time Complexity**: O(n) where n is the number of bits
- **Space Complexity**: O(1) constant space usage
- **Maximum Input**: 32-bit binary numbers
- **Range**: 0 to 4,294,967,295 (2^32 - 1)

### Error Handling

| Error Type | Detection | Response |
|------------|-----------|----------|
| Invalid Characters | Character validation | "Invalid binary number" message |
| Overflow | Length check + arithmetic overflow | "Number too large" message |
| Empty Input | Input length validation | Graceful termination |

## 🏗️ Architecture

### Memory Layout

```
.data section:
├── prompt_msg     - User prompt string
├── result_msg     - Result prefix string  
├── error_msg      - Invalid input message
├── overflow_msg   - Overflow error message
└── buffers        - I/O buffers

.text section:
├── _start         - Program entry point
├── binary_to_decimal - Core conversion function
└── print_decimal  - Number output function
```

### Register Usage

- **RAX**: System call numbers, arithmetic operations
- **RBX**: String length, loop counters
- **RCX**: Result accumulator
- **RDI**: Power of 2 multiplier
- **RSI**: String indexing
- **RDX**: Character processing, I/O operations

## 🔍 Code Structure

### Main Functions

1. **`_start`**: Program initialization and flow control
2. **`binary_to_decimal`**: Core conversion algorithm
3. **`print_decimal`**: Decimal number formatting and output
4. **Error handlers**: Input validation and error reporting

### Conversion Algorithm Details

```assembly
; Pseudocode representation:
result = 0
power = 1
for each bit from right to left:
    if bit == '1':
        result += power
    power *= 2
```

## 🐛 Debugging

### Build with Debug Symbols

```bash
make debug
```

### Using GDB

```bash
gdb ./binary_converter
(gdb) break _start
(gdb) run
(gdb) step
```

## 📈 Performance Optimizations

- **Bit Shifting**: Uses `shl` instruction for efficient power-of-2 multiplication
- **Register Usage**: Minimizes memory access through optimal register allocation  
- **Early Exit**: Immediate error detection prevents unnecessary processing
- **Direct Syscalls**: No library overhead for I/O operations

## 🚨 Limitations

- Maximum input size: 32 bits
- Input must contain only '0' and '1' characters
- No support for negative numbers
- No support for fractional binary numbers

## 🏃‍♂️ Quick Start

```bash
# Clone/download the files
# Build and test in one command
make build && make test

# Run interactively
make run
```

## 📄 License

This project is part of an Assembly Language Programming course. Free to use for educational purposes.

## 🤝 Contributing

This is an educational project. Suggestions for improvements in algorithm efficiency or code clarity are welcome.

---

**Note**: This implementation prioritizes educational value and demonstrates fundamental assembly programming concepts including bit manipulation, string processing, and system calls.