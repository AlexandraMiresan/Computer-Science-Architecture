bits 32
global start

extern exit, scanf, printf
import exit msvcrt.dll
import scanf msvcrt.dll
import printf msvcrt.dll

;13.Se citeste de la tastatura un cuvant (sir de caractere de maxim 20 de caractere) si un numar reprezentat pe un octet.
;Daca numarul este impar se cere criptarea cuvantului prin adunarea la fiecare caracter a numarului citit modulo 20. 
;Daca numarul este par se cere criptarea cuvantului prin adaugarea gruparii "p"+consoana. Se cere afisarea cuvantului criptat


segment data use32 class=data
    string_format db "%s", 0
    number_format db "%d", 0
    numar dd 0
    cuvant times 50 db 0
    changed_word times 50 db 0
    number_ch dd 0
    mod20 db 0
segment code use32 class=code
start:
    ; Citim cuvantul
    push dword cuvant
    push dword string_format
    call [scanf]
    add esp, 8
    ; Calculam lungimea cuvantului
    mov ecx, 0
loop_count:
    mov al, [cuvant + ecx]
    cmp al, 0
    je done_counting
    inc ecx
    jmp loop_count
done_counting:
    mov [number_ch], ecx

    push dword numar
    push dword number_format
    call [scanf]
    add esp, 8  
    
    mov ax, [numar]
    and ax, 1         
    jz loop_par      

    mov ax, [numar]
    mov bl, 20
    div bl
    
    mov [mod20], ah
     
loop_impar:
    mov ecx, [number_ch]
    mov esi, cuvant
    mov edi, changed_word
loop_impar_process:
    lodsb
    add al, [mod20]   
    stosb
loop loop_impar_process
jmp afisare

loop_par:
    ; Criptare daca numarul este par
    mov ecx, [number_ch]
    mov esi, cuvant
    mov edi, changed_word
loop_par_process:
    lodsb
    cmp al, 'a'
    je vowel
    cmp al, 'e'
    je vowel
    cmp al, 'i'
    je vowel
    cmp al, 'o'
    je vowel
    cmp al, 'u'
    je vowel

    ; Adaugam 'p' si consoana
    mov bl, al
    mov al, 'p'
    stosb
    mov al, bl
    jmp vowel
vowel:
    stosb
    loop loop_par_process

afisare:
   
    push dword changed_word
    push dword string_format
    call [printf]
    add esp, 8


    push dword 0
    call [exit]
 