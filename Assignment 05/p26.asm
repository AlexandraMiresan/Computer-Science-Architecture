bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
    s db 1, 4, 2, 8, 4, 2, 1, 1
    ls equ $ - s
    d times ls db 0

; our code starts here
segment code use32 class=code
    start:
        ;A byte string S is given. Obtain in the string D the set of the elements of S.
        mov esi, 0 ;start index for s
        mov ecx, 0 
        loop_s:
        ;check if we have reached the end of s
            cmp esi, ls
            jge end_program ;if esi >= ls, go to the end
            ;put the current character from s into AL
            mov al, [s + esi]
            
            mov edi, 0 ;start index for d
            mov bl, 0 ;we use this as a flag for checking if the value is already in d
        check_d:
        ;check if we have reached the end of d
            cmp edi, ecx
            jge add_to_d
        ;compare the current element from s (AL) with the elements that are already in d
            mov dl, [d + edi]
            cmp al, dl
            je found_in_d ;if the value is found in d the flag will be set to true(1)
            inc edi 
            jmp check_d ;continue checking
        found_in_d:
            mov bl, 1
        add_to_d:
        ;if character is not in d we add it 
            cmp bl, 1
            je skip_add ; if the flag is set to true(1) we skip adding the element
            mov [d + ecx], al       
            inc ecx
        skip_add:
        ;if we dont have to add the element we get here
            inc esi
            jmp loop_s
        end_program:
            
          
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
