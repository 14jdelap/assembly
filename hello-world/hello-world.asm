section .data
  msg: db "Hello, world!", 10 ; db (data bytes) saves ASCII-equivalent message IN-MEMORY
  .len: equ $ - msg

section .text
  global _main

_main:
  ; I need to make a sys_write call
  mov rsi, qword msg ; memory address of data to output — of size word (64 bits)
  mov rdx, msg.len   ; length of output
print:
  mov rax, 0x2000004 ; write syscall
  mov rdi, 1         ; stdout
  syscall
exit:
  mov rax, 0x2000001 ; exit syscall
  xor rdi, rdi       ; exit code 0 — xor takes 1 less byte than mov rdi, 0
  syscall
