section .text
global binary_convert

; I have inputs that are binary of N length
; Thus, I should have a counter and iterate where
; eax = 2 ^ N * b, where N is the position of the bit and b where it's on or off

; "0": 2 ^ 0 * 0 = 1 * 0 = 1
; "1": 2 ^ 0 * 1 = 1 * 1 = 1
; "10": 2 ^ 1 * 1 + 2 ^ 0 * 0 = 2 * 1 + 1 * 0 = 2 + 0 = 2

; Iterate over the string to count its length
; Push each value onto the stack
; When hit NULL terminator (0), undo the stack and calculate

; Bitwise
; Loop until 0 is hit
; Check if rdi + 4*rsi is less than 48, if yes return
; Otherwise add a left shift to the result (eax)
; Then check if it's greater than 48 (ie 1), if it is OR 1

binary_convert:
	mov rsi, 0 						 ; count position
	mov rax, 0 						 ; result

	loop:
		mov rdx, [rdi + rsi] ; get current iteration's value

		cmp dl, 48 					 ; check base case
		jl return            ; if met, return

		shl eax, 1 					 ; left shift regardless of value
		inc rsi    					 ; increase count position

		cmp dl, 48 					 ; check base case
		je loop              ; loop back and continue if 0
		jg or                ; OR with 1 to make last digit a 1

	or:
		or eax, 1
		jmp loop

	return:
		ret
