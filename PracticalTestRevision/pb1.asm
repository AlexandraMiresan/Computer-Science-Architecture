bits 32 ; assembling for the 32 bits architecture

declare the EntryPoint (a label defining the very first instruction of the program)
global start        

declare external functions needed by our program
extern exit, fopen, fclose, printf, fread              
import exit msvcrt.dll    
import fopen msvcrt.dll
import fclose msvcrt.dll
import printf msvcrt.dll
import fread msvcrt.dll
our data is declared here (the variables needed by our program)

segment data use32 class=data
    fileinput db "input.txt", 0
    fd dd -1
    format db "%d", 0
    access_mode_r db "r", 0
    numbers times 200 db 0
    smallest_digit db 0
    number_of_characters dd 0
; our code starts here
segment code use32 class=code
    start:
        ; Se da un sir de 10 numere in baza 16 in fisierul input.txt. Sa se determine cifra minima din fiecare numar. Sa se afiseze acest sir al cifrelor minime, in baza 10, pe ecran.
        
        push dword access_mode_r
        push dword fileinput
        call [fopen]
        add esp, 4 * 2
        
        mov [fd], eax
        
        cmp eax, 0
        je final
        
        push dword 200
        push dword numbers
        push dword [fd]
        call [fread]
        add esp, 4 * 3
        
        mov [number_of_characters], eax
        
        ; mov bl, 0Fh
        ; mov ecx, [number_of_characters]
        ; mov esi, numbers
        ; jecxz end_loop
        ; search_for_smallest_digit:
            ; lodsb
            
            ; cmp al, ' '
            ; je new_number
            
            ; cmp al, '9'
            ; ja not_number
            ; sub al, '0'
            ; jmp continue
            ; not_number:
            ; sub al, 'A'
            ; add al, 10
            
            ; cmp al, bl
            ; jnl continue
            ; mov bl, al
            ; jmp continue
            ; new_number:
                ; mov [smallest_digit], bl
                ; push dword [smallest_digit]
                ; push dword format
                ; call [printf]
                ; add esp, 4 * 2
                ; mov bl, 0Fh
                ; jmp search_for_smallest_digit
            ; continue:
        
        ; loop search_for_smallest_digit
        ; end_loop:
        
        
    
        
        
        ; process_number:
            ; mov bl, 0Fh
        ; find_min:
            ; lodsb
            ; cmp al, ' '
            ; je print_smallest_number
            ; cmp al, bl
            ; jnl skip
            ; mov bl, al
            ; mov [smallest_digit], bl
            ; skip:
        ; loop find_min
        ; print_smallest_number:
            ; push dword [smallest_digit]
            ; call [printf]
            ; add esp, 4
            
            ; jmp process_number
        ; end_loop:   
        
        
        final:
        
     
            
            
        
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
