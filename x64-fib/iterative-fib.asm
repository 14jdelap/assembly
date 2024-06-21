section .text
global iterativeFib

; int fib (int n) {
;  	if (n <= 1) return n;
;  	return fib(n - 1) + fib(n - 2);
; }

; PROBLEM: calculate the nth fibonacci number

; NAIVE SOLUTION

; Assumptions
; - Start at the high number and then go down to n, one at a time
; - Assume numbers are positive

; Algo: while n > 1
; -
; - Compare argument: if 1 or less return
; - Else:

; fib(0) == return 0
; fib(1) == return 1
; fib(2) == return 1 + 0
; fib(3) == return 1 + 1
; fib(4) == return 2 + 1
; fib(5) == return 3 + 2
; fib(6) == return 5 + 3
; fib(7) == return 8 + 5
; fib(8) == return 13 + 8
; fib(9) == return 21 + 13
; fib(10) == return 34 + 21

iterativeFib:
	; return if argument is 0 or 1
	cmp edi, 0
	je returnArg
	cmp edi, 1
	je returnArg

	; else, compute and add elements to the array until edx == edi
	mov esi, 0  ; y
	mov edx, 1  ; x
	lea eax, 1  ; accumulator
	mov r8d, 2   ; counter
loop:
	; Return if the counter == argument
	cmp r8d, edi
	je return

	inc r8d              ; increase counter
	mov esi, edx				 ; y = x
	mov edx, eax         ; x = acc
	lea eax, [edx + esi] ; acc = x + y
	jmp loop
returnArg:
	mov eax, edi
	ret
return:
	ret
