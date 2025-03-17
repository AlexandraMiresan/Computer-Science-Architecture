bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; [(10+d)-(a*a-2*b)]/c
    a db 3
    b db 2
    c db 2
    d dw 5
    d10 dw 0
    aa dw 0
    b2 dw 0

; our code starts here
segment code use32 class=code
    start:
        ;first we solve this addition:(10 + d)
        mov ax, 10 ;we put one of the values in a register so that we can make the addition and store it somewhere
        add ax, [d] ;the register has to be a 16bits type register because d is declared as a dw meaning it won't fit into al
        mov [d10], ax ;we store the sum in a variable  so that we don't lose the obtained value, when working on other operations in the registers
        ;we solve: (a * a)
        mov al, [a] ;we have to put the value of a in al and also in bl because the mul requires an A register(al) but also another register in this case bl with which we multiply
        mov bl, [a] ;the value obtained is placed in the ax register 
        mul bl
        mov [aa], ax ;we store the multiplication in a variable so that we don't lose the obtained value, when working on other operations in the registers
        ;we solve (2 * b)
        mov al, 2 ;we put the value 2 just like above in an A register(al) and the value of b in another type of register (bl) so that we can effectuate the multiplication 
        mov bl, [b]
        mul bl ;the value obtained is put in the ax register (just like above) al * bl => ax
        mov [b2], ax ;we store the value we obtained in a variable so that we don't lose the obtained value, when working on other operations in the registers
        ;we make the operations required with d10, aa and b2 : [(10+d)-(a*a-2*b)] = (10 + d) - a * a + 2 * b
        mov ax, [d10]
        sub ax, [aa]
        add ax, [b2] ; here we will have the result of this operation : [(10+d)-(a*a-2*b)] = (10 + d) - a * a + 2 * b
        ;now we have to divide everything with the value in c
        mov bl, [c] ;we put the value of c into a bl register so that we can divide it with the value in the ax register : the value of the first operand should be double the size of the second operand 
        div bl ;same rule applies here, just like for multiplication we need an A register(ax) and another register in this case bl
        ;now we will have the value of the whole operation in the al register because ax / bl => al : works the opposite way of the multiplication  
        
        
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program 
        
