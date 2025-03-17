bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    input_string db 2, 4, 2, 5, 2, 2, 4, 4 
    len equ $ - input_string
    output_string times len dw 0
    poz db 0

  

; our code starts here
segment code use32 class=code
    start:
        ; Being given a string of bytes, build a string of words which contains in the low bytes of the words the set of
        ; distinct characters from the given string and in the high byte of a word it contains the number of occurrences 
        ; of the low byte of the word in the given byte string.
        
    mov esi, input_string   
    mov edi, output_string  
    mov ecx, len            

    mov ebx, 0
    process_input:
    lodsb
    
    mov edi, output_string
    mov byte[poz], 0
    cld
    search:
        cmp [poz], bl
        jge not_found
        inc edi
        inc byte [poz]
        scasb
        jne search
        inc byte[edi-2]
        jmp completed
    not_found:
    lea edi,[output_string + 2*ebx + 1]
    stosb
    mov byte[output_string + 2*ebx ], 1
    inc ebx
    completed:
    
    loop process_input

             
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
