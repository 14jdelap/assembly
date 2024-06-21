section .text
global factorial

; base case: n == 1
; else: return n * factorial(n - 1)

; start by moving eax to 1 as it'll return that
; push the callee's n in rbx
; check the base case — if yes jump to it
; else, call factorial(n - 1)
; and then do eax * rbx

factorial:
  mov eax, 1

  iterate:
    push rbx
    mov ebx, edi
    cmp edi, 0
    jle .base_case
    dec edi
    call iterate
    imul eax, ebx

  .base_case:
    pop rbx
    ret
