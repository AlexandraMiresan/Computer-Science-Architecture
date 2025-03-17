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
    r dd 23
    t dd 43
    q dd 0 

; our code starts here
segment code use32 class=code
    start:
        ; ...
        mov eax, [t]
        shr eax, 15 ; here we move the bits 7-31 so that the register contains only 0 and the bits that we want to put in q
        shl eax, 25
        mov [q], eax
        mov eax, [t] ;here we move the bits in r and in t so that we have once again only 0's and the bits that we require for the xor operation
        mov ebx, [r]
        shr eax, 7
        shl eax, 7
        shl eax, 7
        shr eax, 7
        shr ebx, 7
        shl ebx, 7
        shl ebx, 7
        shr ebx, 7
        xor eax, ebx ; here we are going to have the bits 7-24 set to what we need and the rest will be 0
        mov ebx, [q]
        or [q], eax ; here we make an or operation so that we can place the bits 7-24 in q
        mov eax, [r]
        shl eax, 5 ; here we move the bits so that we have only 0 on the left and the bits 25-31 will be set according to what is in r on those bits
        shr eax, 5
        shr eax, 20
        or [q], eax ; here we make an or operation so that we can place the bits 25-31 in q
        ;we use the or operation due to the fact that besides the bits that we need the rest are 0 so the result is going to be the completed number q
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
