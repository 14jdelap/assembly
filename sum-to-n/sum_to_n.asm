section .text
global sum_to_n

; 1. Early return if arg is 0
; 	- rdi has the argument
; 	- cmp rdi, 0 and then do je return
; 	- set rax to 0 using xor before getting to accumulate
;     - eax is the same as rax but only its first 32 bits, rather than the full 64 bits of rax
; 2. Accumulate until arg is 0, decrease arg by 1 in each loop
; 3. Return accumulated value

sum_to_n:
	xor eax, eax
_accumulate:
	add eax, edi
	dec edi
	jg _accumulate
	ret
