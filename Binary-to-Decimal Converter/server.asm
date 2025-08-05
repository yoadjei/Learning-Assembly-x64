; Binary-to-Decimal Converter
; Converts a binary string to its decimal equivalent
; Platform: Linux x86_64, NASM

section .data
    ; Messages
    prompt_msg db "Binary to Decimal Converter", 0x0A
               db "Enter a binary number (max 32 bits): ", 0
    prompt_len equ $ - prompt_msg
    
    result_msg db "Decimal equivalent: ", 0
    result_len equ $ - result_msg
    
    error_msg db "Error: Invalid binary number! Only 0s and 1s allowed.", 0x0A, 0
    error_len equ $ - error_msg
    
    overflow_msg db "Error: Number too large (max 32 bits)!", 0x0A, 0
    overflow_len equ $ - overflow_msg
    
    newline db 0x0A, 0
    
    ; Buffer for input
    input_buffer resb 64
    
    ; Buffer for output decimal number (max 10 digits for 32-bit)
    output_buffer resb 16

section .text
    global _start

_start:
    ; Display prompt
    mov rax, 1              ; sys_write
    mov rdi, 1              ; stdout
    mov rsi, prompt_msg
    mov rdx, prompt_len
    syscall
    
    ; Read binary input
    mov rax, 0              ; sys_read
    mov rdi, 0              ; stdin
    mov rsi, input_buffer
    mov rdx, 64
    syscall
    
    ; Store input length (excluding newline)
    mov rbx, rax
    dec rbx                 ; Remove newline from count
    
    ; Validate input length (max 32 bits)
    cmp rbx, 32
    ja overflow_error
    
    ; Convert binary to decimal
    call binary_to_decimal
    
    ; Check for conversion error
    cmp rax, -1
    je input_error
    
    ; Display result message
    mov rax, 1              ; sys_write
    mov rdi, 1              ; stdout
    mov rsi, result_msg
    mov rdx, result_len
    syscall
    
    ; Convert decimal result to string and display
    mov rax, rcx            ; Get result from conversion
    call print_decimal
    
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

; Function: binary_to_decimal
; Input: input_buffer contains binary string, rbx = length
; Output: rcx = decimal result, rax = 0 (success) or -1 (error)
binary_to_decimal:
    push rbp
    mov rbp, rsp
    push rdx
    push rsi
    push rdi
    
    xor rcx, rcx            ; Result accumulator
    xor rsi, rsi            ; Index counter
    mov rdi, 1              ; Power of 2 multiplier
    
    ; Process binary string from right to left
    mov rax, rbx            ; Get string length
    dec rax                 ; Point to last character
    
convert_loop:
    ; Check if we've processed all characters
    cmp rax, 0
    jl convert_done
    
    ; Get current character
    movzx rdx, byte [input_buffer + rax]
    
    ; Validate character (must be '0' or '1')
    cmp rdx, '0'
    je process_zero
    cmp rdx, '1'
    je process_one
    
    ; Invalid character found
    mov rax, -1
    jmp convert_exit
    
process_zero:
    ; For '0', just move to next position
    jmp next_bit
    
process_one:
    ; For '1', add current power of 2 to result
    add rcx, rdi
    ; Check for overflow (simple check)
    jc overflow_detected
    
next_bit:
    ; Double the power of 2 for next position
    shl rdi, 1
    ; Check for overflow in power calculation
    jc overflow_detected
    
    ; Move to next character (going left)
    dec rax
    jmp convert_loop
    
overflow_detected:
    mov rax, -2             ; Overflow error code
    jmp convert_exit
    
convert_done:
    mov rax, 0              ; Success
    
convert_exit:
    pop rdi
    pop rsi
    pop rdx
    pop rbp
    ret

; Function: print_decimal
; Input: rax = decimal number to print
; Output: prints the number to stdout
print_decimal:
    push rbp
    mov rbp, rsp
    push rbx
    push rcx
    push rdx
    push rsi
    push rdi
    
    ; Handle zero case
    test rax, rax
    jnz non_zero
    mov byte [output_buffer], '0'
    mov rax, 1
    mov rdi, 1
    mov rsi, output_buffer
    mov rdx, 1
    syscall
    jmp print_done
    
non_zero:
    mov rbx, 10             ; Divisor
    mov rcx, 0              ; Digit counter
    mov rsi, output_buffer
    add rsi, 15             ; Point to end of buffer
    
convert_digits:
    xor rdx, rdx            ; Clear remainder
    div rbx                 ; Divide by 10
    add rdx, '0'            ; Convert remainder to ASCII
    dec rsi                 ; Move buffer pointer left
    mov [rsi], dl           ; Store digit
    inc rcx                 ; Increment digit count
    
    test rax, rax           ; Check if quotient is zero
    jnz convert_digits
    
    ; Print the number
    mov rax, 1              ; sys_write
    mov rdi, 1              ; stdout
    mov rdx, rcx            ; Number of digits
    syscall
    
print_done:
    pop rdi
    pop rsi
    pop rdx
    pop rcx
    pop rbx
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