bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit, fopen, fclose, fread, fprintf           
import exit msvcrt.dll    
import fopen msvcrt.dll
import fclose msvcrt.dll
import fread msvcrt.dll
import fprintf msvcrt.dll
; our data is declared here (the variables needed by our program)
segment data use32 class=data
    fileinput db "input.txt", 0
    fileoutput db "output.txt", 0
    fd_in dd -1
    fd_out dd - 1
    highest_frequency dd 0
    current_frequency dd 0
    current_letter db 0
    highest_letter db 0
    highest_letter_print dd 0
    empty_line_format db 10, 0
    number_of_characters dd 0
    access_mode_r db "r", 0
    access_mode_w db "w", 0
    format db "%d", 0
    format_s db "%c", 0
    s times 200 db 0
; our code starts here
segment code use32 class=code
    start:
        ; A text file is given. Read the content of the file, determine the uppercase letter with the highest frequency and display the letter along with its frequency on the screen. The name of the text file is defined in the data segment.
        
        ;open file to read from
        push dword access_mode_r
        push dword fileinput
        call [fopen]
        add esp, 4 * 2
        
        mov [fd_in], eax
        
        cmp eax, 0
        je final

        ;open file to write in
        push dword access_mode_w
        push dword fileoutput
        call [fopen]
        add esp, 4 * 2
        
        mov [fd_out], eax
        
        cmp eax, 0
        je final
        
        ;read from file
        push dword [fd_in]
        push dword 200
        push dword 1
        push dword s
        call [fread]
        add esp, 4 * 4
        
        ;store the number of characters read
        mov [number_of_characters], eax
        
        ;check the letters from A-Z (ASCII 65-90)
        mov bl, 65
        count:
        mov dword [current_frequency], 0
        mov [current_letter], bl
        
        mov ecx, [number_of_characters]
        mov esi, s
        jecxz end_loop
        count_frequency:
            lodsb
            cmp al, bl
            jne skip_increment
            add dword [current_frequency], 1
            skip_increment:
        loop count_frequency
        end_loop:
        
        mov eax, [current_frequency]
        mov edx, [highest_frequency]
        cmp eax, edx
        jna skip
        mov [highest_frequency], eax
        mov [highest_letter], bl
        skip:
        inc bl
        cmp bl, 90
        jle count
        
        
        
        mov eax, 0
        mov al, [highest_letter]
        mov [highest_letter_print], eax
        
        ;print the letter with the highest frequency
        push dword [highest_letter_print]
        push dword format_s
        push dword [fd_out]
        call [fprintf]
        add esp, 4 * 3
        
        
        push dword empty_line_format
        push dword [fd_out]
        call [fprintf]
        add esp, 4 * 2
        
        
        ;print the highest frequency
        push dword [highest_frequency]
        push dword format
        push dword [fd_out]
        call [fprintf]
        add esp, 4 * 2
        
        ;close the file to read from
        push dword [fd_in]
        call [fclose]
        add esp, 4
        
        ;close the file to write in
        push dword [fd_out]
        call [fclose]
        add esp, 4
        
        final:
        
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
