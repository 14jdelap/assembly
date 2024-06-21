; ===============================================================================
; UPPERCASER
;
; Uppercases your command line arguments and prints them out!
; Written as a working example of an x86 Intel syntax assembly language program
; ===============================================================================

; Assembler used: YASM
; Assembly syntax: x86 Intel
; CPU architecture: Intel x86-64
; Platform architecture: Mac
; OS architecture: MacOS

; .data stores read-only constants
section .data

; .text has the executable code
; Process entry point set to _main
section .text
  global _main

; In an Intel x86-64 processor, at the beginning of _main
; rdi contains argc, an integer for the number of CLI arguments
; rsi contains argv[][], the array of CLI arguments
_main:
  ; ; Assuming we follow assembly conventions:
  ; ; - Since rdi and rsi are callee-owned registers calling any function risks overriding their value
  ; ; - Thus, we copy them to r12 and r13 which are caller-owned variables
  mov r12, rdi ; argc
  mov r13, rsi ; argv[][]

  ; ; If we have no arguments (i.e. argc is equal to 1 since the first arg is the program name) call the .exit label
  ; ; je (jump if zero flag = 1) jumps if argc is 1, since the name of the program is the first argument
  cmp rdi, 1
  je .exit

  push r12
  call .printNumberOfArgs
  call .printNewline

  ; Push values to stack to follow conventions of how to pass arguments to functions
  push r13           ; argv[][]
  push r12           ; argc
  call .printAllArgs ; C equivalent would be: printAllArgs(argc, argv[][])

  ; Exit program as we're done
  call .exit

.printNumberOfArgs:
  ; Note: in a label the top of the stack is always the memory address where this label was invokes from
  pop rbx              ; memory address
  pop rdi              ; argc
  push rbx             ; memory address goes back to the stack

  add rdi, 47          ; convert the number of argc from base 10 to ASCII, but treating the file name as if it weren't an argument
  push rdi             ; Push ASCII-converted value to stack to get a memory address

  mov rsi, rsp         ; set rsi to the memory address at the top of the stack
  mov rdx, 1           ; rdx is length of argc
  call .print
  add rsp, 8

  ret

.printNewline:
  ; The write syscall expects to get a pointer to the data being written, not its value
  ; The easiest way to do so is to push the data to the stack and assign rsi to the stack pointer
  ; Then, clean the stack pointer by adding 8 bytes (since popping increases the stack by that amount)
  push 10
  mov rsi, rsp
  mov rdx, 1

  call .print
  add rsp, 8

  ret

