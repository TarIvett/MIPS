----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/27/2025 06:37:53 PM
-- Design Name: 
-- Module Name: test_env - Behavioral
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
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity test_env is
       Port ( clk: in std_logic;
       btn: in std_logic_vector (4 downto 0);
       sw: in std_logic_vector (15 downto 0);
       led: out std_logic_vector(15 downto 0);
       an: out std_logic_vector (7 downto 0);
       cat: out std_logic_vector (6 downto 0));
end test_env;

architecture Behavioral of test_env is
signal en1: std_logic;
signal data_out: std_logic_vector(31 downto 0):= (others =>'0');

component MPG is
    Port ( en : out STD_LOGIC;
           clk : in STD_LOGIC;
           btn : in STD_LOGIC);
end component;


component SSD is
    Port ( Digit : in STD_LOGIC_VECTOR (31 downto 0);
           CLK : in STD_LOGIC;
           CAT : out STD_LOGIC_VECTOR (6 downto 0);
           AN : out STD_LOGIC_VECTOR (7 downto 0));
end component;

component IFetch is
    Port ( JumpAddress : in STD_LOGIC_VECTOR (31 downto 0);
           BranchAddress : in STD_LOGIC_VECTOR (31 downto 0);
           Jump : in STD_LOGIC;
           PCSrc : in STD_LOGIC;
           PC_4 : out STD_LOGIC_VECTOR (31 downto 0);
           Instruction : out STD_LOGIC_VECTOR (31 downto 0);
           EN : in STD_LOGIC;
           RST : in STD_LOGIC;
           CLK : in STD_LOGIC);
end component;

component UC is
    Port ( Instr : in STD_LOGIC_VECTOR (5 downto 0);
           RegDst : out STD_LOGIC;
           RegWrite : out STD_LOGIC;
           MemtoReg : out STD_LOGIC;
           MemWrite : out STD_LOGIC;
           ExtOp : out STD_LOGIC;
           ALUSrc : out STD_LOGIC;
           ALUOp : out STD_LOGIC_VECTOR (1 downto 0);
           Branch : out STD_LOGIC;
           Br_gez : out STD_LOGIC;
           Jump : out STD_LOGIC);
end component;

component IDecoding is
    Port ( EN : in STD_LOGIC;
           CLK: in STD_LOGIC;
           Instr : in STD_LOGIC_VECTOR (25 downto 0);
           RegWrite : in STD_LOGIC;
           RegDst : in STD_LOGIC;
           ExtOp : in STD_LOGIC;
           WD : in STD_LOGIC_VECTOR (31 downto 0);
           RD1 : out STD_LOGIC_VECTOR (31 downto 0);
           RD2 : out STD_LOGIC_VECTOR (31 downto 0);
           Ext_Imm : out STD_LOGIC_VECTOR (31 downto 0);
           func : out STD_LOGIC_VECTOR (5 downto 0);
           sa : out STD_LOGIC_VECTOR (4 downto 0));
end component;

component EXecute is
    Port ( RD1 : in STD_LOGIC_VECTOR (31 downto 0);
           RD2 : in STD_LOGIC_VECTOR (31 downto 0);
           ALUSrc : in STD_LOGIC;
           Ext_Imm : in STD_LOGIC_VECTOR (31 downto 0);
           sa : in STD_LOGIC_VECTOR (4 downto 0);
           func : in STD_LOGIC_VECTOR (5 downto 0);
           ALUOp : in STD_LOGIC_VECTOR (1 downto 0);
           PC4 : in STD_LOGIC_VECTOR (31 downto 0);
           Zero : out STD_LOGIC;
           GEZ : out STD_LOGIC;
           ALURes : out STD_LOGIC_VECTOR (31 downto 0);
           BranchAddress : out STD_LOGIC_VECTOR (31 downto 0));
end component;

component MEMory is
    Port ( MemWrite : in STD_LOGIC;
           ALUResIn : in STD_LOGIC_VECTOR (31 downto 0);
           ALUResOut : out STD_LOGIC_VECTOR (31 downto 0);
           RD2 : in STD_LOGIC_VECTOR (31 downto 0);
           MemData : out STD_LOGIC_VECTOR (31 downto 0);
           CLK: in STD_LOGIC;
           EN : in STD_LOGIC);
end component;

