# 8051 Microcontroller Calculator (LCD + Buttons) — DSM-51 Ready

An assembly project for **8051** that lets you enter two decimal numbers **A** and **B** and perform `+`, `-`, `*`, `/`.
Results are shown on an alphanumeric LCD.
Includes correct **BCD ↔ BIN** conversions and a safe **divide-by-zero** branch (displays `ZABRONIONE` = *FORBIDDEN*).

> The same **`Kalkulator.hex`** runs in the **DSM-51 simulator** and on the **DSM-51 hardware board**.

---

## 📂 Repository contents

| File             | Description                                                                                               |
| ---------------- | --------------------------------------------------------------------------------------------------------- |
| `Kalkulator.asm` | Main 8051 assembly source                                                                                 |
| `Kalkulator.hex` | Intel HEX firmware (ready for DSM-51 simulator & board)                                                   |
| `Kalkulator.lst` | Assembler **listing** (addresses, opcodes, decoded instructions, symbols) — useful for debugging/studying |

---

## Features

* Two-digit decimal input for **A** and **B** (range 0–99)
* Operation selection **by keys A/B/C/D**:

  * A → '+'
  * B → '-'
  * C → '*' 
  * D → '/'
* Input methods:

  * **Simulator:** click the on-screen keys **or** use your **PC keyboard** (A–D and digits)
  * **Hardware board:** press the **physical A/B/C/D buttons** and digit buttons
* Conversions: `BCD` (two ASCII digits → packed BCD `TTJJ`), `BCD_NA_HEX` (BCD→binary), `BIN_NA_BCD` (binary→BCD for LCD)
* Arithmetic:

  * Addition with BCD correction (`DA A`)
  * Subtraction with sign
  * Multiplication (8×8 → 16-bit; high/low shown)
  * Division prints: `quotient i remainder/denominator`
* Safe division: division by zero prints **ZABRONIONE**
* Robust stack discipline (no `RET` corruption)
* Start a **new calculation** by pressing **A**

---

## 💻 Run in DSM-51 Simulator

1. Launch **DSM-51.EXE (Simulator)**.
2. *Load program* → select `Kalkulator.hex`.
3. **Run**.
4. LCD prompts: `A=` then `B=` — enter **two digits** each (mouse clicks or PC keyboard).
5. Choose operation with **A/B/C/D**.
6. Press **A** to start the next calculation.

---

## 🔌 Run on DSM-51 Hardware Board

1. Open **DSM51Ass** (or your DSM-51 loader/programmer).
2. Select **`Kalkulator.hex`** (Intel HEX) and upload to program memory.
3. Reset the board.
4. Use the **physical digit buttons** and **A/B/C/D** to operate.

---

## Program flow

1. `A=` → enter tens & ones.
2. `B=` → enter tens & ones.
3. Select **A/B/C/D**.
4. LCD examples:

   * Subtraction: `-36`
   * Division: `12 i 3/44`
5. Press **A** to repeat.

---

## 🛠️ Build (optional)

A ready **`.hex`** is provided. To rebuild, use DSM51Ass, or SDCC’s 8051 tools (e.g. `sdas8051`).

---

## Limitations & ideas

* Two digits per operand (0–99)
* No input correction/backspace
* Potential next steps: multi-digit operands, signed input, clearer LCD UX

---

## Author

**Alicja P.** — educational project for the **DSM-51** 8051 training system.

---

## 📦 Release

**v1.0.0 — Initial DSM-51 Release**

* BCD input with LCD echo; operations via **A/B/C/D**
* Safe divide-by-zero (`ZABRONIONE`)
* Stable stack; correct BIN↔BCD

**Artifacts:** `Kalkulator.hex`, `Kalkulator.asm`, `Kalkulator.lst`
