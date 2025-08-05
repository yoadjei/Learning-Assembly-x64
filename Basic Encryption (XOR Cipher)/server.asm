; Basic Encryption (XOR Cipher)
; Implements a simple XOR-based encryption/decryption
; Platform: Linux x86_64, NASM

section .data
    ; Messages
    title_msg db "XOR Cipher - Encryption/Decryption Tool", 0x0A
              db "=========================================", 0x0A, 0
    title_len equ $ - title_msg
    
    mode_prompt db "Select mode:", 0x0A
                db "1) Encrypt", 0x0A
                db "2) Decrypt", 0x0A
                db "Enter choice (1 or 2): ", 0
    mode_len equ $ - mode_prompt
    
    text_prompt db "Enter text (max 255 chars): ", 0
    text_len equ $ - text_prompt
    
    key_prompt db "Enter encryption key (max 63 chars): ", 0
    key_len equ $ - key_prompt
    
    result_encrypt db "Encrypted (hex): ", 0
    result_encrypt_len equ $ - result_encrypt
    
    result_decrypt db "Decrypted text: ", 0
    result_decrypt_len equ $ - result_decrypt
    
    error_mode db "Error: Invalid mode! Please enter 1 or 2.", 0x0A, 0
    error_mode_len equ $ - error_mode
    
    error_empty db "Error: Text or key cannot be empty!", 0x0A, 0
    error_empty_len equ $ - error_empty
    
    newline db 0x0A, 0
    
    ; Hex characters for output
    hex_chars db "0123456789ABCDEF"

section .bss
    ; Input buffers
    mode_buffer resb 4
    text_buffer resb 256
    key_buffer resb 64
    
    ; Working buffers
    result_buffer resb 512     ; For encrypted hex output
    text_length resq 1
    key_length resq 1
    chosen_mode resq 1

section .text
    global _start

_start:
    ; Display title
    mov rax, 1              ; sys_write
    mov rdi, 1              ; stdout
    mov rsi, title_msg
    mov rdx, title_len
    syscall
    
    ; Get mode selection
    call get_mode
    cmp rax, -1
    je exit_error
    
    ; Get text input
    call get_text
    cmp rax, -1
    je exit_error
    
    ; Get encryption key
    call get_key
    cmp rax, -1
    je exit_error
    
    ; Perform encryption/decryption
    mov rax, [chosen_mode]
    cmp rax, 1
    je do_encrypt
    cmp rax, 2
    je do_decrypt
    
do_encrypt:
    call encrypt_text
    call display_encrypted
    jmp exit_success
    
do_decrypt:
    call decrypt_text
    call display_decrypted
    jmp exit_success

; Function: get_mode
; Gets user's choice for encrypt/decrypt
; Output: rax = 0 (success), -1 (error)
get_mode:
    push rbp
    mov rbp, rsp
    
    ; Display mode prompt
    mov rax, 1              ; sys_write
    mov rdi, 1              ; stdout
    mov rsi, mode_prompt
    mov rdx, mode_len
    syscall
    
    ; Read mode selection
    mov rax, 0              ; sys_read
    mov rdi, 0              ; stdin
    mov rsi, mode_buffer
    mov rdx, 4
    syscall
    
    ; Parse mode selection
    movzx rax, byte [mode_buffer]
    cmp rax, '1'
    je mode_encrypt
    cmp rax, '2'
    je mode_decrypt
    
    ; Invalid mode
    mov rax, 1              ; sys_write
    mov rdi, 1              ; stdout
    mov rsi, error_mode
    mov rdx, error_mode_len
    syscall
    mov rax, -1
    jmp get_mode_exit
    
mode_encrypt:
    mov qword [chosen_mode], 1
    mov rax, 0
    jmp get_mode_exit
    
mode_decrypt:
    mov qword [chosen_mode], 2
    mov rax, 0
    
get_mode_exit:
    pop rbp
    ret

; Function: get_text
; Gets text input from user
; Output: rax = 0 (success), -1 (error)
get_text:
    push rbp
    mov rbp, rsp
    
    ; Display text prompt
    mov rax, 1              ; sys_write
    mov rdi, 1              ; stdout
    mov rsi, text_prompt
    mov rdx, text_len
    syscall
    
    ; Read text input
    mov rax, 0              ; sys_read
    mov rdi, 0              ; stdin
    mov rsi, text_buffer
    mov rdx, 256
    syscall
    
    ; Store length (excluding newline)
    dec rax
    mov [text_length], rax
    
    ; Check for empty input
    test rax, rax
    jz text_empty_error
    
    mov rax, 0              ; Success
    jmp get_text_exit
    
text_empty_error:
    mov rax, 1              ; sys_write
    mov rdi, 1              ; stdout
    mov rsi, error_empty
    mov rdx, error_empty_len
    syscall
    mov rax, -1
    
get_text_exit:
    pop rbp
    ret

; Function: get_key
; Gets encryption key from user
; Output: rax = 0 (success), -1 (error)
get_key:
    push rbp
    mov rbp, rsp
    
    ; Display key prompt
    mov rax, 1              ; sys_write
    mov rdi, 1              ; stdout
    mov rsi, key_prompt
    mov rdx, key_len
    syscall
    
    ; Read key input
    mov rax, 0              ; sys_read
    mov rdi, 0              ; stdin
    mov rsi, key_buffer
    mov rdx, 64
    syscall
    
    ; Store length (excluding newline)
    dec rax
    mov [key_length], rax
    
    ; Check for empty input
    test rax, rax
    jz key_empty_error
    
    mov rax, 0              ; Success
    jmp get_key_exit
    