.printAllArgs:
  pop rbx  ; memory address of the line we were called from
  pop rdi  ; argc
  pop rcx  ; argv[][]
  push rbx ; memory address goes back in the stack

  ; rax will be the counter for the number of CLI arguments we've iterated through, and will monotonically increase by 1 every time we print
  ; rax starts at 1 since we skip the first CLI argument, the file name
  mov rax, 1

  ; Loop over CLI args
  .printArgsLoopStart:
    ; Push all 3 callee-owned registers since they may be overwritten by this function
    push rdi
    push rcx
    push rax

    ; Print an argument and a newline
    ; Push rcx again to "pass" it to .printAtg
    push rcx
    call .printArg
    call .printNewline

    pop rax
    pop rcx
    pop rdi

    ; Increment rax (counter) by 1 to keep track of how many arguments we've iterated
    ; Increment rcx (argv[][]) by 8 to get to the next memory address in the array of addresses
    inc rax
    add rcx, 8

    ; Check if rax equals rdi (argc), if it does finish the execution
    cmp rax, rdi

    ; jl (jumps if less than) will go to the start of the label if rax < rdi
    ; Else, the label will finish and will continue executing the .printAllArgs function
    jl .printArgsLoopStart

  ret

  .printArg:
    pop rbx  ; return address
    pop rcx  ; argv[][]
    push rbx ; return address back to stack

    ; ====================
    ; = What's argv[][]? =
    ; ====================
    ;
    ; In C a string is an array of characters (i.e. char[])
    ; Thus, an array of strings is an array of arrays (i.e. char[][])
    ; This is why CLI are passed as arrays of strings, which in C is named argv[][]
    ;
    ; In assembly an array is a _memory address_ pointing to the first element in the array
    ;
    ; For example, if you had an array of integers that looked like this:
    ; +-----------+-----+
    ; |  address  | val |
    ; +-----------+-----|
    ; | 0x03a8000 | 919 |
    ; | 0x03a8040 |  30 |
    ; | 0x03a8080 | 245 |
    ; | 0x03a80c0 | 689 |
    ; +-----------+-----|
    ; The array would be represented by its first address: 0x03a8000
    ; To read the array you'd need to ask the computer for the value stored in that address (e.g. 0x03a8000 has the value 919)
    ;
    ; In assembly you follow an address into memory by surrounding it with []s
    ; rcx has you access the address in the rcx registry
    ; [rcx] has you access the value stored in MEMORY by the address in rcx
    ;
    ; When we follow addresses into memory we need to tell the computer the size of the data we want back
    ; In 64 bit computers we need to ask for qword (64 bit words) back, 32-bit words would be dword [rcx] and single bytes would be byte [rcx]
    ;
    ; Below we move the value of rcx into the syscall so that it can write it through the syscall when calling .print
    ; We add 8 bytes to [rcx] to skip 1 word and proceed to the next argument, which is the 1st user argument
    mov rbx, qword [rcx + 8]

    push rbx
    push rbx

    ; Iterate over characters to i) calculate string length and ii) uppercase letters
    call .iterate

    ; By convention function return values are in rax, so .strLen should´ve put the string's length into rax
    ; Here we move the value to rdx so .print can use it
    mov rdx, rax

    ; Pop the memory address of the CL argument back into rsi so the sys_call syscall gets to it
    pop rsi

    ; Print the CL argument
    call .print

    ret

  ; Iterate over characters, calculate the string's length to dynamically print it and uppercase it
  .iterate:
    pop rbx ; return memory address
    pop rsi ; argument string into rsi
    push rbx

    ; Get the string length by iterating over characters in memory until hitting the null (0) byte
    ; Character arrays terminate when you hit 0

    ; rax will hold the string length counter, which will increment as we run through the string
    mov rax, -1

    ; Loop over each character in the string
    .iterateLoop:
      inc rax ; always increments, hence why rax starts at -1 -> opportunity to re-factor so rax starts at 0?

      ; Check if the current character is null byte (0)
      ; rsi is a pointer to the first character in the string
      ; rax is the number of characters we've looked at so far (0 in 1st iteration, 1 in 2nd, etc)
      ; rsi + rax is the memory address of the current character we're iterating through
      ; - rsi + 0 is the first character
      ; - rsi + 1 is the second character
      ; and having them in [rsi + rax] means we access their value in memory rather than the pointer
      ; We write it as `byte [rsi, rax]` because characters are 1 byte, so we specify that type
      cmp byte [rsi + rax], 0

      ; jz (jump if zero) jumps if the ZF is true?
      ; .return is an early return statement
      jz .return

      call .uppercase
      call .iterateLoop

    .uppercase:
      ; Check if the current character can be a lowercase letter (they start at 97)
      cmp byte [rsi + rax], 97

      ; jl (jump if lower) means that if the character is less than 97 it returns early
      jl .return

      ; Compare and return early if the byte is not within the bounds of a lowercase letter
      cmp byte [rsi + rax], 122
      jg .return

      ; Subtract 32 from rsi + rax to lowercase the letter
      sub byte [rsi + rax], 32

      ; QUESTION!!!: where is the return value stored?
      ret


.print:
  mov rax, 0x2000004 ; write syscall
  mov rdi, 1         ; set output to stdout
  syscall            ; make write syscall, sys_write(rdi, rsi, rdx)
  ret                ; return to line where .print was called

; Labelled return to call when conditionally jumping
; Without this label the program can't conditionally return
.return:
  ret

; Typical exit label code
.exit:
  mov rax, 0x2000001 ; syscall for exit
  mov rdi, 0 ; exit code 0
  syscall
