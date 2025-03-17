bits 32
global start        
;18. citim un text din input.txt si afisam invers

extern exit, fread,fprintf, fclose, fopen
import exit msvcrt.dll    
import fread msvcrt.dll
import fprintf msvcrt.dll
import fclose msvcrt.dll
import fopen msvcrt.dll


segment data use32 class=data
    access_mode_read db "r",0
    access_mode_write db "w", 0
    file_input db "input.txt", 0
    file_output db "output.txt", 0
    file_handle_input dd 0
    file_handle_output dd 0
    format db "%d",10, 0
    string_format db "%s",10, 0
    text times 200 db 0
    reversed_text times 200 db 0
    number_ch dd 0
    
segment code use32 class=code
start:
    push dword access_mode_read
    push dword file_input
    call [fopen]
    add esp, 8
    
    mov [file_handle_input], EAX
    
    push dword access_mode_write
    push dword file_output
    call [fopen]
    add esp, 8
    
    mov [file_handle_output], EAX
    
    push dword[file_handle_input]
    push dword 200
    push dword 1
    push dword text
    call [fread]
    add esp, 16
    
    mov [number_ch],EAX
    
    mov ecx, [number_ch]
    lea esi, [text+ecx-1]
    mov edi, reversed_text
    
    jecxz end_loop
        reverse:
            mov al,[esi]
            dec esi
            mov [edi], al
            inc edi
            
        loop reverse
        end_loop:
    
    
    push dword reversed_text
    push dword string_format
    push dword [file_handle_output]
    call [fprintf]
    add esp, 12
    
    push    dword 0      ; push the parameter for exit onto the stack
    call    [exit]