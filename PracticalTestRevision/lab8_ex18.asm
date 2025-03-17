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
    format_10 db "%d", 0
    format_16 db "%x", 0
    access_mode_w db "w", 0
    fd dd -1
    fileoutput db "output.txt", 0
    message_a db "number in base 10 = ", 0
    message_b db "number in base 16 = ", 0
    bit_counter dd 0

; our code starts here
segment code use32 class=code
    start:
        ; Read a decimal number and a hexadecimal number from keyboard. Display the number of 1's of the sum of the two numbers in decimal format.
        
        
        ;open the file
        push dword access_mode_w 
        push dword fileoutput
        call [fopen]
        add esp, 4 * 2
        
        mov [fd], eax
        
        cmp eax, 0 
        je final
        
        ;ask for number in base 10
        push dword message_a
        call[printf]
        add esp, 4
        
        ;read from keyboard number in base 10
        push dword a
        push dword format_10
        call [scanf]
        
        ;ask for number in base 16
        push dword message_b
        call [printf]
        add esp, 4
        
        ;read from keyboard number in base 16
        push dword b
        push dword format_16
        call [scanf]
        add esp, 4 * 2
        
        ;add the two numbers
        mov eax, [a]
        add eax, [b]
        
        ;use ecx as counter
        mov ecx, 0
        
        ;compare the last bit with one and increment ecx if 1
        count_ones:
            test eax, 1
            jz skip_increment
            inc ecx
        ; if last bit is not 1, skip the incrementation of ecx    
        skip_increment:
            ;shr the number so that the next bit is on the last position
            shr eax, 1
            ;when the number in eax becomes zero the loop stops
            jnz count_ones
        
        ;move the number of bits in variable
        mov [bit_counter], ecx
        
        ;print the number of bits
        push dword [bit_counter]
        push dword format_10
        push dword [fd]
        call [fprintf]
        add esp, 4 * 3
        
        ;close the file
        push dword [fd]
        call [fclose]
        add esp, 4
        
        final:
        
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
