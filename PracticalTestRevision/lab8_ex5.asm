bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit, fopen, fclose, fprintf              
import exit msvcrt.dll    
import fopen msvcrt.dll
import fprintf msvcrt.dll
import fclose msvcrt.dll


; our data is declared here (the variables needed by our program)
segment data use32 class=data
    a dd 23
    b dd 10
    quotient dd 0
    remainder dd 0
    fileoutput db "output.txt", 0
    format db "%d", 0
    fd dd -1
    access_mode_w db "w", 0
    message_q db "quotient = ", 0
    message_r db "remainder = ", 0
    empty_line_format db 10, 0
    
    

; our code starts here
segment code use32 class=code
    start:
        ; Two natural number a and b are given (defined in the data segment, dwords). Calculate a/b and display the quotient and the remainder in the following format:
        ; quotient = <quotient> remainder = <remainder>. The values will be displayed in decimal form with sign.
        
        
        ;open file 
        push dword access_mode_w 
        push dword fileoutput
        call [fopen]
        add esp, 4 * 2
        
        mov [fd], eax
        
        cmp eax, 0
        je final
        
        ;divide a/b with sign 
        mov eax, [a]
        cdq
        mov ebx, [b]
        idiv ebx
        
        ;move the quotient and the remainder in the variables
        mov [quotient], eax
        mov [remainder], edx
        
        
        ;print the quotient
        push dword message_q
        push dword [fd]
        call [fprintf]
        add esp, 4 * 2
        
        push dword [quotient]
        push dword format
        push dword [fd]
        call [fprintf]
        add esp, 4 * 3
        
        ;print empty line
        push dword empty_line_format
        push dword [fd]
        call [fprintf]
        add esp, 4 * 2
        
        ;print the remainder
        push dword message_r
        push dword [fd]
        call [fprintf]
        add esp, 4 * 2
        
        push dword [remainder]
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
