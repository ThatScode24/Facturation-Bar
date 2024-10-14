This NASM x86-64 assembly project is a vintage-inspired CLI-based billing (facturation) software developed for "Le Bistrot du Peintre," a classic French bar set in the 1970s. The software replicates the nostalgic atmosphere of that era, where customer bills were calculated in French Francs (FRF) rather than Euros. A key feature of this project is the vintage-style interface, designed with black and green colors using ANSI escape codes for terminal manipulation, giving it the aesthetic of an early 70s computer terminal.

- Vintage Terminal Interface:
The user interface is designed to resemble a retro CRT monitor, featuring a black background with green text. This aesthetic is achieved using ANSI manipulation, creating an immersive experience that transports users back to the 1970s.

- Bill Generation:
The software allows users to generate detailed customer bills based on their orders. Each bill includes an itemized list of ordered items, their individual prices, and the total amount due in French Francs.

- Discount Application:
Users can apply a percentage discount to the total bill, allowing for special promotions or customer loyalty rewards. The software calculates the new total after applying the discount, ensuring transparency in pricing.

- Temporary Bill Viewing:
The application provides a feature to view a temporary bill before finalizing the order. This allows users to review the items selected, their prices, and the total amount,

Command to execute the script:

nasm -g -F dwarf -f elf64 -o facturation.o facturation.asm && ld -o facturation facturation.o && ./facturation
