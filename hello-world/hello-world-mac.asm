;; Hello World in x86 Intel Assembly Syntax

; Assembler: YASM
; Assembly syntax: x86 Intel
; CPU architecture: Intel x86-64
; Platform architecture: Mac
; OS architecture: MacOS

;; Intel MacOS Assembly Instructions

; 1. Assemble the program into an object file
; 2. Generate the executable
; 3. Run the executable

;; 1. Assemble the program into an object file
; yasm -f macho64 hello-world.asm

; yasm: the assembler
; -f: flag that specifies the file format
; macho64: file format for mac executables
; hello-world.asm: file being assembled

; Output: an object file (i.e. machine code), can be viewed in a hex editor like https://hexfiend.com/

;; 2. Generate the executable
; This step links the object file to any libraries, and bindles everything into machine code

; ld hello-world.o -o hello-world -macosx_version_min 12.4 -L /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/lib -lSystem

; -o: flag to specify the exeuctable's name

;; 3. Run the executable
; ./hello-world

;; Assembly code

; Read-only constants
section .data
  ; msg is a label
  ; db is Data Bytes, which saves the ASCII-equivalent message in memory
  ; 10 is ASCII for newline
  msg: db "Hello, world!", 10

  ; Define a constant that's calculated during compilation
  ; This calculates the length of msg
  .len: equ $ - msg

; Executable code goes into the .text section
section .text
  ; Execution starts here because the linked looks for this symbol to set the process entry point
  global _main

_main:
  mov rax, 0x2000004 ; syscall for write, things with 0x2 are Mac-specific
  mov rdi, 1 ; sets output to stdout (i.e. 1), rdi is the first callee-owned argument
  mov rsi, qword msg ; save value of msg into rsi, qword specifies how much data to retrieve ; since x86-64 is 64 bit registers we want qwords (8 bytes) of data
  mov rdx, msg.len ; the number of bytes to write to stdout
  syscall ; OS call to write

  mov rax, 0x2000001 ; syscall for exit
  mov rdi, 0 ; exit code 0
  syscall ; invoke OS to exit
