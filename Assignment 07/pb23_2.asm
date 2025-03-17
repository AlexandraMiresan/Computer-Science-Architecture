bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit, scanf, printf, fopen, fclose, fprintf             ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll
import scanf msvcrt.dll
import printf msvcrt.dll
import fopen msvcrt.dll
import fclose msvcrt.dll
import fprintf msvcrt.dll

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    hexa dw 0
    format_read_hexa db "Please enter a number = ", 0
    read_number db "%x", 0
    file_name db "output.txt", 0
    acces_mode_write db "w", 0
    file_descriptor dd -1
    format_write db "%X ", 0ah, 0
    to_print dd 0
    
; our code starts here
segment code use32 class=code
    start:
        
        push dword format_read_hexa
        call [printf]
        add esp, 4
        
        push dword hexa
        push dword read_number
        call [scanf]
        add esp, 8
        
        push dword acces_mode_write
        push dword file_name    
        call [fopen]
        add esp, 8
        
        mov [file_descriptor], eax
        
        cmp eax, 0
        je final
        
        mov cx, [hexa]
        and cx, 0F000h
        shr cx, 12
        
        mov ebx, 0
        mov bx, cx
        mov [to_print], ebx
        push dword [to_print]
        push dword format_write
        push dword [file_descriptor]
        call [fprintf]
        add esp, 8
      
        
        mov cx, [hexa]
        and cx, 0F00h
        shr cx, 8
        
        mov ebx, 0
        mov bx, cx
        mov [to_print], ebx
        push dword [to_print]
        push dword format_write
        push dword [file_descriptor]
        call [fprintf]
        add esp, 8
        
        mov cx, [hexa]
        and cx, 0F0h
        shr cx, 4
        
        mov ebx, 0
        mov bx, cx
        mov [to_print], ebx
        push dword [to_print]
        push dword format_write
        push dword [file_descriptor]
        call [fprintf]
        add esp, 8
        
        
        mov cx, [hexa]
        and cx, 0Fh
        
        mov ebx, 0
        mov bx, cx
        
        ; push ebx
        ; push dword format_write
        ; call [printf]
        ; add esp, 8
        
        mov [to_print], ebx
        push dword [to_print]
        push dword format_write
        push dword [file_descriptor]
        call [fprintf]
        add esp, 8
        
        push dword [file_descriptor]
        call [fclose]
        add esp, 4
        
        final:
        
        
       
        
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
