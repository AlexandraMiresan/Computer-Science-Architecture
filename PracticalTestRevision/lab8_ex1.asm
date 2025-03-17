bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

extern exit, fopen, fread, fclose, fprintf, scanf, printf               
import exit msvcrt.dll    
import fopen msvcrt.dll
import fclose msvcrt.dll
import fprintf msvcrt.dll
import scanf msvcrt.dll
import printf msvcrt.dll
import fread msvcrt.dll

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    a dd 0
    b dd 0
    result dd 0
    fileoutput db "output.txt", 0
    access_mode_r db "r", 0
    access_mode_w db "w", 0
    format db "%d", 0
    message_a db "a=", 0
    message_b db "b=", 0
    fd dd 0
    

; our code starts here
segment code use32 class=code
    start:
        ; Read two numbers a and b (in base 10) from the keyboard and calculate their product. 
        ; This value will be stored in a variable called "result" (defined in the data segment)
        
        ;open the file
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
        
        ;make the addition of a and b
        mov ebx, [a]
        add ebx, [b]
        
        ;store the result in the variable
        mov [result], ebx
        
        ;print the result
        push dword [result]
        push dword format
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