key_empty_error:
    mov rax, 1              ; sys_write
    mov rdi, 1              ; stdout
    mov rsi, error_empty
    mov rdx, error_empty_len
    syscall
    mov rax, -1
    
get_key_exit:
    pop rbp
    ret

; Function: encrypt_text
; Performs XOR encryption on text using key
encrypt_text:
    push rbp
    mov rbp, rsp
    push rsi
    push rdi
    push rcx
    push rdx
    push rbx
    
    ; Initialize pointers and counters
    mov rsi, text_buffer    ; Source text
    mov rdi, result_buffer  ; Destination buffer
    mov rcx, [text_length]  ; Text length
    xor rdx, rdx            ; Key index
    mov rbx, [key_length]   ; Key length
    
encrypt_loop:
    ; Check if done
    test rcx, rcx
    jz encrypt_done
    
    ; Get current character and key byte
    movzx rax, byte [rsi]
    movzx r8, byte [key_buffer + rdx]
    
    ; Perform XOR operation
    xor rax, r8
    
    ; Convert to hex and store
    mov r9, rax
    shr r9, 4               ; High nibble
    and r9, 0x0F
    movzx r9, byte [hex_chars + r9]
    mov [rdi], r9b
    inc rdi
    
    and rax, 0x0F           ; Low nibble
    movzx rax, byte [hex_chars + rax]
    mov [rdi], al
    inc rdi
    
    ; Move to next character
    inc rsi
    dec rcx
    
    ; Advance key index (with wraparound)
    inc rdx
    cmp rdx, rbx
    jl encrypt_loop
    xor rdx, rdx            ; Reset key index
    jmp encrypt_loop
    
encrypt_done:
    ; Null terminate result
    mov byte [rdi], 0
    
    pop rbx
    pop rdx
    pop rcx
    pop rdi
    pop rsi
    pop rbp
    ret

; Function: decrypt_text
; Performs XOR decryption (same as encryption due to XOR properties)
decrypt_text:
    push rbp
    mov rbp, rsp
    push rsi
    push rdi
    push rcx
    push rdx
    push rbx
    
    ; Initialize pointers and counters
    mov rsi, text_buffer    ; Source text
    mov rdi, result_buffer  ; Destination buffer
    mov rcx, [text_length]  ; Text length
    xor rdx, rdx            ; Key index
    mov rbx, [key_length]   ; Key length
    
decrypt_loop:
    ; Check if done
    test rcx, rcx
    jz decrypt_done
    
    ; Get current character and key byte
    movzx rax, byte [rsi]
    movzx r8, byte [key_buffer + rdx]
    
    ; Perform XOR operation (same as encryption)
    xor rax, r8
    
    ; Store decrypted character
    mov [rdi], al
    inc rdi
    
    ; Move to next character
    inc rsi
    dec rcx
    
    ; Advance key index (with wraparound)
    inc rdx
    cmp rdx, rbx
    jl decrypt_loop
    xor rdx, rdx            ; Reset key index
    jmp decrypt_loop
    
decrypt_done:
    ; Null terminate result
    mov byte [rdi], 0
    
    pop rbx
    pop rdx
    pop rcx
    pop rdi
    pop rsi
    pop rbp
    ret

; Function: display_encrypted
; Displays encrypted result in hexadecimal
display_encrypted:
    push rbp
    mov rbp, rsp
    
    ; Display result header
    mov rax, 1              ; sys_write
    mov rdi, 1              ; stdout
    mov rsi, result_encrypt
    mov rdx, result_encrypt_len
    syscall
    
    ; Calculate hex string length (2 * text_length)
    mov rcx, [text_length]
    shl rcx, 1              ; Multiply by 2
    
    ; Display hex result
    mov rax, 1              ; sys_write
    mov rdi, 1              ; stdout
    mov rsi, result_buffer
    mov rdx, rcx
    syscall
    
    ; Print newline
    mov rax, 1              ; sys_write
    mov rdi, 1              ; stdout
    mov rsi, newline
    mov rdx, 1
    syscall
    
    pop rbp
    ret

; Function: display_decrypted
; Displays decrypted text
display_decrypted:
    push rbp
    mov rbp, rsp
    
    ; Display result header
    mov rax, 1              ; sys_write
    mov rdi, 1              ; stdout
    mov rsi, result_decrypt
    mov rdx, result_decrypt_len
    syscall
    
    ; Display decrypted text
    mov rax, 1              ; sys_write
    mov rdi, 1              ; stdout
    mov rsi, result_buffer
    mov rdx, [text_length]
    syscall
    
    ; Print newline
    mov rax, 1              ; sys_write
    mov rdi, 1              ; stdout
    mov rsi, newline
    mov rdx, 1
    syscall
    
    pop rbp
    ret

exit_success:
    mov rax, 60             ; sys_exit
    mov rdi, 0              ; exit status
    syscall

exit_error:
    mov rax, 60             ; sys_exit
    mov rdi, 1              ; exit with error
    syscall