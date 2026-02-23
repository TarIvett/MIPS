----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/03/2025 06:45:22 PM
-- Design Name: 
-- Module Name: UC - Behavioral
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

entity UC is
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
end UC;

architecture Behavioral of UC is

begin

process(Instr)
begin 
    RegDst <= '0';
    RegWrite <= '0';
    MemtoReg <= '0';
    MemWrite <= '0';
    ExtOp <= '0';
    ALUSrc <= '0';
    ALUOp <= "00";
    Branch <= '0';
    Br_gez <= '0';
    Jump <= '0';
    
    case Instr is 
        when "000000" => 
            RegDst <= '1';
            RegWrite <= '1';
            ALUOp <= "10";
        when "000001" =>  --addi
            RegWrite <= '1';
            ExtOp <= '1';
            ALUSrc <= '1';
        when "001000" =>  --slti
            RegWrite <= '1';
            ExtOp <= '1';
            ALUSrc <= '1';
            ALUOp <= "11";
        when "110000" =>  --lw
            RegWrite <= '1';
            ExtOp <= '1';
            ALUSrc <= '1';
            MemtoReg <= '1';
         when "110001" =>  --sw
            ExtOp <= '1';
            ALUSrc <= '1';
            MemWrite <= '1';
         when "011000" => --beq
            ExtOp <= '1';
            ALUOp <= "01";
            Branch <= '1';
         when "011001" =>  --bgez
            ExtOp <= '1';
            ALUOp <= "01";
            Br_gez <= '1';
         when "111111" => --jump
            Jump <= '1';
         when others => 
            RegDst <= '0';
            RegWrite <= '0';
            MemtoReg <= '0';
            MemWrite <= '0';
            ExtOp <= '0';
            ALUSrc <= '0';
            ALUOp <= "00";
            Branch <= '0';
            Br_gez <= '0';
            Jump <= '0';
    end case;
end process;

end Behavioral;
