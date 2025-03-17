bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit, fopen, fclose, fread, scanf, printf
import fopen msvcrt.dll
import fclose msvcrt.dll
import fread msvcrt.dll
import scanf msvcrt.dll
import printf msvcrt.dll               
import exit msvcrt.dll   
; our data is declared here (the variables needed by our program)
segment data use32 class=data
    fileinput times 31 db 0
    access_mode_r db "r", 0
    s times 200 db 0
    fd dd -1
    format_d db "%d", 0
    format_s db "%s", 0
    message_text_file db "text file = ", 0
    n db 0
    d times 200 db 0
    position dw 0
; our code starts here
segment code use32 class=code
    start:
        ; Sa se citeasca de la tastatura un nume de fisier si un numar. Sa se citeasca din fisierul dat cuvintele separate prin spatii si sa se afiseze in consola cuvintele care sunt pe pozitiile multiplii de numarul citit de la tastatura
        
        
        push dword message_text_file
        call [printf]
        add esp, 4
        
        push dword fileinput
        push dword format_s
        call [scanf]
        add esp, 4 * 2
        
        push dword access_mode_r
        push dword fileinput
        call [fopen]
        add esp, 4 * 2
        
        mov [fd], eax
        
        cmp eax, 0
        je final
        
        push dword n
        push dword format_d
        call [scanf]
        add esp, 4 * 2
        
        mov edi, 0
        mov word [position], 0
        read_input:
            push dword [fd]
            push dword 1
            push dword s
            call [fread]
            add esp, 4 * 3
            
            cmp eax, 0
            je final
            
            mov dl, [s]
            cmp dl, 32
            je process_word
            cmp dl, 10
            je process_word
            
            mov [s + edi], dl
            inc edi
            skip:
            jmp read_input
            
            
            
            process_word:
                mov byte[s + edi], 0
                
                mov ax, [position]
                mov bl, [n]
                div bl
                
                cmp ah, 0
                jne skip
                
                push dword s
                call [printf]
                add esp, 4
                
                inc word [position]
                mov edi, 0
                jmp read_input
            
            final:
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program