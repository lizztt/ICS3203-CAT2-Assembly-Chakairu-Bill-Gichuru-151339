section .data
    prompt_msg db "Enter a number (0-12): ", 0
    prompt_len equ $ - prompt_msg
    
    result_msg db "Factorial: ", 0
    result_len equ $ - result_msg
    
    newline db 10

section .bss
    buffer resb 4       ; Moving buffer to .bss section for uninitialized data

section .text
    global _start

_start:
    ; Print prompt
    mov rax, 1
    mov rdi, 1
    mov rsi, prompt_msg
    mov rdx, prompt_len
    syscall

    ; Read input
    mov rax, 0          ; sys_read
    mov rdi, 0          ; stdin
    mov rsi, buffer
    mov rdx, 4          ; max 3 digits + newline
    syscall

    ; Convert string to number
    mov rcx, 0          ; counter
    xor rax, rax        ; will hold our number
    
convert_loop:
    movzx rdx, byte [buffer + rcx]   ; get current char
    cmp dl, 10                       ; check for newline
    je calculate_factorial
    sub dl, '0'                      ; convert ASCII to number
    imul rax, 10                     ; multiply current number by 10
    add rax, rdx                     ; add new digit
    inc rcx
    jmp convert_loop

calculate_factorial:
    ; Call factorial subroutine
    ; Note: Input number is already in RAX
    call factorial      ; Result will be in RAX

    ; Convert result to string for printing
    mov rdi, buffer
    call number_to_string

    ; Print "Factorial: "
    mov rax, 1
    mov rdi, 1
    mov rsi, result_msg
    mov rdx, result_len
    syscall

    ; Print result
    mov rax, 1
    mov rdi, 1
    mov rsi, buffer
    mov rdx, 20        ; Enough space for the result
    syscall

    ; Print newline
    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, 1
    syscall

    ; Exit
    mov rax, 60
    xor rdi, rdi
    syscall

factorial:
    ; === Subroutine: Calculate Factorial ===
    ; Input: RAX = number to calculate factorial for
    ; Output: RAX = factorial result
    ; Preserves: All registers except RAX
    
    ; Save registers we'll use
    push rbx
    push rcx
    push rdx

    mov rcx, rax        ; Counter
    mov rbx, 1          ; Result accumulator

    ; Handle special case of 0!
    test rax, rax
    jz factorial_done

factorial_loop:
    mov rax, rbx        ; Get current result
    mul rcx             ; Multiply by current counter
    mov rbx, rax        ; Store back in accumulator
    dec rcx             ; Decrement counter
    cmp rcx, 1          ; Check if we're done
    jg factorial_loop   ; If counter > 1, continue

factorial_done:
    mov rax, rbx        ; Put result in RAX

    ; Restore registers
    pop rdx
    pop rcx
    pop rbx
    ret

number_to_string:
    ; === Subroutine: Convert Number to String ===
    ; Input: RAX = number to convert, RDI = buffer
    ; Preserves: All registers except RAX
    push rbx
    push rcx
    push rdx
    push rdi

    mov rbx, 10         ; Divisor
    mov rcx, 0          ; Length counter
    
    ; Handle special case of 0
    test rax, rax
    jnz convert_start
    mov byte [rdi], '0'
    mov byte [rdi + 1], 0
    jmp convert_end

convert_start:
    ; First, get digits in reverse order
convert_digit:
    xor rdx, rdx        ; Clear upper part of division
    div rbx             ; Divide by 10
    add dl, '0'         ; Convert remainder to ASCII
    push rdx            ; Save digit on stack
    inc rcx             ; Increment length counter
    test rax, rax       ; Check if we have more digits
    jnz convert_digit

    ; Now pop digits in correct order
    mov rdx, 0          ; String position counter
store_digit:
    pop rax             ; Get digit from stack
    mov [rdi + rdx], al ; Store in buffer
    inc rdx
    loop store_digit    ; Continue until rcx = 0

    mov byte [rdi + rdx], 0  ; Null terminate string

convert_end:
    pop rdi
    pop rdx
    pop rcx
    pop rbx
    ret