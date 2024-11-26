section .data
    prompt_msg db "Enter a number: ", 0
    prompt_len equ $ - prompt_msg
    
    pos_msg db "POSITIVE", 10    ; 10 is newline
    pos_len equ $ - pos_msg
    
    neg_msg db "NEGATIVE", 10
    neg_len equ $ - neg_msg
    
    zero_msg db "ZERO", 10
    zero_len equ $ - zero_msg

section .bss
    num resb 6    ; Reserve 6 bytes for input (5 digits + sign)

section .text
    global _start

_start:
    ; === Input/Output Operations ===
    ; Display prompt message
    mov rax, 1          ; sys_write system call
    mov rdi, 1          ; file descriptor (stdout)
    mov rsi, prompt_msg ; message to write
    mov rdx, prompt_len ; message length
    syscall

    ; Read user input
    mov rax, 0          ; sys_read system call
    mov rdi, 0          ; file descriptor (stdin)
    mov rsi, num        ; buffer to store input
    mov rdx, 6          ; maximum bytes to read
    syscall

    ; === Number Classification Logic ===
    mov al, [num]       ; Load first character
    
    ; === CONDITIONAL JUMP #1: Check for negative sign ===
    ; Purpose: Detect negative numbers by checking for '-' symbol
    ; Impact: If '-' is found, jumps to check_negative to verify it's a valid negative number
    cmp al, '-'
    je check_negative   
    
    ; === CONDITIONAL JUMP #2: Check for zero ===
    ; Purpose: Identify zero input specifically
    cmp al, '0'
    je print_zero      
    
    ; === UNCONDITIONAL JUMP #1: Handle positive case ===
    ; Purpose: If no negative sign or zero detected, must be positive
    jmp print_positive

check_negative:
    ; === CONDITIONAL JUMP #3: Validate negative number ===
    ; Purpose: Distinguish between lone '-' and actual negative number
    mov al, [num + 1]
    cmp al, 0x0A
    je print_zero
    jmp print_negative

print_positive:
    mov rax, 1
    mov rdi, 1
    mov rsi, pos_msg
    mov rdx, pos_len
    syscall
    jmp exit

print_negative:
    mov rax, 1
    mov rdi, 1
    mov rsi, neg_msg
    mov rdx, neg_len
    syscall
    jmp exit

print_zero:
    mov rax, 1
    mov rdi, 1
    mov rsi, zero_msg
    mov rdx, zero_len
    syscall

exit:
    mov rax, 60         ; sys_exit system call
    xor rdi, rdi        ; return 0
    syscall