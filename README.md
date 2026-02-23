# MIPS 32-bit Processor Implementation: Single-Cycle & Pipeline Architectures

Acest proiect reprezintă proiectarea și implementarea unui procesor MIPS pe 32 de biți, realizat în limbajul **VHDL**. Repository-ul include două variante fundamentale de design: o arhitectură **Single-Cycle (Ciclu Unic)** 
și o arhitectură optimizată de tip **Pipeline**, ambele fiind validate prin simulare și testare pe placă FPGA.

---

## Arhitectura Sistemului

Proiectul este structurat pentru a reflecta fluxul de execuție a instrucțiunilor într-un procesor de tip RISC, fiind împărțit în unități funcționale clare:

### 1. Unități Funcționale (Datapath)
* **Instruction Fetch (IF)**: Responsabil pentru aducerea instrucțiunii din memorie pe baza contorului de program (PC).
* **Instruction Decode (ID)**: Unitatea de decodificare a instrucțiunilor și accesarea setului de registre (Register File).
* **Execute (EX)**: Unitatea Logico-Aritmetică (ALU) care execută operațiile matematice, logice și calculele de adresă.
* **Memory Access (MEM)**: Gestionează citirea și scrierea datelor în memoria RAM.
* **Write Back (WB)**: Actualizează registrele cu rezultatele finale.

### 2. Control Unit
* Implementează logica de control pentru semnalele critice: `RegDst`, `ALUSrc`, `MemtoReg`, `RegWrite`, `MemWrite`, `Branch` și `ALUOp`.
* Include suport pentru instrucțiuni de salt condiționat (`BEQ`, `BGEZ`) și necondiționat (`J`).

### 3. Implementarea Pipeline (Optimizare)
* **Segmentare**: Execuția este împărțită în 5 etape, separate prin registre de segment (IF/ID, ID/EX, EX/MEM, MEM/WB).
* **Gestionarea Hazardurilor**: 
    * Rezolvarea hazardurilor structurale prin scrierea în registre pe frontul descendent al ceasului.
    * Gestionarea semnalelor de control prin stocare centralizată în registrele de segment.

---

## Setul de Instrucțiuni Suportat

Aplicația suportă o varietate de formate de instrucțiuni MIPS:
* **Tip R (Register)**: `ADD`, `SUB`, `SLL`, `SRL`, `AND`, `OR`, `XOR`.
* **Tip I (Immediate)**: `ADDI`, `LW`, `SW`, `BEQ`, `BGEZ`.
* **Tip J (Jump)**: `J` (Jump).

---

## Specificații Tehnice

| Parametru | Detalii |
| :--- | :--- |
| **Arhitectură** | MIPS 32-bit (Reduced Instruction Set Computer) |
| **Limbaj Hardware** | VHDL |
| **Platformă** | Validat pe placă FPGA și simulare software |
| **Gestionare Date** | Memorie de instrucțiuni și memorie de date separate (Arhitectură Harvard) |
| **Sistem de Pipeline** | 5 Stagii cu registre de control segmentate |

---
*Proiect realizat în cadrul Universității Tehnice din Cluj-Napoca, Facultatea de Automatică și Calculatoare.*
