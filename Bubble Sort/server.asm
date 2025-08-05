; ================================================================
; GROUP 7: Bubble Sort in ASM
; Sorts an array of integers using bubble sort algorithm
; NASM 64-bit Assembly for Ubuntu 24.02
; ================================================================

section .data
    ; Program messages
    welcome_msg     db "=== Bubble Sort in Assembly ===", 0xA, 0
    welcome_len     equ $ - welcome_msg
    
    prompt_msg      db "Enter array size (1-20): ", 0
    prompt_len      equ $ - prompt_msg
    
    element_msg     db "Enter element ", 0
    element_len     equ $ - element_msg
    
    colon_msg       db ": ", 0
    colon_len       equ $ - colon_msg
    
    original_msg    db 0xA, "Original array: ", 0
    original_len    equ $ - original_msg
    
    sorted_msg      db 0xA, "Sorted array: ", 0
    sorted_len      equ $ - sorted_msg
    
    space_msg       db " ", 0
    space_len       equ $ - space_msg
    
    newline_msg     db 0xA, 0
    newline_len     equ $ - newline_msg
    
    error_msg       db "Error: Invalid input or size out of range!", 0xA, 0
    error_len       equ $ - error_msg

section .bss
    ; Input buffer and array storage
    input_buffer    resb 16         ; Buffer for user input
    array           resd 20         ; Array to store up to 20 integers
    array_size      resd 1          ; Size of the array
    temp_num        resd 1          ; Temporary number storage
    num_buffer      resb 12         ; Buffer for number conversion

section .text
    global _start

_start:
    ; Display welcome message
    mov rax, 1
    mov rdi, 1
    mov rsi, welcome_msg
    mov rdx, welcome_len
    syscall
    
    ; Get array size from user
    call get_array_size
    cmp eax, 0
    je exit_error
    
    ; Get array elements from user
    call get_array_elements
    
    ; Display original array
    call display_original_array
    
    ; Sort the array using bubble sort
    call bubble_sort
    
    ; Display sorted array
    call display_sorted_array
    
    ; Exit successfully
    mov rax, 60
    mov rdi, 0
    syscall

exit_error:
    ; Display error message and exit
    mov rax, 1
    mov rdi, 1
    mov rsi, error_msg
    mov rdx, error_len
    syscall
    
    mov rax, 60
    mov rdi, 1
    syscall

; ================================================================
; Function: get_array_size
; Gets the array size from user input
; Returns: eax = size (0 if error)
; ================================================================
get_array_size:
    push rbp
    mov rbp, rsp
    
    ; Display prompt
    mov rax, 1
    mov rdi, 1
    mov rsi, prompt_msg
    mov rdx, prompt_len
    syscall
    
    ; Read input
    mov rax, 0
    mov rdi, 0
    mov rsi, input_buffer
    mov rdx, 16
    syscall
    
    ; Convert string to integer
    mov rsi, input_buffer
    call string_to_int
    
    ; Validate size (1-20)
    cmp eax, 1
    jl .invalid_size
    cmp eax, 20
    jg .invalid_size
    
    ; Store array size
    mov [array_size], eax
    jmp .done
    
.invalid_size:
    mov eax, 0
    
.done:
    pop rbp
    ret

; ================================================================
; Function: get_array_elements
; Gets array elements from user input
; ================================================================
get_array_elements:
    push rbp
    mov rbp, rsp
    push rbx
    push rcx
    
    mov ebx, 0                      ; Element counter
    mov ecx, [array_size]           ; Total elements to read
    
.input_loop:
    cmp ebx, ecx
    jge .done
    
    ; Display "Enter element X: "
    mov rax, 1
    mov rdi, 1
    mov rsi, element_msg
    mov rdx, element_len
    syscall
    
    ; Display element number
    mov eax, ebx
    inc eax                         ; Make it 1-based
    call int_to_string
    mov rax, 1
    mov rdi, 1
    mov rsi, num_buffer
    mov rdx, rax
    syscall
    
    ; Display ": "
    mov rax, 1
    mov rdi, 1
    mov rsi, colon_msg
    mov rdx, colon_len
    syscall
    
    ; Read element value
    mov rax, 0
    mov rdi, 0
    mov rsi, input_buffer
    mov rdx, 16
    syscall
    
    ; Convert to integer and store in array
    mov rsi, input_buffer
    call string_to_int
    mov [array + ebx*4], eax
    
    inc ebx
    jmp .input_loop
    
.done:
    pop rcx
    pop rbx
    pop rbp
    ret

; ================================================================
; Function: bubble_sort
; Sorts the array using bubble sort algorithm
; ================================================================
bubble_sort:
    push rbp
    mov rbp, rsp
    push rax
    push rbx
    push rcx
    push rdx
    
    mov ecx, [array_size]           ; Outer loop counter
    dec ecx                         ; n-1 passes
    
