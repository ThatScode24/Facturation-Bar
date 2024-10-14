This NASM x86-64 assembly project is a vintage-inspired CLI-based billing (facturation) software developed for "Le Bistrot du Peintre," a classic French bar set in the 1970s. The software replicates the nostalgic atmosphere of that era, where customer bills were calculated in French Francs (FRF) rather than Euros. A key feature of this project is the vintage-style interface, designed with black and green colors using ANSI escape codes for terminal manipulation, giving it the aesthetic of an early 70s computer terminal.

Command to execute the script:

nasm -g -F dwarf -f elf64 -o facturation.o facturation.asm && ld -o facturation facturation.o && ./facturation
