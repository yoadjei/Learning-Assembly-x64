# Learning-Assembly-x64

Assembly language (x64) learning repository containing implementations of fundamental algorithms, data manipulation tools, and system-level programming examples.

## Contents

### Algorithms
- **Bubble Sort** - Classic sorting algorithm implementation
- **Binary-to-Decimal Converter** - Converts binary strings to decimal integers
- **Decimal-to-Binary Converter** - Converts decimal integers to binary representation

### System Programming
- **Memory Dump Tool** - Utility for examining memory contents
- **Socket Programming** - Network communication implementations using x64 assembly

### Cryptography
- **Basic Encryption (XOR Cipher)** - Simple XOR-based encryption/decryption

## Requirements

- x64 architecture processor
- NASM assembler (or compatible)
- Linux operating system (assumed based on typical x64 assembly development)
- Linker (ld)

## Building
```bash
nasm -f elf64 <source_file>.asm -o <source_file>.o
ld <source_file>.o -o <executable_name>
```

## Purpose

Educational repository demonstrating x64 assembly programming concepts including:
- Data manipulation
- Control flow
- System calls
- Network programming
- Algorithm implementation

## Structure

Each directory contains standalone assembly programs with focused functionality.
