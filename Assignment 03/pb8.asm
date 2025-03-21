bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    s db 'a', 'A', 'b', 'B', '2', '%', 'x', 'M'
    lens equ $-s
    d times lens db 0
; our code starts here
segment code use32 class=code
    start:
        ; ...
        mov ESI, 0
        mov EDI, 0
        mov ECX, lens
        jecxz end_loop
        repeat_label:
            mov al, [s+ESI]
            cmp al, 'Z'
            ja wrong
            cmp al, 'A'
            jb wrong
            mov [d+EDI], al
            inc EDI
            wrong:
            inc ESI
        loop repeat_label
        end_loop:
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
