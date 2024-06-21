section .text
global fib

fib:
	push rdi              ; push n
	mov eax, edi          ; set return value to n
	cmp edi, 1            ; check base case
	jle base_case
	dec edi               ; if base case isn't met, dec n to n-1 to do fib(n-1) + fib(n-1)
	call fib              ; call fib(n - 1)

	mov r12d, eax         ; eax is fib(n-1), save in r12d

	dec edi               ; dec n-1 to n-2 to call fib(n-1)
	push r12              ; push fib(n-1) to add at the end
	call fib              ; call fib(n-2)

	pop r12               ; pop fib(n-1)
	lea eax, [r12d + eax] ; add and return fib(n-1) + fib(n-2)

base_case:
	pop rdi	              ; pop n for outer function execution
	ret
