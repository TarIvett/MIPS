----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/03/2025 06:24:34 PM
-- Design Name: 
-- Module Name: IDecoding - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity IDecoding is
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
end IDecoding;

architecture Behavioral of IDecoding is
component  reg_file is
    Port ( clk : in std_logic;
        en: in std_logic;
        ra1 : in std_logic_vector(4 downto 0);
        ra2 : in std_logic_vector(4 downto 0);
        wa : in std_logic_vector(4 downto 0);
        wd : in std_logic_vector(31 downto 0);
        regwr : in std_logic;
        rd1 : out std_logic_vector(31 downto 0);
        rd2 : out std_logic_vector(31 downto 0));
end component;

signal wa_mux: std_logic_vector(4 downto 0) := "00000";
begin
REG_FILE1: reg_file port map(clk => clk,en => EN, ra1 => Instr(25 downto 21), ra2 => Instr(20 downto 16),
                        wa => wa_mux, wd => WD, regwr => RegWrite, rd1 => RD1, rd2 => RD2);
                        
wa_mux<=Instr(20 downto 16) when RegDst='0' else Instr(15 downto 11);
func<=Instr(5 downto 0);
sa<=Instr(10 downto 6);

Ext_Imm(15 downto 0) <= Instr(15 downto 0);
Ext_Imm(31 downto 16) <= (others => Instr(15)) when ExtOp = '1' else (others => '0');

end Behavioral;
