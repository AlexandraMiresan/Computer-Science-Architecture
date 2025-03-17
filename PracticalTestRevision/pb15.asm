bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit, scanf, fopen, fclose, fprintf, fread, printf              
import exit msvcrt.dll  
import scanf msvcrt.dll
import fopen msvcrt.dll
import fclose msvcrt.dll
import fprintf msvcrt.dll
import printf msvcrt.dll
import fread msvcrt.dll
; our data is declared here (the variables needed by our program)
segment data use32 class=data
    fileoutput times 31 db 0
    s times 200 db 0
    fd_r dd -1
    fd_a dd -1
    access_mode_r db "r", 0
    access_mode_a db "a", 0
    message_text_file db "text file = ", 0
    format_s db "%s", 0
    format_d db "%d", 0
    number_of_characters dd 0
    empty_line_format db 10, 0
; our code starts here
segment code use32 class=code
    start:
        ; Se citeste un nume de fisier de la tastatura, se deschide fisieru, numara cate caractere sunt in fisier, printeaza nr de caractere din fisier
        push dword message_text_file
        call [printf]
        add esp, 4
        
        push dword fileoutput
        push dword format_s
        call [scanf]
        add esp, 4 * 2
        
        push dword access_mode_a
        push dword fileoutput
        call [fopen]
        add esp, 4 * 2
        
        mov [fd_a], eax
        
        cmp eax, 0
        je final
        
        push dword access_mode_r
        push dword fileoutput
        call [fopen]
        add esp, 4 * 2
        
        mov [fd_r], eax
        
        cmp eax, 0
        je final
        
        push dword [fd_r]
        push dword 200
        push dword 1
        push dword s
        call [fread]
        add esp, 4 * 4
        
        mov [number_of_characters], eax
        
        push dword empty_line_format
        push dword [fd_a]
        call [fprintf]
        add esp, 4 * 2
        
        push dword [number_of_characters]
        push dword format_d
        push dword [fd_a]
        call [fprintf]
        add esp, 4 * 3
        
        push dword [fd_a]
        call [fclose]
        add esp, 4
        
        push dword [fd_r]
        call [fclose]
        add esp, 4o
        
        final:
        
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
