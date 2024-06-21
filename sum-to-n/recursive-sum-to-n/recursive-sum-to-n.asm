section .text
global sum_to_n

; Base case: if n == 0 return
; Else: call n + sum_to_n(n - 1)

; I need to start by pushing n so that I can pop it before returning
; Check for the base case

sum_to_n:
	mov eax, 0         ; set eax to 0, called only once by being outside iterate

	iterate:
		push rbx           ; save n to access it later
		mov rbx, rdi       ; set n in caller-owned rbx (as sum_to_n will soon be the caller)
		cmp rdi, 0         ; checks base case
		je .base_case
		lea rdi, [rdi - 1] ; sets rdi to (n - 1)
		call iterate       ; calls itself with iterate(n - 1)
		add eax, ebx       ; add the result when iterate returns

	.base_case:
		pop rbx            ; pop n to use it in the outer function call
		ret                ; set rip to line 20, pop this procedure's stack frame and return
