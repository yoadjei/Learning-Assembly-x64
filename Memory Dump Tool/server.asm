; Memory Dump Tool
; Displays a section of memory in hexadecimal and ASCII
; Platform: Linux x86_64, NASM

section .data
    ; Messages
    title_msg db "Memory Dump Tool", 0x0A
              db "================", 0x0A, 0
    title_len equ $ - title_msg
    
    addr_prompt db "Enter memory address (hex, e.g., 400000): ", 0
    addr_len equ $ - addr_prompt
    
    size_prompt db "Enter number of bytes to dump (1-256): ", 0
    size_len equ $ - size_prompt
    
    dump_header db "Address   Hex Dump                         ASCII", 0x0A
                db "--------  -------------------------------  ----------------", 0x0A, 0
    header_len equ $ - dump_header
    
    error_addr db "Error: Invalid memory address!", 0x0A, 0
    error_addr_len equ $ - error_addr
    
    error_size db "Error: Invalid size (1-256 bytes only)!", 0x0A, 0
    error_size_len equ $ - error_size
    
    error_access db "Error: Memory access violation!", 0x0A, 0
    error_access_len equ $ - error_access
    
    newline db 0x0A, 0
    space db " ", 0
    pipe db " | ", 0
    dot db ".", 0
    
    ; Hex characters
    hex_chars db "0123456789ABCDEF"
    
    ; Sample data for demonstration
    sample_data db "Hello, World! This is sample data for memory dump demonstration.", 0x0A
                db "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()", 0x0A
                db "Memory dump tools are useful for debugging and analysis.", 0x0A
                db 0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0A, 0x0B, 0x0C, 0x0D, 0x0E, 0x0F
    sample_len equ $ - sample_data

section .bss
    ; Input buffers
    addr_buffer resb 32
    size_buffer resb 16
    
    ; Working variables
    target_addr resq 1
    dump_size resq 1
    
    ; Output formatting buffers
    hex_output resb 64
    ascii_output resb 17    ; 16 chars + null terminator

section .text
    global _start

_start:
    ; Display title
    mov rax, 1              ; sys_write
    mov rdi, 1              ; stdout
    mov rsi, title_msg
    mov rdx, title_len
    syscall
    
    ; Show sample data location for demonstration
    call show_sample_info
    
    ; Get memory address
    call get_address
    cmp rax, -1
    je exit_error
    
    ; Get dump size
    call get_size
    cmp rax, -1
    je exit_error
    
    ; Display dump header
    mov rax, 1              ; sys_write
    mov rdi, 1              ; stdout
    mov rsi, dump_header
    mov rdx, header_len
    syscall
    
    ; Perform memory dump
    call dump_memory
    
    ; Exit successfully
    mov rax, 60             ; sys_exit
    mov rdi, 0              ; exit status
    syscall

; Function: show_sample_info
; Shows the address of sample data for testing
show_sample_info:
    push rbp
    mov rbp, rsp
    
    ; Display sample data info
    mov rax, 1              ; sys_write
    mov rdi, 1              ; stdout
    mov rsi, sample_data_info
    mov rdx, sample_info_len
    syscall
    
    ; Display sample data address in hex
    mov rax, sample_data
    call print_hex_qword
    
    mov rax, 1              ; sys_write
    mov rdi, 1              ; stdout
    mov rsi, newline
    mov rdx, 1
    syscall
    
    mov rax, 1              ; sys_write
    mov rdi, 1              ; stdout
    mov rsi, newline
    mov rdx, 1
    syscall
    
    pop rbp
    ret

