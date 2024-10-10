; Tudor Maria - Elena, 311CA

section .data
    delimiters db " ,.", 10, 0
    format db "%s ", 10, 0
    format2 db "%d ", 10, 0
    null db 0
    counter dd 0
    size dd 0

global get_words
global compare_func
global sort

section .text
    extern strtok
    extern printf, strcat, qsort, strlen, strcmp
;; sort(char **words, int number_of_words, int size)
;  functia va trebui sa apeleze qsort pentru soratrea cuvintelor 
;  dupa lungime si apoi lexicografix
sort:
    enter 0, 0

    mov esi, [ebp + 8] ; words
    mov ecx, [ebp + 12] ; number_of_words
    mov edx, [ebp + 16] ; size 
    
    ; qsort call
    push compare_func
    push edx
    push ecx
    push esi
    call qsort
    add esp, 16

    leave
    ret

compare_func:
    ; function to compare two strings and returns in eax -1 
    ; if the first string is lesser than the second one 
    ; (should be placed before it), 0 if they are equal
    ; and 1 if the first string is greater than the
    ; second one (should be placed after it)
    push ebp
    mov ebp, esp

    ; saving the registers that will be changed in the function
    push ebx
    push esi 
    push edi

    mov esi, [ebp + 8] ; first string
    mov edi, [ebp + 12] ; second string

    push esi ; save esi
   
    ; using strlen for the length of the first string 
    push dword [esi]
    call strlen
    add esp, 4

    pop esi ; restore esi
    
    ; storing the first length in ebx
    mov ebx, eax

    push edi ; save edi

    ; using strlen for the length of the second string
    push dword [edi]
    call strlen         
    add esp, 4

    pop edi ; restore edi

    ; comparing the lengths of the two words
    cmp ebx, eax
    ; jumping to lesser if the first string is shorter
    jl lesser
    ; jumping to greater if the first string is longer            
    jg greater

    ; comparing the strings using strcmp if the lengths
    ; of the two strings are equal
    push dword [edi]
    push dword [esi]
    call strcmp
    add esp, 8

quit:
    ; restoring the registers that were modified in the function
    pop edi
    pop esi
    pop ebx

    leave
    ret

lesser:
    mov eax, -1
    jmp quit

greater:
    mov eax, 1
    jmp quit


;; get_words(char *s, char **words, int number_of_words)
;  separa stringul s in cuvinte si salveaza cuvintele in words
;  number_of_words reprezinta numarul de cuvinte
get_words:
    enter 0, 0

    mov edi, [ebp + 8] ; s
    mov esi, [ebp + 12] ; words
    mov edx, [ebp + 16] ; number_of_words

    ; using strtok to separate the words
    push delimiters
    push edi
    call strtok
    add esp, 8

    ; using the counter variable for accessing the 
    ; address where to put each word in parameter "words"
    xor ecx, ecx
    mov [counter], ecx

strtok_loop:
    ; using the strtok function to separate the string
    ; into words and and then storing them at the address
    ; in esi

    ; stopping when we get to the string terminator
    cmp eax, 0
    je exit

    ; using counter to access the right memory location
    ; for each word
    mov ecx, [counter]
    mov [esi + ecx * 4], eax
    
    ; strtok call
    push delimiters
    push 0
    call strtok
    add esp, 8

    ; increment counter
    mov ecx, [counter]
    inc ecx
    mov [counter], ecx

    jmp strtok_loop

exit:
    leave
    ret