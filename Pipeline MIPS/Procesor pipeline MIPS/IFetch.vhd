----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/27/2025 06:43:58 PM
-- Design Name: 
-- Module Name: IFetch - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values


-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity IFetch is
    Port ( JumpAddress : in STD_LOGIC_VECTOR (31 downto 0);
           BranchAddress : in STD_LOGIC_VECTOR (31 downto 0);
           Jump : in STD_LOGIC;
           PCSrc : in STD_LOGIC;
           PC_4 : out STD_LOGIC_VECTOR (31 downto 0);
           Instruction : out STD_LOGIC_VECTOR (31 downto 0);
           EN : in STD_LOGIC;
           RST : in STD_LOGIC;
           CLK : in STD_LOGIC);
end IFetch;

architecture Behavioral of IFetch is
type rom is array(0 to 63) of std_logic_vector(31 downto 0);
signal instruction_memory : rom := (
     B"110000_00000_00001_0000000000000000", --X"C001 0000", 00: lw $1, 0[$0] -> Incarca in R1 valoarea de la adresa 0 din memorie
     B"000000_00000_00000_00000_00000_100000", --X"0000 0020" 01: add $0, $0, $0 -> NoOp
     B"110000_00000_00010_0000000000000100", --X"C002 0004", 02: lw $2, 4[$0] -> Incarca in R2 valoarea de la adresa 4 din memorie
     B"110001_00000_00001_0000000000001000", --X"C401 0008", 03: sw $1, 8[$0] -> Scrie in memorie la adresa 8 valoarea adresei din R1
     B"000000_00000_00000_00000_00000_100000", --X"0000 0020" 04: add $0, $0, $0 NoOp
     B"110001_00000_00010_0000000000001100", --X"C402 000C", 05: sw $2, 12[$0] -> Scrie in memorie la adresa 12 valoarea adresei din R2
     B"000001_00000_00011_0000000000010000", --X"0403 0010", 06: addi $3, 16[$0] -> Initializam R3 cu 16
     B"000001_00000_01000_0000000000000001", --X"0408 0001" 07: addi $8, 1[$0] -> Initializam R8 cu 1
     B"000000_00001_00010_00100_00000_100001", --X"0022 2021", 08: sub $4, $1, $2 -> Se salveaza in R4 = R1 - R2
     B"000000_00000_00000_00000_00000_100000", --X"0000 0020" 09: add $0, $0, $0 NoOp
     B"000000_00000_00000_00000_00000_100000", --X"0000 0020" 0A: add $0, $0, $0 NoOp
     B"001000_00100_00101_0000000000000000", --X"2085 0000", 0B: slti $5, $4, 0 -> Daca R4 < 0, atunci R5 se seteaza la 1, altfel la 0
     B"000000_00000_00000_00000_00000_100000", --X"0000 0020" 0C: add $0, $0, $0 NoOp
     B"000000_00000_00000_00000_00000_100000", --X"0000 0020" 0D: add $0, $0, $0 NoOp
     B"011000_00101_01000_0000000000010001", --X"60A8 0007", 0E: beq $5, $8, 11 -> In R8 se afla 1, iar daca R5 = R8 = 1 atunci se sare peste 17(11 hexa) instructiuni(adica daca x < y, valorile se interschimba)
     B"000000_00000_00000_00000_00000_100000", --X"0000 0020" 0F: add $0, $0, $0 NoOp
     B"000000_00000_00000_00000_00000_100000", --X"0000 0020" 10: add $0, $0, $0 NoOp
     B"000000_00000_00000_00000_00000_100000", --X"0000 0020" 11: add $0, $0, $0 NoOp
     B"000000_00001_00010_00001_00000_100001", --X"0022 0821", 12: sub $1, $1, $2 -> Se salveaza in R1 = R1 - R2
     B"000000_00000_00000_00000_00000_100000", --X"0000 0020" 13: add $0, $0, $0 NoOp
     B"000000_00000_00000_00000_00000_100000", --X"0000 0020" 14: add $0, $0, $0 NoOp
     B"110001_00011_00001_0000000000000000", --X"C461 0000", 15: sw $1, 0[$3] -> Se scrie in memorie noua valoare a lui R1
     B"110001_00011_00010_0000000000000100", --X"C462 0004", 16: sw $2, 4[$3] -> Se scrie in memorie noua valoare a lui R2
     B"000001_00011_00011_0000000000001000", --X"0463 0008", 17: addi $3, $3, 8 -> Se aduna 8 la $3, aici se stocheaza unde se va salva in memorie
     B"000000_00001_00010_00100_00000_100001", --X"0022 2021", 18: sub $4, $1, $2 -> Se salveaza in R4 = R1 - R2
     B"000000_00000_00000_00000_00000_100000", --X"0000 0020" 19: add $0, $0, $0 NoOp
     B"000000_00000_00000_00000_00000_100000", --X"0000 0020" 1A: add $0, $0, $0 NoOp
     B"011000_00100_00000_0000000000001010", --X"6080 0005", 1B: beq $4, $0, 0A -> Se sare peste 10(A hexa) instructiuni daca R4 = 0, adica R1 = R2 (se termina algoritmul daca sunt egale si se sare)
     B"000000_00000_00000_00000_00000_100000", --X"0000 0020" 1C: add $0, $0, $0 NoOp
     B"000000_00000_00000_00000_00000_100000", --X"0000 0020" 1D: add $0, $0, $0 NoOp
     B"000000_00000_00000_00000_00000_100000", --X"0000 0020" 1E: add $0, $0, $0 NoOp
     B"111111_00000000000000000000001000", --X"FC00 0006", 1F: j 08 -> Daca nu s-a sarit la beq atunci se sare inapoi la inceput pentru a mai face odata bucla
     B"000000_00000_00000_00000_00000_100000", --X"0000 0020" 20: add $0, $0, $0 NoOp
     B"000000_00010_00000_00110_00000_100000", --X"0040 3020", 21: add $6, $2, $0 -> Se pune valoare lui R2 in R6
     B"000000_00000_00000_00000_00000_100000", --X"0000 0020" 22: add $0, $0, $0 NoOp
     B"000000_00001_00000_00010_00000_100000", --X"0020 1020", 23: add $2, $1, $0 -> Se pune valoare lui R1 in R2
     B"000000_00110_00000_00001_00000_100000", --X"00C0 0820", 24: add $1, $5, $0 -> Se pune valoare lui R6 in R2
     B"111111_00000000000000000000010010", --X"FC00 0009", 25: j 12 -> S-a facut interschimarea R1 <=> R2, sau x <=> y si se sare inapoi la executie
     B"000000_00000_00000_00000_00000_100000", --X"0000 0020" 26: add $0, $0, $0 NoOp
     B"110001_00011_00001_0000000000000000", --X"C461 0000", 27: sw $1, 0[$3] -> Se termina programul si se scrie ultima valoare in memorie
     others => X"00000000"); 
signal address : std_logic_vector(31 downto 0) := X"00000000";
signal pc_in : std_logic_vector(31 downto 0) := X"00000000";
signal next_instr: std_logic_vector(31 downto 0) := X"00000000";
begin

process(CLK, EN, RST)
begin
    if RST = '1' then 
        address <= X"00000000";
    elsif rising_edge(CLK) then 
        if EN = '1' then 
            address <= pc_in;
        end if;
    end if;
end process;


Instruction <= instruction_memory(TO_INTEGER(unsigned(address(7 downto 2))));
next_instr <= address + 4;
PC_4 <= next_instr;

process(next_instr, BranchAddress, PCSrc, JumpAddress, Jump)
begin 
    if Jump = '1' then 
        pc_in <= JumpAddress;
    else
        if PCSrc = '1' then 
            pc_in <= BranchAddress;
        else 
            pc_in <= next_instr;
        end if;
    end if;
end process;


end Behavioral;
