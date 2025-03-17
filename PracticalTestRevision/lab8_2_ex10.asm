bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit, fopen, fclose, fread, fprintf, scanf, printf               
import exit msvcrt.dll 
import fopen msvcrt.dll
import fclose msvcrt.dll
import fread msvcrt.dll
import fprintf msvcrt.dll   
import scanf msvcrt.dll
import printf msvcrt.dll
; our data is declared here (the variables needed by our program)
segment data use32 class=data
    fileoutput times 31 db 0
    s times 120 db 0
    fd dd -1
    number_of_characters dd 0
    access_mode_w db "w", 0
    message_text_file db "text file = ", 0
    message_text db "enter text = ", 0
    format db "%c", 0
    format2 db "%30s", 0
    format_s db "%s", 0
; our code starts here
segment code use32 class=code
    start:
        ; Read a file name and a text from keyboard. Create a file with that name in the current folder and write the text that has been read to file.
        
        
        push dword message_text_file
        call [printf] 
        add esp, 4
        
        ;read file name
        push dword fileoutput
        push dword format2
        call [scanf]
        add esp, 4 * 2
        
        push dword access_mode_w
        push dword fileoutput
        call [fopen]
        add esp, 4 * 2
        
        mov [fd], eax
        
        cmp eax, 0
        je final
        
        push dword s 
        push dword format 
        call [scanf]
        add esp, 4 * 2
        
        push dword message_text
        call [printf]
        add esp, 4
        
         read_input:
            push dword s
            push dword format
            call [scanf]
            add esp, 4 * 2
            
            mov [number_of_characters], eax
            
            cmp byte[s], 10
            
            
            je end_program
            ;print the character
            push dword s
            push dword format_s
            push dword [fd]
            call [fprintf]
            add esp, 4 * 3
            
            ;continue with the next character
            jmp read_input
        
        end_program:
        
        
        push dword [fd]
        call [fclose]
        add esp, 4
        
        final:
        
        
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
