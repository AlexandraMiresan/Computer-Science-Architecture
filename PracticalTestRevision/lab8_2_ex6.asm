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
    fd_in dd 0
    fd_out dd 0
    highest_frequency dd 0
    current_frequency dd 0
    current_digit db 0
    highest_digit db 0
    highest_digit_print dd 0
    s times 200 db 0
    empty_line_format db 10, 0
    number_of_characters dd 0
    format db "%d", 0
    access_mode_r db "r", 0
    access_mode_w db "w", 0
; our code starts here
segment code use32 class=code
    start:
        ; A text file is given. Read the content of the file, determine the digit with the highest frequency and display the digit along with its frequency on the screen. The name of text file is defined in the data segment.
        
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
        
        ;store the number of characters
        mov [number_of_characters], eax
        
        ;move in bl 0 and then increment it in order to check each digit
        ;stop when bl is 10
        mov bl, 0
        count:
        mov dword [current_frequency], 0
        mov [current_digit], bl
        ;for that checks every digit of the ones read from the file
        mov ecx, [number_of_characters]
        mov esi, s
        jecxz end_loop
        count_frequency:
            lodsb
            sub al, '0'
            cmp bl, al
            jne skip_increment
            add dword [current_frequency], 1
            skip_increment:
        loop count_frequency
        end_loop:
        
        
        ;checks if the new frequency is bigger than the highest frequency
        ;if it is then it updates the highest frequency and digit
        mov eax, [current_frequency]
        mov edx, [highest_frequency]
        cmp eax, edx
        jna skip
        mov [highest_frequency], eax
        mov [highest_digit], bl
        skip:
        ;increments bl up until 10 and checks every digit
        inc bl
        cmp bl, 10
        jl count
        
        
        mov eax, 0
        mov al, [highest_digit]
        mov [highest_digit_print], eax
        
        ;print highest frequency digit
        push dword [highest_digit_print]
        push dword format 
        push dword [fd_out]
        call [fprintf]
        add esp, 4 * 3
        
        push dword empty_line_format
        push dword [fd_out]
        call [fprintf]
        add esp, 4 * 2
        
        ;print highest frequency
        push dword [highest_frequency]
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
