bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    a db 2
    b dw 2
    c dd 2
    d dq 2
    ab1 dd 0
    ab2 dd 0
    

; our code starts here
segment code use32 class=code
    start:
        ; a + b + c + d - (a + b)
        mov al, [a] ; AL = a
        cbw ; AL -> AX => AX = a
        add ax, [b] ; AX = a + b
        cwde ; AX -> EAX => EAX = a + b
        cdq ; EAX -> EDX : EAX => EDX : EAX = a + b
        mov [ab1], eax
        mov [ab2], edx
        mov al, [a] ;AL = a
        cbw ; AL -> AX  => AX = a
        add ax, [b] ; AX = a + b
        cwde ; AX -> EAX => EAX = a + b
        add eax, [c] ; EAX = a + b + c
        cdq ; EAX -> EDX : EAX => EDX : EAX = a + b + c
        mov ebx, [d] ; EBX = [d]
        mov ecx, [d + 4] ; ECX = [d + 4]
        add eax, ebx ; we have to split the value d into 2 in order to add it together because d is a quadword so it does not dit into an extended register, we have to use 2, EDX:EAX. we have to add the first half to the EAX register and the second half of d to the EDX register, here we must also add the carry
        adc edx, ecx
        sub eax, [ab1] ; here we have to do the operations on two registers because a + b + c + d is on 64 bits so we have to split that into 2 registers like above, so we have the first part of the quadword in eax and the second part in edx 
        sbb edx, [ab2] ; EDX : EAX = a + b + c + d - (a + b)
        
        
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
