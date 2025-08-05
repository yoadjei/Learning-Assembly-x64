# Decimal-to-Binary Converter

A high-performance decimal-to-binary converter implemented in NASM x86_64 assembly language for Linux systems.

## 🚀 Features

- **Efficient Conversion**: Uses bit manipulation for optimal performance
- **Input Validation**: Comprehensive checking for valid decimal numbers
- **Overflow Protection**: Handles 32-bit unsigned integers (0-4,294,967,295)
- **User-Friendly Interface**: Clear prompts and error messages
- **Zero Dependencies**: Pure assembly implementation
- **Robust Error Handling**: Graceful handling of invalid input and overflow

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
./decimal_converter
```

### Example Session

```
Decimal to Binary Converter
Enter a decimal number (0-4294967295): 10
Binary equivalent: 1010
```

## 📊 Examples

| Decimal Input | Binary Output | Description |
|---------------|---------------|-------------|
| `0` | `0` | Zero |
| `1` | `1` | One |
| `10` | `1010` | Ten |
| `16` | `10000` | Sixteen (2^4) |
| `255` | `11111111` | Max 8-bit value |
| `1024` | `10000000000` | 2^10 |
| `4294967295` | `11111111111111111111111111111111` | Max 32-bit value |

## 🧪 Testing

### Run Basic Test Suite

```bash
make test
```

### Run Extended Tests

```bash
make test-extended
```

### Manual Testing

```bash
# Test powers of 2
echo "16" | ./decimal_converter
echo "256" | ./decimal_converter

# Test edge cases
echo "0" | ./decimal_converter
echo "4294967295" | ./decimal_converter
```

## 🔧 Technical Details

### Algorithm

The converter uses a **divide-by-2 algorithm with bit shifting**:

1. **Input Validation**: Parses and validates decimal string
2. **Range Check**: Ensures number ≤ 4,294,967,295 (2^32 - 1)
3. **Conversion Process**:
   - Extracts least significant bit (LSB)
   - Converts bit to ASCII character
   - Right-shifts number by 1 bit
   - Repeats until number becomes 0
4. **String Assembly**: Builds binary string from right to left

### Performance Characteristics

- **Time Complexity**: O(log₂n) where n is the decimal number
- **Space Complexity**: O(log₂n) for binary representation storage
- **Maximum Input**: 4,294,967,295 (32-bit unsigned integer)
- **Output Range**: 1 to 32 binary digits

### Error Handling

| Error Type | Detection | Response |
|------------|-----------|----------|
| Invalid Characters | Character-by-character validation | "Invalid decimal number" |
| Numeric Overflow | Range checking during parsing | "Number too large" |
| Empty Input | Input length validation | "Invalid decimal number" |

## 🏗️ Architecture

### Memory Layout

```
.data section:
├── prompt_msg     - User input prompt
├── result_msg     - Result display prefix
├── error_msg      - Invalid input message
├── overflow_msg   - Overflow error message
├── input_buffer   - Decimal input storage (32 bytes)
└── binary_buffer  - Binary output storage (33 bytes)

.text section:
├── _start              - Program entry point
├── string_to_decimal   - String parsing function
├── decimal_to_binary   - Core conversion function
└── print_binary        - Output formatting function
```

### Register Usage

- **RAX**: System calls, arithmetic operations
- **RBX**: Input processing, bit manipulation
- **RCX**: Result storage, string operations
- **RDX**: Error codes, character processing
- **RSI/RDI**: Buffer indexing and data movement

## 🔍 Code Structure

### Main Functions

1. **`_start`**: Program initialization and control flow
2. **`string_to_decimal`**: Converts ASCII decimal to integer
3. **`decimal_to_binary`**: Core binary conversion algorithm
4. **`print_binary`**: Formats and outputs binary string

### Conversion Algorithm Details

```assembly
; Pseudocode representation:
binary_string = ""
while (number > 0):
    bit = number & 1        ; Extract LSB
    binary_string = bit + binary_string
    number = number >> 1    ; Right shift
```

## 🐛 Debugging

### Build with Debug Symbols

```bash
make debug
```

### Using GDB

```bash
gdb ./decimal_converter
(gdb) break _start
(gdb) run
(gdb) step
```

## 📈 Performance Optimizations

- **Bit Shifting**: Uses `shr` instruction for efficient division by 2
- **Direct Bit Extraction**: Uses `and` instruction for LSB extraction
- **In-Place Processing**: Minimizes memory copying operations
- **Optimized String Building**: Builds result string efficiently

## 🚨 Limitations

- Maximum input: 4,294,967,295 (32-bit unsigned integer)
- Input must be positive decimal number
- No support for negative numbers or floating-point
- ASCII decimal input only (no hexadecimal or octal)

## 🏃‍♂️ Quick Start

```bash
# Build and test in one command
make build && make test

# Run interactively
make run

# Test specific number
echo "42" | ./decimal_converter
```

## 💡 Educational Value

This implementation demonstrates:

- **String Processing**: Parsing ASCII decimal numbers
- **Bit Manipulation**: Extracting and processing individual bits
- **Number Base Conversion**: Converting between decimal and binary
- **Error Handling**: Input validation and overflow detection
- **System Programming**: Direct system calls without library dependencies

## 📄 License

This project is part of an Assembly Language Programming course. Free to use for educational purposes.

## 🤝 Contributing

This is an educational project. Suggestions for improvements in algorithm efficiency or code clarity are welcome.

---

**Note**: This implementation prioritizes educational value and demonstrates fundamental assembly programming concepts including arithmetic operations, bit manipulation, and string processing.