; Decimal-to-Binary Converter  
; Converts a decimal number to binary representation
; Platform: Linux x86_64, NASM

section .data
    ; Messages
    prompt_msg db "Decimal to Binary Converter", 0x0A
               db "Enter a decimal number (0-4294967295): ", 0
    prompt_len equ $ - prompt_msg
    
    result_msg db "Binary equivalent: ", 0
    result_len equ $ - result_msg
    
    error_msg db "Error: Invalid decimal number!", 0x0A, 0
    error_len equ $ - error_msg
    
    overflow_msg db "Error: Number too large (max 4294967295)!", 0x0A, 0
    overflow_len equ $ - overflow_msg
    
    newline db 0x0A, 0
    
    ; Buffers
    input_buffer resb 32
    binary_buffer resb 33      ; 32 bits + null terminator

section .text
    global _start

_start:
    ; Display prompt
    mov rax, 1              ; sys_write
    mov rdi, 1              ; stdout
    mov rsi, prompt_msg
    mov rdx, prompt_len
    syscall
    
    ; Read decimal input
    mov rax, 0              ; sys_read
    mov rdi, 0              ; stdin
    mov rsi, input_buffer
    mov rdx, 32
    syscall
    
    ; Store input length (excluding newline)
    mov rbx, rax
    dec rbx                 ; Remove newline from count
    
    ; Convert string to decimal number
    call string_to_decimal
    
    ; Check for conversion error
    cmp rdx, -1
    je input_error
    cmp rdx, -2
    je overflow_error
    
    ; Convert decimal to binary
    mov rax, rcx            ; Get decimal number from conversion
    call decimal_to_binary
    
    ; Display result message
    mov rax, 1              ; sys_write
    mov rdi, 1              ; stdout
    mov rsi, result_msg
    mov rdx, result_len
    syscall
    
    ; Display binary result
    call print_binary
    
    ; Print newline
    mov rax, 1              ; sys_write
    mov rdi, 1              ; stdout
    mov rsi, newline
    mov rdx, 1
    syscall
    
    ; Exit program
    mov rax, 60             ; sys_exit
    mov rdi, 0              ; exit status
    syscall

; Function: string_to_decimal
; Input: input_buffer contains decimal string, rbx = length
; Output: rcx = decimal result, rdx = 0 (success), -1 (invalid), -2 (overflow)
string_to_decimal:
    push rbp
    mov rbp, rsp
    push rax
    push rsi
    push rdi
    
    xor rcx, rcx            ; Result accumulator
    xor rsi, rsi            ; Index counter
    mov rdi, 10             ; Multiplier
    
    ; Check for empty input
    test rbx, rbx
    jz string_error
    
convert_loop:
    ; Check if we've processed all characters
    cmp rsi, rbx
    jge convert_success
    
    ; Get current character
    movzx rax, byte [input_buffer + rsi]
    
    ; Validate character (must be '0'-'9')
    cmp rax, '0'
    jl string_error
    cmp rax, '9'
    jg string_error
    
    ; Convert ASCII to digit
    sub rax, '0'
    
    ; Check for overflow before multiplication
    mov rdx, 0xFFFFFFFF     ; Max 32-bit value
    sub rdx, rax            ; Space remaining
    cmp rcx, 0
    je no_overflow_check    ; First digit, no overflow possible
    
    ; Check if rcx * 10 would overflow
    push rax
    mov rax, rcx
    mul rdi                 ; rcx * 10
    cmp rdx, 0              ; Check high part of result
    jnz overflow_detected
    pop rax
    mov rcx, rax            ; Move low part back
    pop rax                 ; Restore digit
    
    ; Add current digit
    add rcx, rax
    jc overflow_detected    ; Check for addition overflow
    jmp next_digit
    
no_overflow_check:
    ; Multiply result by 10 and add current digit
    imul rcx, rdi
    add rcx, rax
    
next_digit:
    ; Move to next character
    inc rsi
    jmp convert_loop
    
overflow_detected:
    mov rdx, -2             ; Overflow error
    jmp string_exit
    
string_error:
    mov rdx, -1             ; Invalid input error
    jmp string_exit
    
convert_success:
    mov rdx, 0              ; Success
    
string_exit:
    pop rdi
    pop rsi
    pop rax
    pop rbp
    ret

; Function: decimal_to_binary
; Input: rax = decimal number
; Output: binary_buffer contains binary string
decimal_to_binary:
    push rbp
    mov rbp, rsp
    push rbx
    push rcx
    push rdx
    push rsi
    
    ; Handle zero case
    test rax, rax
    jnz non_zero_decimal
    mov byte [binary_buffer], '0'
    mov byte [binary_buffer + 1], 0
    jmp binary_done
    
non_zero_decimal:
    mov rbx, rax            ; Copy number to rbx
    mov rsi, binary_buffer
    add rsi, 32             ; Point to end of buffer
    mov byte [rsi], 0       ; Null terminator
    dec rsi                 ; Move to last position
    
binary_loop:
    ; Extract least significant bit
    mov rdx, rbx
    and rdx, 1              ; Get LSB
    add rdx, '0'            ; Convert to ASCII
    mov [rsi], dl           ; Store bit
    
    ; Shift right by 1 bit
    shr rbx, 1
    
    ; Move to next position (left)
    dec rsi
    
    ; Continue if number is not zero
    test rbx, rbx
    jnz binary_loop
    
    ; Move result to beginning of buffer
    inc rsi                 ; Point to first character
    mov rdi, binary_buffer
    
copy_result:
    mov al, [rsi]
    mov [rdi], al
    test al, al
    jz binary_done
    inc rsi
    inc rdi
    jmp copy_result
    
binary_done:
    pop rsi
    pop rdx
    pop rcx
    pop rbx
    pop rbp
    ret

; Function: print_binary
; Output: prints binary_buffer to stdout
print_binary:
    push rbp
    mov rbp, rsp
    push rax
    push rcx
    push rdi
    push rsi
    
    ; Calculate string length
    mov rsi, binary_buffer
    xor rcx, rcx
    
length_loop:
    cmp byte [rsi + rcx], 0
    je length_done
    inc rcx
    jmp length_loop
    
length_done:
    ; Print binary string
    mov rax, 1              ; sys_write
    mov rdi, 1              ; stdout
    mov rsi, binary_buffer
    mov rdx, rcx            ; String length
    syscall
    
    pop rsi
    pop rdi
    pop rcx
    pop rax
    pop rbp
    ret

; Error handlers
input_error:
    mov rax, 1              ; sys_write
    mov rdi, 1              ; stdout
    mov rsi, error_msg
    mov rdx, error_len
    syscall
    jmp exit_error

overflow_error:
    mov rax, 1              ; sys_write
    mov rdi, 1              ; stdout
    mov rsi, overflow_msg
    mov rdx, overflow_len
    syscall
    jmp exit_error

exit_error:
    mov rax, 60             ; sys_exit
    mov rdi, 1              ; exit with error
    syscall