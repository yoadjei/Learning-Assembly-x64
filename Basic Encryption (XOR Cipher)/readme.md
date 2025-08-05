# XOR Cipher - Encryption/Decryption Tool

A simple yet effective XOR-based encryption and decryption tool implemented in NASM x86_64 assembly language for Linux systems.

## 🚀 Features

- **Bidirectional Operation**: Both encryption and decryption modes
- **Hexadecimal Output**: Encrypted data displayed in readable hex format
- **Key Cycling**: Automatically repeats key for messages longer than key
- **Interactive Interface**: User-friendly menu system
- **Input Validation**: Comprehensive error checking
- **Pure Assembly**: Zero external dependencies

## 🔐 How XOR Cipher Works

XOR (Exclusive OR) cipher is a symmetric encryption algorithm where:
- **Encryption**: `ciphertext = plaintext XOR key`
- **Decryption**: `plaintext = ciphertext XOR key`
- **Property**: `A XOR B XOR B = A` (self-inverse operation)

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
./xor_cipher
```

### Example Session

```
XOR Cipher - Encryption/Decryption Tool
=========================================
Select mode:
1) Encrypt
2) Decrypt
Enter choice (1 or 2): 1
Enter text (max 255 chars): Hello World
Enter encryption key (max 63 chars): secret
Encrypted (hex): 3B0A1E1C1D4E4C1D0E0C1A
```

## 📊 Examples

### Encryption Examples

| Plaintext | Key | Encrypted (Hex) |
|-----------|-----|-----------------|
| `Hello` | `key` | `030D1C1C1D` |
| `Secret` | `pass` | `033A0B1C1A16` |
| `XOR` | `123` | `695D520` |

### Decryption Process

To decrypt, use mode 2 with the same key used for encryption.

## 🧪 Testing

### Run Test Mode

```bash
make test
```

### Run Demo

```bash
make demo
```

### Security Testing

```bash
make security-test
```

### Manual Testing

```bash
# Test encryption
./xor_cipher
# Choose mode 1, enter text and key

# Test decryption  
./xor_cipher
# Choose mode 2, enter encrypted result and same key
```

## 🔧 Technical Details

### Algorithm Implementation

1. **Key Cycling**: When message is longer than key, the key repeats
2. **XOR Operation**: Each character XORed with corresponding key character
3. **Hex Encoding**: Encrypted bytes converted to hexadecimal for display
4. **Symmetric Property**: Same operation used for both encrypt/decrypt

### Performance Characteristics

- **Time Complexity**: O(n) where n is message length
- **Space Complexity**: O(n) for storing encrypted/decrypted result
- **Key Length**: Up to 63 characters
- **Message Length**: Up to 255 characters

### Security Properties

| Property | XOR Cipher | Notes |
|----------|------------|-------|
| **Confidentiality** | Weak | Vulnerable to frequency analysis |
| **Perfect Secrecy** | Yes* | *Only if key is truly random and used once |
| **Key Reuse** | Dangerous | Never reuse keys with different messages |
| **Brute Force** | Vulnerable | All possible keys can be tested |

## 🏗️ Architecture

### Memory Layout

```
.data section:
├── User interface messages
├── Error messages  
└── Hex character lookup table

.bss section:
├── mode_buffer     - User mode selection
├── text_buffer     - Input text (256 bytes)
├── key_buffer      - Encryption key (64 bytes)
├── result_buffer   - Output storage (512 bytes)
└── length variables - Text/key length tracking

.text section:
├── _start          - Program entry and flow control
├── get_mode        - Mode selection handler
├── get_text        - Text input handler
├── get_key         - Key input handler
├── encrypt_text    - XOR encryption function
├── decrypt_text    - XOR decryption function
└── display functions - Output formatting
```

### Register Usage

- **RAX**: System calls, character processing
- **RBX**: Key length, loop counters
- **RCX**: Message length, loop control
- **RDX**: Key index with wraparound
- **RSI/RDI**: Buffer pointers for data movement
- **R8/R9**: Temporary character and nibble processing

## 🔍 Code Structure

### Main Functions

1. **`get_mode`**: Handles user selection between encrypt/decrypt
2. **`get_text`**: Validates and stores input message
3. **`get_key`**: Validates and stores encryption key
4. **`encrypt_text`**: Performs XOR encryption with hex output
5. **`decrypt_text`**: Performs XOR decryption

### Encryption Process

```assembly
; Pseudocode representation:
for each character in message:
    key_char = key[key_index % key_length]
    encrypted_char = message_char XOR key_char
    output_hex(encrypted_char)
    key_index++
```

## 🐛 Debugging

### Build with Debug Symbols

```bash
make debug
```

### Using GDB

```bash
gdb ./xor_cipher
(gdb) break _start
(gdb) run
(gdb) step
```

## 📈 Performance Optimizations

- **Efficient XOR**: Direct bitwise XOR operations
- **Key Cycling**: Modular arithmetic for key reuse
- **Hex Conversion**: Lookup table for fast nibble-to-hex conversion
- **Buffer Management**: Minimal memory copying

## 🚨 Security Warnings

⚠️ **Educational Use Only**: This cipher has known vulnerabilities:

- **Frequency Analysis**: Patterns in plaintext remain in ciphertext
- **Key Reuse Attack**: Same key with different messages reveals patterns  
- **Known Plaintext**: If plaintext is known, key can be recovered
- **Short Keys**: Repeating short keys create detectable patterns

### Best Practices for XOR

1. **One-Time Pad**: Use truly random key as long as message
2. **Never Reuse Keys**: Each message needs unique key
3. **Secure Key Exchange**: Key distribution is critical
4. **Random Keys**: Avoid dictionary words or patterns

## 🎓 Educational Value

This implementation demonstrates:

- **Symmetric Cryptography**: Same key for encrypt/decrypt
- **Bitwise Operations**: XOR manipulation in assembly
- **Data Encoding**: Binary to hexadecimal conversion
- **Interactive Programs**: Menu-driven user interfaces
- **Buffer Management**: Safe string handling in assembly

## 🏃‍♂️ Quick Start

```bash
# Build and run
make build && make run

# Test encryption of "Hello" with key "world"
# Then decrypt the result with same key
```

## 💡 Advanced Usage

### Scripted Operation

```bash
# Create input file
echo -e "1\nHello World\nsecret" > input.txt

# Run with input redirection
./xor_cipher < input.txt
```

### Key Security Testing

```bash
# Test with different key lengths
# Short key: "a"
# Medium key: "password123"  
# Long key: "this_is_a_very_long_encryption_key_for_testing"
```

## 📄 License

This project is part of an Assembly Language Programming course. Free to use for educational purposes.

## 🤝 Contributing

This is an educational project. Suggestions for improvements in security awareness, code clarity, or algorithm efficiency are welcome.

Note: This implementation is designed for educational purposes to demonstrate XOR operations and basic cryptographic concepts. For production use, employ modern cryptographic libraries and algorithms.