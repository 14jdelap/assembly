section .text
  global _start

_start:

  call factorial

print:

factorial:
  ; base case: if it's the base case, return the argument
  ; general case: return fa
  cmp edi, 1
  jne _factorial
  mov eax, edi
  ret

_factorial:
  push rbp