; Function: get_address
; Gets memory address from user input
; Output: rax = 0 (success), -1 (error)
get_address:
    push rbp
    mov rbp, rsp
    
    ; Display address prompt
    mov rax, 1              ; sys_write
    mov rdi, 1              ; stdout
    mov rsi, addr_prompt
    mov rdx, addr_len
    syscall
    
    ; Read address input
    mov rax, 0              ; sys_read
    mov rdi, 0              ; stdin
    mov rsi, addr_buffer
    mov rdx, 32
    syscall
    
    ; Convert hex string to address
    mov rbx, rax            ; Input length
    dec rbx                 ; Remove newline
    call hex_string_to_qword
    
    ; Check for conversion error
    cmp rdx, -1
    je addr_error
    
    ; Store target address
    mov [target_addr], rax
    mov rax, 0              ; Success
    jmp get_address_exit
    
addr_error:
    mov rax, 1              ; sys_write
    mov rdi, 1              ; stdout
    mov rsi, error_addr
    mov rdx, error_addr_len
    syscall
    mov rax, -1
    
get_address_exit:
    pop rbp
    ret

; Function: get_size
; Gets dump size from user input
; Output: rax = 0 (success), -1 (error)
get_size:
    push rbp
    mov rbp, rsp
    
    ; Display size prompt
    mov rax, 1              ; sys_write
    mov rdi, 1              ; stdout
    mov rsi, size_prompt
    mov rdx, size_len
    syscall
    
    ; Read size input
    mov rax, 0              ; sys_read
    mov rdi, 0              ; stdin
    mov rsi, size_buffer
    mov rdx, 16
    syscall
    
    ; Convert string to number
    mov rbx, rax            ; Input length
    dec rbx                 ; Remove newline
    call decimal_string_to_qword
    
    ; Check for conversion error
    cmp rdx, -1
    je size_error
    
    ; Validate size range (1-256)
    test rax, rax
    jz size_error
    cmp rax, 256
    ja size_error
    
    ; Store dump size
    mov [dump_size], rax
    mov rax, 0              ; Success
    jmp get_size_exit
    
size_error:
    mov rax, 1              ; sys_write
    mov rdi, 1              ; stdout
    mov rsi, error_size
    mov rdx, error_size_len
    syscall
    mov rax, -1
    
get_size_exit:
    pop rbp
    ret

; Function: dump_memory
; Performs the actual memory dump
dump_memory:
    push rbp
    mov rbp, rsp
    push rsi
    push rdi
    push rcx
    push rdx
    push rbx
    
    mov rsi, [target_addr]  ; Source address
    mov rcx, [dump_size]    ; Bytes to dump
    
dump_loop:
    ; Check if done
    test rcx, rcx
    jz dump_complete
    
    ; Calculate bytes for this line (max 16)
    mov rdx, 16
    cmp rcx, 16
    jge full_line
    mov rdx, rcx
    
full_line:
    ; Display address
    mov rax, rsi
    call print_hex_qword
    
    ; Display separator
    mov rax, 1              ; sys_write
    mov rdi, 1              ; stdout
    mov rsi, addr_sep
    mov rdx, addr_sep_len
    syscall
    
    ; Dump hex bytes
    push rcx
    push rdx
    push rsi
    mov rcx, rdx            ; Bytes in this line
    call dump_hex_line
    pop rsi
    pop rdx
    pop rcx
    
    ; Display ASCII representation
    push rcx
    push rdx
    push rsi
    mov rcx, rdx            ; Bytes in this line
    call dump_ascii_line
    pop rsi
    pop rdx
    pop rcx
    
    ; Move to next line
    add rsi, rdx            ; Advance source pointer
    sub rcx, rdx            ; Decrease remaining count
    
    ; Print newline
    mov rax, 1              ; sys_write
    mov rdi, 1              ; stdout
    mov rsi, newline
    mov rdx, 1
    syscall
    
    jmp dump_loop
    
dump_complete:
    pop rbx
    pop rdx
    pop rcx
    pop rdi
    pop rsi
    pop rbp
    ret

; Function: dump_hex_line
; Dumps one line of hex bytes
; Input: rsi = memory address, rcx = byte count
dump_hex_line:
    push rbp
    mov rbp, rsp
    push rax
    push rbx
    push rdx
    
