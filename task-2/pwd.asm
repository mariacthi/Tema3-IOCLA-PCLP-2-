; Tudor Maria - Elena, 311CA

section .data
	back db "..", 0
	curr db ".", 0
	slash db "/", 0
	; declare global vars here
	counter dd 0

section .text
	global pwd
	extern printf
	extern strcmp
	extern strcat

;;	void pwd(char **directories, int n, char *output)
;	Adauga in parametrul output path-ul rezultat din
;	parcurgerea celor n foldere din directories

pwd:
	enter 0, 0

	mov esi, [ebp + 8] ; directories
	mov ecx, [ebp + 12] ; n
	mov edi, [ebp + 16] ; output

	xor edx, edx
	mov dword [counter], 0

create_path:
	; going through the list of directories
	; and pushing them on the stack
	; so that it is easier to remove
	; them from the path if necessary
	cmp ecx, 0
	jle exit
	
	; store the name of the directory in eax
	mov dword eax, [esi + edx * 4]

	; check if the directory is '.',
	; using the strcmp function
	; (if it is, the stack won't change)
	pusha
	push eax
	push curr
	call strcmp
	add esp, 8

	test eax, eax
	popa
	jz continue_loop
	
	; check if the directory is '..',
	; using the strcmp function
	; (if it is, then a directory will be deleted
	; from the stack)
	pusha
	push eax
	push back
	call strcmp
	add esp, 8

	test eax, eax
	popa
	jz delete_directory

	; if the directory is not '.' or '..'
	; then I push it on the stack
	push dword eax

	; increment the counter for how many
	; directories are on the stack
	mov eax, [counter]
	inc eax
	mov [counter], eax

	jmp continue_loop

delete_directory:
	mov eax, [counter]

	; if the counter is 0, then there is no directory
	; to go back to (as '..' is supposed to do)
	; so I skip it
	test eax, eax
	jz continue_loop

	; if there are directories on the stack, then
	; I decrement the counter and pop the last one
	; on the stack
	dec eax
	mov [counter], eax
	pop eax

continue_loop:
	inc edx
	dec ecx
	jmp create_path

exit:
	; creating the path in edi by putting 
	; the beginning of the string in it: '/'
	pusha
	lea esi, [slash]
	push esi
	push edi 
	call strcat
	add esp, 8
	popa

	mov ecx, [counter]
	xor edx, edx

concatenate:
	cmp ecx, 0
	je finish_program
	
	; accessing the directories on the stack, using
	; the esp register and knowing how many 
	; directories have been pushed on the stack
	mov esi, [esp + (ecx - 1) * 4]
	
	; using the strcat function to create the path
	; by concatenating the string with every directory
	; from the stack
	pusha
	push esi
	push edi
	call strcat
	add esp, 8
	popa

	; using strcat to add '/' after every directory's name
	pusha
	lea esi, [slash]
	push esi
	push edi 
	call strcat
	add esp, 8
	popa

	dec ecx
	jmp concatenate

finish_program:
	leave
	ret
	