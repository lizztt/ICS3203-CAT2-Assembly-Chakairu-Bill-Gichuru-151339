section .data
    prompt_msg db "Enter 5 integers (press ENTER after each): ", 10
    prompt_len equ $ - prompt_msg
    
    output_msg db "Reversed array: ", 10
    output_len equ $ - output_msg
    
    space db " "
    newline db 10

section .bss
    input_buffer resb 6     ; Buffer for string input
    array resd 5            ; Reserve 5 4-byte integers
    number_string resb 12   ; Buffer for number to string conversion

section .text
    global _start

_start:
    ; Print prompt
    mov rax, 1
    mov rdi, 1
    mov rsi, prompt_msg
    mov rdx, prompt_len
    syscall

    ; Initialize array index in r12
    xor r12, r12

input_loop:
    ; Read integer input
    mov rax, 0
    mov rdi, 0
    mov rsi, input_buffer
    mov rdx, 6
    syscall

    ; Convert ASCII string to integer
    xor rax, rax    ; Clear accumulator
    mov rcx, 0      ; String index
    
convert_loop:
    movzx rdx, byte [input_buffer + rcx]   ; Get current character
    cmp dl, 10                             ; Check for newline
    je store_number                        ; If newline, store number
    cmp dl, '0'                           ; Check if less than '0'
    jl convert_loop                       ; Skip if not a digit
    cmp dl, '9'                           ; Check if more than '9'
    jg convert_loop                       ; Skip if not a digit
    
    sub dl, '0'                           ; Convert ASCII to number
    imul rax, 10                          ; Multiply current result by 10
    add rax, rdx                          ; Add new digit
    inc rcx                               ; Move to next character
    jmp convert_loop

store_number:
    mov [array + r12*4], eax              ; Store in array
    
    ; Increment counter and continue if not done
    inc r12
    cmp r12, 5
    jl input_loop

    ; Reverse the array
    mov r13, 0          ; left index
    mov r14, 4          ; right index (5-1)

reverse_loop:
    ; Check if we're done
    cmp r13, r14
    jge print_result

    ; Swap elements
    mov eax, [array + r13*4]     ; Load left element
    mov ebx, [array + r14*4]     ; Load right element
    mov [array + r13*4], ebx     ; Store right element in left position
    mov [array + r14*4], eax     ; Store left element in right position

    ; Update indices
    inc r13
    dec r14
    jmp reverse_loop

print_result:
    ; Print output message
    mov rax, 1
    mov rdi, 1
    mov rsi, output_msg
    mov rdx, output_len
    syscall

    ; Initialize print loop counter
    xor r12, r12

print_loop:
    ; Convert integer to string
    mov eax, [array + r12*4]    ; Load number to convert
    xor rcx, rcx                ; Clear digit counter
    mov rdi, number_string      ; Point to end of string buffer
    add rdi, 11                 ; Move to end (leave room for null)
    mov byte [rdi], 0           ; Null terminate string
    
    ; Handle zero case
    test eax, eax
    jnz .convert
    dec rdi
    mov byte [rdi], '0'
    jmp .print_number
    
.convert:
    ; Convert number to string
    mov ebx, 10                 ; Divisor
.convert_loop:
    xor edx, edx               ; Clear upper bits before divide
    div ebx                    ; Divide by 10
    add dl, '0'                ; Convert remainder to ASCII
    dec rdi                    ; Move back one position
    mov [rdi], dl              ; Store digit
    test eax, eax              ; Check if more digits
    jnz .convert_loop          ; Continue if more digits

.print_number:
    ; Calculate string length
    mov rdx, number_string
    add rdx, 11
    sub rdx, rdi               ; Length is end - current position
    
    ; Print the number
    mov rax, 1
    mov rsi, rdi               ; Source is current position
    mov rdi, 1
    syscall

    ; Print space (except after last number)
    cmp r12, 4
    je skip_space
    mov rax, 1
    mov rdi, 1
    mov rsi, space
    mov rdx, 1
    syscall

skip_space:
    ; Increment counter and continue if not done
    inc r12
    cmp r12, 5
    jl print_loop

    ; Print newline
    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, 1
    syscall

    ; Exit program
    mov rax, 60
    xor rdi, rdi
    syscall