bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit, fopen, fclose, fread, fprintf, scanf               
import exit msvcrt.dll    
import fopen msvcrt.dll
import fclose msvcrt.dll
import fread msvcrt.dll
import fprintf msvcrt.dll
import scanf msvcrt.dll
; our data is declared here (the variables needed by our program)
segment data use32 class=data
    fileoutput db "output.txt", 0
    fd dd -1
    format db "%s", 0
    access_mode_w db "w", 0
    empty_line_format db 10, 0
    s times 200 db 0
    number_of_characters dd 0
; our code starts here
segment code use32 class=code
    start:
        ; A file name is given (defined in the data segment). Create a file with the given name, then read words from the keyboard and write those words in the file, until character '$' is read from keyboard.
        
        ;open the file to write in
        push dword access_mode_w
        push dword fileoutput
        call [fopen]
        add esp, 4 * 2
        
        mov [fd], eax
        
        cmp eax, 0
        je final
        
        ;read words from keyboard 
        read_input:
            push dword s
            push dword format
            call [scanf]
            add esp, 4 * 2
            
            mov [number_of_characters], eax
            
            mov ecx, [number_of_characters]
            mov esi, s
            jecxz end_loop
            ;check if the word that was read is '$'
            check_if_end_marker:
                lodsb
                cmp al, '$'
                je end_program
            loop check_if_end_marker
            end_loop:
            
            ;print the word
            push dword s
            push dword format
            push dword [fd]
            call [fprintf]
            add esp, 4 * 3
            
            ;continue with the next word
            jmp read_input
        
        end_program:
        
        ;close the file
        push dword [fd]
        call [fclose]
        add esp, 4
        
        final:
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
