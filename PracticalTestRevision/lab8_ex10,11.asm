bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit, fopen, fclose, fprintf, scanf, printf               
import exit msvcrt.dll    
import fopen msvcrt.dll
import fprintf msvcrt.dll
import scanf msvcrt.dll
import fclose msvcrt.dll
import printf msvcrt.dll

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    base10 dd 0
    base16 dd 0
    fd dd -1
    access_mode_w db "w", 0
    format_16 db "%x", 0
    format_10 db "%d", 0
    empty_line_format db 10, 0
    fileoutput db "output.txt", 0
    message_base10 db "Enter a number in base 10 = ", 0
    message_base16 db "Enter a number in base 16 = ", 0
    print_base10 db "The number in base 10 is = ", 0
    print_base16 db "The number in base 16 is = ", 0

; our code starts here
segment code use32 class=code
    start:
        ; Read a number in base 10 from keyboard and display the value in base 16
        ; Read a number in base 16 from keyboard and display the value in base 10
        
        
        ;open the file
        push dword access_mode_w
        push dword fileoutput 
        call [fopen]
        add esp, 4 * 2
        
        mov [fd], eax
        
        cmp eax, 0
        je final
        
        ; ask for a number in base 10
        push dword message_base10
        call [printf]
        add esp, 4 
        
        ; read number in base 10 from keyboard
        push dword base10
        push dword format_10 
        call [scanf]
        add esp, 4 * 2
        
        
        ;ask for number in base 16
        push dword message_base16
        call [printf]
        add esp, 4
        
        ;read number in base 16 from keyboard
        push dword base16 
        push dword format_16
        call [scanf]
        add esp, 4 * 2
        
        ;print the number from base 10 in base 16
        push dword print_base16
        push dword [fd]
        call[fprintf]
        add esp, 4 * 2
        
        push dword [base10]
        push dword format_16
        push dword [fd]
        call [fprintf]
        add esp, 4 * 3
        
        ;print empty line
        push dword empty_line_format
        push dword [fd]
        call [fprintf]
        add esp, 4 * 2
        
        ;print the number from base 16 in base 10
        push dword print_base10
        push dword [fd]
        call[fprintf]
        add esp, 4 * 2
        
        push dword [base16]
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
