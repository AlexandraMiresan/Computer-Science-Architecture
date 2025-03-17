bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit, fopen, fclose, scanf, fprintf, printf               
import exit msvcrt.dll 
import fopen msvcrt.dll
import fclose msvcrt.dll
import scanf msvcrt.dll
import fprintf msvcrt.dll
import printf msvcrt.dll   
; our data is declared here (the variables needed by our program)
segment data use32 class=data
    a dd 0
    b dd 0
    k dd 2
    fileoutput db "output.txt", 0
    access_mode_w db "w", 0
    fd dd -1
    format db "%d", 0
    message_a db "a=", 0
    message_b db "b=", 0
    result dq 0
    cf_char resb 0
    high_part dd 0
    low_part dd 0
    counter dd 0
    empty_line_format db 10,0
; our code starts here
segment code use32 class=code
    start:
        ; Two numbers a and b are given. Compute the expression value: (a/b)*k, where k is a constant value defined in data segment. Display the expression value(in base2).
        
        push dword access_mode_w
        push dword fileoutput
        call [fopen]
        add esp, 4 * 2
        
        mov [fd], eax
        
        cmp eax, 0
        je final
        
        ;ask for value of a
        push dword message_a
        call [printf]
        add esp, 4
         
        ;read value of a from keyboard 
        push dword a
        push dword format
        call [scanf]
        add esp, 4 * 2
        
        
        ;ask for value of b
        push dword message_b
        call [printf]
        add esp, 4
        
        
        ;read value of b from keyboard
        push dword b
        push dword format
        call [scanf]
        add esp, 4 * 2
        
        mov eax, [a]
        cdq
        
        mov ebx, [b]
        idiv ebx
        
        mov ecx, [k]
        imul ecx
        
        clc
        mov ebx, eax
        
        
        print_high_part:
            rcl ebx, 1
            mov ecx, 0
            jnc print_2
            mov ecx, 1
        print_2:
            cmp ebx, eax
            je stop
            cmp ecx, 0
            je set_flag_0
            cmp ecx, 1
            je set_flag_1
        set_flag_0:
            clc
            jmp continue
        set_flag_1:
            stc
        continue:
            mov [high_part], ecx
            push dword [high_part]
            push dword format
            push dword [fd]
            call [fprintf]
            add esp, 4 * 3
            jmp print_high_part
            
        stop:   
            
        
            
        ; mov ecx, 0
        ; jnc print
        ; mov ecx, 1
        ; print:
            ; mov [high_part], ecx
            ; push dword [high_part]
            ; push dword format
            ; push dword [fd]
            ; call [fprintf]
            ; add esp, 4 * 3
            
        
        
        ; clc
        ; mov ebx, eax
        ; print_low_part:
            ; rcl ebx, 1
            ; mov ecx, 0
            ; jnc print_1
            ; mov ecx, 1
        ; print_1:
            ; mov [low_part], ecx
            ; push dword [low_part]
            ; push dword format
            ; push dword [fd]
            ; call [fprintf]
            ; add esp, 4 * 3
            ; cmp ebx, eax
            ; jne print_low_part
            
        ; push dword [empty_line_format]
        ; push dword [fd]
        ; call [fprintf]
        ; add esp, 4 * 2
        
        ; mov ecx, 0
        ; jnc print_3
        ; mov ecx, 1
        ; print_3:
            ; mov [high_part], ecx
            ; push dword [high_part]
            ; push dword format
            ; push dword [fd]
            ; call [fprintf]
            ; add esp, 4 * 3
        
        
            
        
        ; print_high_part:
            ; mov ecx, 0
            ; test eax, 1
            ; jz print_1
            ; inc ecx
        ; print_1:
            ; mov [counter], ecx                                                                                                        
            ; push dword [counter]
            ; push dword format
            ; push dword [fd]
            ; call [fprintf]
            ; add esp, 4 * 3
        ; shift_number1:
            ; shr eax, 1
            ; jnz print_high_part
        
        ; mov eax, edx
        ; print_low_part:
            ; mov ecx, 0
            ; test eax, 1
            ; jz print_2
            ; inc ecx
        ; print_2:
            ; mov [counter], ecx
            ; push dword [counter]
            ; push dword format
            ; push dword [fd]
            ; call [fprintf]
            ; add esp, 4 * 3
        ; shift_number2:
            ; shr eax, 1
            ; jnz print_low_part
        
        push dword [fd]
        call [fclose]
        add esp, 4
        
        final:
        
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
