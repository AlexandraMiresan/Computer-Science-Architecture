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
    a db 2
    b db 3
    c db 4
    d dw 5
    a10 dw 0
    bc dw 0

; our code starts here
segment code use32 class=code
    start:
        ; ...
        mov al, [a]
        mov bl, 10
        mul bl ;AX = 10 * a
        mov [a10], ax
        mov al, [b]
        mov bl, [c]
        mul bl ; ax = b * c
        add ax, [a10]
        mov [bc], ax
        mov ax, [d]
        add ax, [a10]
        sub ax, [bc]
        
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
