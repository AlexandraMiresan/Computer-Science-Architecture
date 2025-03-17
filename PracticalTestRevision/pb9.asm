bits 32
global start

extern exit, scanf, fprintf, fopen, fread
import exit msvcrt.dll
import scanf msvcrt.dll
import fprintf msvcrt.dll
import fopen msvcrt.dll
import fread msvcrt.dll

;9.	De la tastatura se citeste un nume de fisier input.
; Se creaza un alt fisier de output in care se pune continutul fisierului de input cu toate caracterele mici schimbate cu codul lor ascii.

segment data use32 class=data
    string_format_input db "%s", 0
    number_format db "%d ", 0
    file_input times 100 db 0
    file_output db "output.txt", 0
    access_mode_read db "r",0
    access_mode_write db "w",0
    file_handle_input dd 0
    file_handle_output dd 0
    text times 100 db 0
    changed_text times 100 db 0
    number_ch dd 0
    small_letter dd 0
segment code use32 class=code
start:
    push dword file_input
    push dword string_format_input
    call [scanf]
    add esp,8
    
    push dword access_mode_read
    push dword file_input
    call [fopen]
    add esp, 8
    
    mov [file_handle_input], EAX
    
    cmp eax, 0
    je final
    
    push dword access_mode_write
    push dword file_output
    call [fopen]
    add esp, 8
    
    mov [file_handle_output], EAX
    
    cmp eax, 0
    je final
    
    push dword [file_handle_input]
    push dword 100
    push dword 1
    push dword text
    call [fread]
    add esp, 4 * 4  ;in text we have the context of the input file
    
    mov [number_ch], EAX
    
    push dword [number_ch]
    push dword number_format
    push dword [file_handle_output]
    call [fprintf]
    add esp, 4 * 3
    
    mov ecx, [number_ch]
    mov esi, text
    mov edi, changed_text
    jecxz end_loop
    parcurgere:
        LODSB
        ; sub al, '0'
        ; cmp al, 'a'
        ; jb not_lowercase
        ; cmp al, 'z'
        ; ja not_lowercase
        
        push dword [small_letter]
        push dword number_format
        push dword [file_handle_output]
        call [fprintf]
        add esp, 4 * 3
        
        ; stosb
        ; not_lowercase:
        
    loop parcurgere
    end_loop:
    
    
    ; push dword changed_text
    ; push dword number_format
    ; push dword [file_handle_output]
    ; call [fprintf]
    ; add esp, 12
    final:
    
    
    push dword 0
    call [exit]