hex_line_loop:
    test rcx, rcx
    jz hex_line_pad
    
    ; Get byte and convert to hex
    movzx rax, byte [rsi]
    call print_hex_byte
    
    ; Print space
    mov rax, 1              ; sys_write
    mov rdi, 1              ; stdout
    mov rsi, space
    mov rdx, 1
    syscall
    
    inc rsi
    dec rcx
    jmp hex_line_loop
    
hex_line_pad:
    ; Pad with spaces to align ASCII column
    mov rbx, 16
    sub rbx, rcx            ; Remaining spaces needed
    test rbx, rbx
    jz hex_line_done
    
pad_loop:
    ; Print 3 spaces for each missing byte
    mov rax, 1              ; sys_write
    mov rdi, 1              ; stdout
    mov rsi, space
    mov rdx, 1
    syscall
    mov rax, 1
    mov rdi, 1
    mov rsi, space
    mov rdx, 1
    syscall
    mov rax, 1
    mov rdi, 1
    mov rsi, space
    mov rdx, 1
    syscall
    
    dec rbx
    jnz pad_loop
    
hex_line_done:
    ; Print separator before ASCII
    mov rax, 1              ; sys_write
    mov rdi, 1              ; stdout
    mov rsi, pipe
    mov rdx, 3
    syscall
    
    pop rdx
    pop rbx
    pop rax
    pop rbp
    ret

; Function: dump_ascii_line
; Dumps ASCII representation of bytes
; Input: rsi = memory address, rcx = byte count
dump_ascii_line:
    push rbp
    mov rbp, rsp
    push rax
    push rbx
    
ascii_line_loop:
    test rcx, rcx
    jz ascii_line_done
    
    ; Get byte
    movzx rax, byte [rsi]
    
    ; Check if printable ASCII (32-126)
    cmp rax, 32
    jl non_printable
    cmp rax, 126
    jg non_printable
    
    ; Print the character
    push rsi
    push rcx
    mov [ascii_char], al
    mov rax, 1              ; sys_write
    mov rdi, 1              ; stdout
    mov rsi, ascii_char
    mov rdx, 1
    syscall
    pop rcx
    pop rsi
    jmp next_ascii
    
non_printable:
    ; Print dot for non-printable
    mov rax, 1              ; sys_write
    mov rdi, 1              ; stdout
    mov rsi, dot
    mov rdx, 1
    syscall
    
next_ascii:
    inc rsi
    dec rcx
    jmp ascii_line_loop
    
ascii_line_done:
    pop rbx
    pop rax
    pop rbp
    ret

; Helper function: print_hex_qword
; Input: rax = 64-bit value to print in hex
print_hex_qword:
    push rbp
    mov rbp, rsp
    push rax
    push rbx
    push rcx
    push rdx
    
    mov rbx, rax
    mov rcx, 16             ; 16 hex digits
    
hex_qword_loop:
    rol rbx, 4              ; Rotate left 4 bits
    mov rax, rbx
    and rax, 0x0F           ; Get low 4 bits
    movzx rax, byte [hex_chars + rax]
    
    push rcx
    push rbx
    mov [hex_digit], al
    mov rax, 1              ; sys_write
    mov rdi, 1              ; stdout
    mov rsi, hex_digit
    mov rdx, 1
    syscall
    pop rbx
    pop rcx
    
    dec rcx
    jnz hex_qword_loop
    
    pop rdx
    pop rcx
    pop rbx
    pop rax
    pop rbp
    ret

