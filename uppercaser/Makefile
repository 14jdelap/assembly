# Makefile for Uppercaser in x86 Intel Assembly on macOS

ASSEMBLER = yasm
LINKER = ld
PROGRAM = uppercaser-mac

all: $(PROGRAM)

$(PROGRAM): $(PROGRAM).o
	@$(LINKER) $(PROGRAM).o -o $(PROGRAM) -macos_version_min 12.4 -L /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/lib -lSystem -no_pie

uppercaser-mac.o: $(PROGRAM).asm
	@$(ASSEMBLER) -f macho64 $(PROGRAM).asm

example-uppercaser

run: $(PROGRAM)
	@./$(PROGRAM)

clean:
	@rm -f $(PROGRAM) $(PROGRAM).o
