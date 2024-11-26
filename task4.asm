section .data
    ; Status Messages
    high_msg db "WARNING: Water level too high! Alarm activated!", 10
    high_len equ $ - high_msg
    
    mod_msg db "Water level moderate. Motor stopped.", 10
    mod_len equ $ - mod_msg
    
    low_msg db "Water level low. Motor activated.", 10
    low_len equ $ - low_msg

    ; Level thresholds
    HIGH_LEVEL equ 80   ; 80% capacity
    LOW_LEVEL equ 20    ; 20% capacity

section .bss
    ; === Memory Location Documentation ===
    ; sensor_value: Simulates water level sensor input (0-100)
    ; - Values represent percentage of tank capacity
    ; - Updated by external sensor reading (simulated)
    sensor_value resb 1
    
    ; control_register: Simulates control outputs
    ; - Bit 0: Motor status (1 = ON, 0 = OFF)
    ; - Bit 1: Alarm status (1 = ON, 0 = OFF)
    control_register resb 1

section .text
    global _start

_start:
    ; Simulate reading sensor value (for testing, set to 90%)
    mov byte [sensor_value], 20
    
    ; === CONTROL LOGIC IMPLEMENTATION ===
    ; Clear control register initially
    mov byte [control_register], 0
    
    ; Read sensor value
    movzx rax, byte [sensor_value]
    
    ; === THRESHOLD CHECKING ===
    ; First check if water level is too high
    cmp al, HIGH_LEVEL
    jg high_water_level
    
    ; Then check if water level is too low
    cmp al, LOW_LEVEL
    jl low_water_level
    
    ; If neither, it's moderate level
    jmp moderate_water_level

high_water_level:
    ; === HIGH WATER LEVEL RESPONSE ===
    ; Documentation: When water level > 80%
    ; Actions: 
    ; 1. Turn OFF motor (clear bit 0)
    ; 2. Turn ON alarm (set bit 1)
    mov byte [control_register], 0b00000010
    
    ; Print warning message
    mov rax, 1
    mov rdi, 1
    mov rsi, high_msg
    mov rdx, high_len
    syscall
    jmp monitor_loop

moderate_water_level:
    ; === MODERATE WATER LEVEL RESPONSE ===
    ; Documentation: When 20% <= water level <= 80%
    ; Actions:
    ; 1. Turn OFF motor (clear bit 0)
    ; 2. Turn OFF alarm (clear bit 1)
    mov byte [control_register], 0
    
    ; Print status message
    mov rax, 1
    mov rdi, 1
    mov rsi, mod_msg
    mov rdx, mod_len
    syscall
    jmp monitor_loop

low_water_level:
    ; === LOW WATER LEVEL RESPONSE ===
    ; Documentation: When water level < 20%
    ; Actions:
    ; 1. Turn ON motor (set bit 0)
    ; 2. Turn OFF alarm (clear bit 1)
    mov byte [control_register], 0b00000001
    
    ; Print status message
    mov rax, 1
    mov rdi, 1
    mov rsi, low_msg
    mov rdx, low_len
    syscall

monitor_loop:
    ; In a real system, this would continuously monitor
    ; For simulation, we'll just exit
    mov rax, 60
    xor rdi, rdi
    syscall