signal JumpAddress : std_logic_vector(31 downto 0) := X"00000000";
signal BranchAddress: std_logic_vector(31 downto 0) := X"00000000";
signal PC_4: std_logic_vector(31 downto 0) := X"00000000";
signal Instruction: std_logic_vector(31 downto 0) := X"00000000";
signal Zero: std_logic := '0';
signal GEZ: std_logic := '0';

signal Br_Zero : std_logic := '0';
signal BGEZ : std_logic := '0';

signal RegDst : STD_LOGIC := '0';
signal RegWrite : STD_LOGIC := '0';
signal MemtoReg : STD_LOGIC := '0';
signal MemWrite : STD_LOGIC := '0';
signal ExtOp : STD_LOGIC := '0';
signal ALUSrc : STD_LOGIC := '0';
signal ALUOp : STD_LOGIC_VECTOR (1 downto 0) := "00";
signal Branch : STD_LOGIC := '0';
signal Br_gez : STD_LOGIC := '0';
signal Jump : STD_LOGIC := '0';
signal PCSrc : STD_LOGIC := '0';

signal WD: STD_LOGIC_VECTOR (31 downto 0) := X"00000000";
signal RD1: STD_LOGIC_VECTOR(31 downto 0) := X"00000000";
signal RD2: STD_LOGIC_VECTOR(31 downto 0) := X"00000000";
signal Ext_Imm: STD_LOGIC_VECTOR(31 downto 0) := X"00000000";
signal ALURes: STD_LOGIC_VECTOR(31 downto 0) := X"00000000";
signal ALUResE: STD_LOGIC_VECTOR(31 downto 0) := X"00000000";
signal MemData: STD_LOGIC_VECTOR(31 downto 0) := X"00000000";
signal func: STD_LOGIC_VECTOR(5 downto 0) := "000000";
signal sa: STD_LOGIC_VECTOR(4 downto 0) := "00000";

begin

--MPG1: MPG port map(en=>en1,clk=>clk, btn=>btn(0));
en1<=btn(0);
SSD1: SSD port map(Digit => data_out, CLK => clk, CAT => cat, AN => an);
IFetch1: IFetch port map(JumpAddress=>JumpAddress, BranchAddress=>BranchAddress, Jump=>Jump, PCSrc=>PCSrc, 
    PC_4=>PC_4, Instruction=>Instruction, EN=>en1, RST=>btn(1), CLK=>clk);
IDecoding1: IDecoding port map(EN => en1, CLK => clk, Instr => Instruction(25 downto 0), RegWrite => RegWrite, 
    RegDst => RegDst, ExtOp => ExtOp, WD => WD, RD1 => RD1, RD2 => RD2, Ext_Imm => Ext_Imm, func => func, sa => sa);
UC1: UC port map(Instr => Instruction(31 downto 26), RegDst => RegDst, RegWrite => RegWrite, MemtoReg => MemtoReg, 
    MemWrite => MemWrite, ExtOp => ExtOp, ALUSrc => ALUSrc, ALUOp => ALUOp, Branch => Branch, Br_gez => Br_gez, Jump => Jump);
EXecute1: EXecute port map(RD1 => RD1, RD2 => RD2, ALUSrc => ALUSrc, Ext_Imm => Ext_Imm, sa => sa, func => func, 
    ALUOp => ALUOp, PC4 => PC_4, Zero =>  Zero, GEZ => GEZ, ALURes => ALUResE, BranchAddress => BranchAddress);
MEMory1: MEMory port map( MemWrite => MemWrite, ALUResIn => ALUResE, ALUResOut => ALURes, RD2 => RD2,
    MemData => MemData, CLK => clk, EN => en1);

WD <= ALURes when MemtoReg = '0' else MemData;
PCSrc <= Branch and Zero;
JumpAddress <= PC_4(31 downto 28) & Instruction(25 downto 0) & "00";

process(sw(7 downto 5))
begin
    case sw(7 downto 5) is 
        when "000" => 
            data_out <= Instruction;
        when "001" =>
            data_out <= PC_4;
        when "010" =>
            data_out <= RD1;
        when "011" =>
            data_out <= RD2;
        when "100" =>
            data_out <= Ext_Imm;
        when "101" =>
            data_out <= ALURes;
        when "110" =>
            data_out <= MemData;
        when "111" =>
            data_out <= WD;
        when others => 
            data_out <= X"00000000";
    end case;
end process;

end Behavioral;
