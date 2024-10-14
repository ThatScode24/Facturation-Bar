# Le Bistrot du Peintre - CLI Facturation Software

This NASM x86-64 assembly project is a vintage-inspired CLI-based billing (facturation) software developed for "Le Bistrot du Peintre," a classic French bar set in the 1970s. The software replicates the nostalgic atmosphere of that era, where customer bills were calculated in **French Francs (FRF)** rather than Euros.

A key feature of this project is the **vintage-style interface**, designed with black and green colors using ANSI escape codes for terminal manipulation, giving it the aesthetic of an early 70s computer terminal.

## Features

### 1. **Vintage Terminal Interface**
The user interface is designed to resemble a **retro CRT monitor**, featuring a black background with green text. This aesthetic is achieved using ANSI manipulation, creating an immersive experience that transports users back to the 1970s. 

- **Visual Design**: Black background, green text, CRT-like experience.

### 2. **Bill Generation**
The software allows users to generate **detailed customer bills** based on their orders. Each bill includes:
- **Itemized List**: A breakdown of ordered items.
- **Individual Prices**: The cost of each item in French Francs.
- **Total Amount**: The total amount due in French Francs, including any discounts applied.

This provides a full, transparent view of the customer’s charges.

### 3. **Discount Application**
Users can apply a **percentage discount** to the total bill, allowing for:
- **Promotions**: Special deals and discounts.
- **Customer Loyalty Rewards**: Discounts for regular customers.

The software recalculates the total after applying the discount, ensuring the customer can see the **new total amount due**.

### 4. **Temporary Bill Viewing**
The application allows users to **view a temporary bill** before finalizing the order. This feature enables the user to:
- **Review the Items**: See the items selected for the bill.
- **Check Prices**: Ensure the prices are correct before confirming.
- **View Total Amount**: See the total cost of the bill before applying any final adjustments.

This feature gives users control over the billing process, ensuring transparency and accuracy.

## Command to Execute the Script

To assemble, link, and run the facturation software, use the following command in your terminal:

```bash
nasm -g -F dwarf -f elf64 -o facturation.o facturation.asm && ld -o facturation facturation.o && ./facturation
