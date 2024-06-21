; Define static constants
section .data

; Process entry point is set to main
section .text
  global _main

_main:
  ; at the start of _main
  ; - rdi stores argc
  ; - rsi stores argv[][]
  ; Since they're both callee-owned registers, move these values to
  ; caller-owned registers r12 and r13 so function calls don't override them
  mov r12, rdi
  mov r13, rsi

  ; Call a function to print argc, which has the number of arguments
  push r12
  call .printNumberOfArgs
  call .printNewline

.printNumberOfArgs:
  pop rdx  ; return memory address
  pop rsi  ; argc
  push rdx ; return memory address back to stack

  add rsi, 47 ; convert argc to ASCII int

  push rsi     ; push argc ASCII int to stack
  mov rsi, rsp ; get argc pointer and move to rsi

  mov rdx, 1   ; set print length to 1 byte

  call .print

  add rsp, 8   ; clean stack
  ret

.print:
  ; sys_write(rax, rdi, rsi, rdx) takes 4 arguments
  ; - rax: defines it's a write operation for Mac
  ; - rdi: defines it's stdout (1)
  ; - rsi: memory location of what will be printed
  ; - rdx: length of what will be printed
  mov rax, 0x2000004
  mov rdi, 1

  syscall
  ret

.printNewline:
  push 10 ; 10 is newline in ASCII

  mov rsi, rsp
  mov rdx, 1

  call .print

  add rsp, 8 ; clean stack

  ret
