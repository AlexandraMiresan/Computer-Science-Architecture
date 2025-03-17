bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit, scanf, printf               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll
import printf msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
import scanf msvcrt.dll                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    n db 0
    format db "%x", 0
    format_print_signed db "the number in signed representation is %d", 0
    format_print_unsigned db "the number in unsigned representation is %d ,", 0
    

; our code starts here
segment code use32 class=code
    start:
        ; ...
        push dword n
        push dword format 
        call [scanf]
        add esp, 4 * 2
        
        push dword [n]
        push dword format_print_unsigned
        call [printf]
        add esp, 8
        
        movsx eax, byte[n]
        push eax
        push dword format_print_signed
        call [printf]
        add esp, 4 * 2
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
