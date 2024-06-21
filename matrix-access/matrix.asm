section .text
global matrixIndex

; Write a program which given a matrix M, row index i and column index j, retrieves the item M[i][j]
; M[i][j] needs to be stored in rax
; return the VALUE, not the pointer

matrixIndex:
	; rdi: matrix
	; esi: rows
	; edx: cols
	; ecx: rindex
	; r8d: cindex -> each integer is 4 bytes long

	; return 0 if rindex or cindex are greater than rows or cols
	cmp ecx, esi
	jge zero_rax
	cmp r8d, edx
	jge zero_rax

	; index by calculating
	; rdi (matrix pointer) + 4 (intSize) * ecx (rindex) *
	; imul ecx, edx
	; add ecx, r8d
	; imul ecx, 4
	; add rcx, rdi ; add the address plus the offset
	; mov eax, [rcx] ; access the VALUE of the address and set it to eax as ints fit in 32 bits

	imul ecx, edx
	add ecx, r8d
	mov eax, [rdi + 4 * rcx] ; access the VALUE of the address and set it to eax as ints fit in 32 bits

	; imul ecx, edx
	; add ecx, r8d
	; mov rax, [rdi + 4 * rcx]
	jmp return

zero_rax:
  xor eax, eax
return:
  ret


; Algorithm

; 1. Short circuit function if arguments would lead to overflow
; - If rindex >= rows, return rax == 0
; - If cindex >= rows, return rax == 0
; 2. Access the row array with    `lea r9, [rdi + ecx*8]
; 3. Access the column value with `lea r9, [r9 + r8d*4]
