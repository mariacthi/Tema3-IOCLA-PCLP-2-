; Tudor Maria - Elena, 311CA

section .data
	; declare global vars here
	vowels db "aeiou", 0

section .text
	global reverse_vowels
	extern printf
	extern strchr

;;	void reverse_vowels(char *string)
;	Cauta toate vocalele din string-ul `string` si afiseaza-le
;	in ordine inversa. Consoanele raman nemodificate.
;	Modificare se va face in-place

reverse_vowels:
	push ebp

	; mov ebp, esp
	push esp
	pop ebp

	; mov edi, [ebp + 8]
	; the string will be stored in edi
	push dword [ebp + 8]
	pop edi

	xor ecx, ecx

find_vowels:
	; going through the string letter by letter
	; and storing the letter in esi to check if
	; it's a vowel or not
	push dword [edi + ecx]
	pop esi

	cmp esi, 0
	je found_vowels

	push ecx ; save ecx

	; using strchr to check if the letter is a vowel
	push esi
	push vowels
	call strchr
	add esp, 4
	pop esi

	pop ecx ; restore ecx

	test eax, eax
	jz not_vowel

	; push vowel on the stack to use later
	push esi

not_vowel:
	inc ecx
	jmp find_vowels

found_vowels:
	xor ecx, ecx

replace_vowel:
	; going through the string one more time,
	; but this time whenever I found a vowel
	; I replace it with one on the stack 
	; (since they should be reversed, the push and
	; pop operations are perfect as they respect
	; the last-in-first-out rule)

	; the letter is in esi
	push dword [edi + ecx]
	pop esi

	cmp esi, 0
	je exit

	push ecx ; save ecx

	; using strchr to check if the letter is a vowel
	push esi
	push vowels
	call strchr
	add esp, 4
	pop esi

	pop ecx ; restore ecx

	test eax, eax
	jz continue

	; once I find a vowel, I pop from the stack
	; the one that will replace it
	pop eax

	; mov byte [edi + ecx], al
	and byte [edi + ecx], 0
	or byte [edi + ecx], al
	
continue:
	inc ecx
	jmp replace_vowel

exit:
	pop ebp
	ret