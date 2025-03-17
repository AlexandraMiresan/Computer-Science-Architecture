bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit, fprintf, fread, fopen, fclose              
import exit msvcrt.dll    
import fprintf msvcrt.dll
import fread msvcrt.dll
import fopen msvcrt.dll
import fclose msvcrt.dll

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    fileinput db "input.txt", 0
    fileoutput db "output.txt", 0
    access_mode_r db "r", 0
    access_mode_w db "w", 0
    fd_in dd -1
    fd_out dd -1
    format db "%d", 0
    s times 200 db 0
    number_of_vowels dd 0
    number_of_characters dd 0
; our code starts here
segment code use32 class=code
    start:
        ; A text file is given. Read the content of the file, count the number of vowels and display the result in a textfile. The name of the text file is defined in the data segment.
        
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
        
        ;move the number of characters
        mov [number_of_characters], eax
        
        ;go through the whole string and check each letter
        mov ecx, [number_of_characters]
        mov esi, s
        jecxz end_loop
        
        count_vowels:
            lodsb
            cmp al, 'a'
            je increment_count
            cmp al, 'A'
            je increment_count
            cmp al, 'e'
            je increment_count
            cmp al, 'E'
            je increment_count
            cmp al, 'i'
            je increment_count
            cmp al, 'I'
            je increment_count
            cmp al, 'o'
            je increment_count
            cmp al, 'O'
            je increment_count
            cmp al, 'u'
            je increment_count
            cmp al, 'U'
            je increment_count
            jmp skip
            increment_count:
            add dword[number_of_vowels], 1
            skip:
        loop count_vowels
        end_loop:
        
        ;print the number of vowels
        push dword [number_of_vowels]
        push dword format
        push dword [fd_out]
        call [fprintf]
        add esp, 4 * 3
        
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