; Helper function: print_hex_byte
; Input: rax = byte value to print in hex
print_hex_byte:
    push rbp
    mov rbp, rsp
    push rax
    push rbx
    
    mov rbx, rax
    
    ; Print high nibble
    shr rax, 4
    and rax, 0x0F
    movzx rax, byte [hex_chars + rax]
    mov [hex_digit], al
    push rbx
    mov rax, 1              ; sys_write
    mov rdi, 1              ; stdout
    mov rsi, hex_digit
    mov rdx, 1
    syscall
    pop rbx
    
    ; Print low nibble
    mov rax, rbx
    and rax, 0x0F
    movzx rax, byte [hex_chars + rax]
    mov [hex_digit], al
    mov rax, 1              ; sys_write
    mov rdi, 1              ; stdout
    mov rsi, hex_digit
    mov rdx, 1
    syscall
    
    pop rbx
    pop rax
    pop rbp
    ret

; Function: hex_string_to_qword
; Converts hex string to 64-bit value
; Input: addr_buffer = hex string, rbx = length
; Output: rax = converted value, rdx = 0 (success) or -1 (error)
hex_string_to_qword:
    push rbp
    mov rbp, rsp
    push rcx
    push rsi
    
    xor rax, rax            ; Result
    xor rcx, rcx            ; Index
    
hex_convert_loop:
    cmp rcx, rbx
    jge hex_convert_done
    
    ; Get character
    movzx rdx, byte [addr_buffer + rcx]
    
    ; Convert hex digit
    cmp rdx, '0'
    jl hex_convert_error
    cmp rdx, '9'
    jle hex_digit_0_9
    cmp rdx, 'A'
    jl hex_convert_error
    cmp rdx, 'F'
    jle hex_digit_A_F
    cmp rdx, 'a'
    jl hex_convert_error
    cmp rdx, 'f'
    jle hex_digit_a_f
    jmp hex_convert_error
    
hex_digit_0_9:
    sub rdx, '0'
    jmp hex_add_digit
    
hex_digit_A_F:
    sub rdx, 'A'
    add rdx, 10
    jmp hex_add_digit
    
hex_digit_a_f:
    sub rdx, 'a'
    add rdx, 10
    
hex_add_digit:
    shl rax, 4              ; Shift left 4 bits
    or rax, rdx             ; Add new digit
    inc rcx
    jmp hex_convert_loop
    
hex_convert_error:
    mov rdx, -1
    jmp hex_convert_exit
    
hex_convert_done:
    mov rdx, 0              ; Success
    
hex_convert_exit:
    pop rsi
    pop rcx
    pop rbp
    ret

; Function: decimal_string_to_qword
; Converts decimal string to 64-bit value
; Input: size_buffer = decimal string, rbx = length
; Output: rax = converted value, rdx = 0 (success) or -1 (error)
decimal_string_to_qword:
    push rbp
    mov rbp, rsp
    push rcx
    push rsi
    push rdi
    
    xor rax, rax            ; Result
    xor rcx, rcx            ; Index
    mov rdi, 10             ; Base 10
    
dec_convert_loop:
    cmp rcx, rbx
    jge dec_convert_done
    
    ; Get character
    movzx rdx, byte [size_buffer + rcx]
    
    ; Validate digit
    cmp rdx, '0'
    jl dec_convert_error
    cmp rdx, '9'
    jg dec_convert_error
    
    ; Convert and add
    sub rdx, '0'
    imul rax, rdi           ; Multiply by 10
    add rax, rdx            ; Add digit
    
    inc rcx
    jmp dec_convert_loop
    
dec_convert_error:
    mov rdx, -1
    jmp dec_convert_exit
    
dec_convert_done:
    mov rdx, 0              ; Success
    
dec_convert_exit:
    pop rdi
    pop rsi
    pop rcx
    pop rbp
    ret

exit_error:
    mov rax, 60             ; sys_exit
    mov rdi, 1              ; exit with error
    syscall

section .data
    ; Additional data for helper functions
    sample_data_info db "Sample data available at address: ", 0
    sample_info_len equ $ - sample_data_info
    
    addr_sep db "  ", 0
    addr_sep_len equ $ - addr_sep
    
    hex_digit resb 1
    ascii_char resb 1