.outer_loop:
    cmp ecx, 0
    jle .done
    
    mov ebx, 0                      ; Inner loop counter
    mov edx, ecx                    ; Inner loop limit
    
.inner_loop:
    cmp ebx, edx
    jge .next_pass
    
    ; Compare array[ebx] and array[ebx+1]
    mov eax, [array + ebx*4]
    mov r8d, [array + ebx*4 + 4]
    
    cmp eax, r8d
    jle .no_swap
    
    ; Swap elements
    mov [array + ebx*4], r8d
    mov [array + ebx*4 + 4], eax
    
.no_swap:
    inc ebx
    jmp .inner_loop
    
.next_pass:
    dec ecx
    jmp .outer_loop
    
.done:
    pop rdx
    pop rcx
    pop rbx
    pop rax
    pop rbp
    ret

; ================================================================
; Function: display_original_array
; Displays the original array
; ================================================================
display_original_array:
    push rbp
    mov rbp, rsp
    
    ; Display message
    mov rax, 1
    mov rdi, 1
    mov rsi, original_msg
    mov rdx, original_len
    syscall
    
    call display_array
    
    pop rbp
    ret

; ================================================================
; Function: display_sorted_array
; Displays the sorted array
; ================================================================
display_sorted_array:
    push rbp
    mov rbp, rsp
    
    ; Display message
    mov rax, 1
    mov rdi, 1
    mov rsi, sorted_msg
    mov rdx, sorted_len
    syscall
    
    call display_array
    
    ; Display final newline
    mov rax, 1
    mov rdi, 1
    mov rsi, newline_msg
    mov rdx, newline_len
    syscall
    
    pop rbp
    ret

; ================================================================
; Function: display_array
; Displays array elements separated by spaces
; ================================================================
display_array:
    push rbp
    mov rbp, rsp
    push rbx
    push rcx
    
    mov ebx, 0                      ; Element counter
    mov ecx, [array_size]           ; Total elements
    
.display_loop:
    cmp ebx, ecx
    jge .done
    
    ; Convert element to string and display
    mov eax, [array + ebx*4]
    call int_to_string
    mov rax, 1
    mov rdi, 1
    mov rsi, num_buffer
    mov rdx, rax
    syscall
    
    ; Display space (except after last element)
    inc ebx
    cmp ebx, ecx
    jge .done
    
    mov rax, 1
    mov rdi, 1
    mov rsi, space_msg
    mov rdx, space_len
    syscall
    
    jmp .display_loop
    
.done:
    pop rcx
    pop rbx
    pop rbp
    ret

; ================================================================
; Function: string_to_int
; Converts string to integer
; Input: rsi = string address
; Output: eax = integer value
; ================================================================
string_to_int:
    push rbp
    mov rbp, rsp
    push rbx
    push rcx
    push rdx
    
    xor eax, eax                    ; Result = 0
    xor ebx, ebx                    ; Digit value
    mov ecx, 10                     ; Base 10
    
.convert_loop:
    movzx ebx, byte [rsi]
    cmp bl, '0'
    jl .done
    cmp bl, '9'
    jg .done
    
    sub bl, '0'                     ; Convert ASCII to digit
    mul ecx                         ; Result *= 10
    add eax, ebx                    ; Result += digit
    
    inc rsi
    jmp .convert_loop
    
.done:
    pop rdx
    pop rcx
    pop rbx
    pop rbp
    ret

; ================================================================
; Function: int_to_string
; Converts integer to string
; Input: eax = integer value
; Output: rax = string length, num_buffer = string
; ================================================================
int_to_string:
    push rbp
    mov rbp, rsp
    push rbx
    push rcx
    push rdx
    
    mov ebx, 10                     ; Base 10
    mov rcx, num_buffer + 11        ; End of buffer
    mov byte [rcx], 0               ; Null terminator
    dec rcx
    
    cmp eax, 0
    jne .convert_loop
    
    ; Handle zero case
    mov byte [rcx], '0'
    dec rcx
    jmp .done
    
.convert_loop:
    cmp eax, 0
    je .done
    
    xor edx, edx
    div ebx                         ; eax = quotient, edx = remainder
    add dl, '0'                     ; Convert digit to ASCII
    mov [rcx], dl
    dec rcx
    jmp .convert_loop
    
.done:
    inc rcx                         ; Point to first character
    mov rsi, rcx                    ; String start
    mov rax, num_buffer + 11
    sub rax, rcx                    ; String length
    mov rdi, num_buffer
    
    ; Copy string to beginning of buffer
.copy_loop:
    cmp rax, 0
    jle .copy_done
    mov bl, [rsi]
    mov [rdi], bl
    inc rsi
    inc rdi
    dec rax
    jmp .copy_loop
    
.copy_done:
    mov rax, num_buffer + 11
    sub rax, rcx                    ; Return string length
    
    pop rdx
    pop rcx
    pop rbx
    pop rbp
    ret