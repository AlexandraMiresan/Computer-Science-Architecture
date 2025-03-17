bits 32
global start        
;16. Se citesc nr din fisier, se face suma nr mai mici decat 8 si se afiseaza pe ecran.

extern exit, scanf, printf, fopen, fclose, fread,fscanf
import exit msvcrt.dll
import scanf msvcrt.dll
import printf msvcrt.dll
import fopen msvcrt.dll
import fclose msvcrt.dll
import fread msvcrt.dll
import fscanf msvcrt.dll

segment data use32 class=data
    access_mode_read db "r",0
    file_input db "input.txt", 0
    file_handle_input dd 0
    number_format db "%d", 0
    sum dd 0
    number dd 0

segment code use32 class=code
start:
    
    push dword access_mode_read
    push dword file_input
    call [fopen]
    add esp, 8

    mov [file_handle_input], eax  
    
    mov eax, 0         ; Initializam suma la 0
    
read_loop:
    ; Citim un numar din fisier
    push dword number
    push dword number_format
    push dword [file_handle_input]
    call [fscanf]
    add esp, 12
    
    ; Verificam daca citirea a fost cu succes (retur > 0 indica succes)
    cmp eax, 1
    jl end_reading
    
    
    mov eax, [number]
    cmp eax, 8
    jge skip_addition   
    
    
    add [sum], eax
    
skip_addition:
    jmp read_loop

end_reading:

    
    push dword [sum]
    push dword number_format
    call [printf]
    add esp, 8

    push dword 0
    call [exit]