----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/10/2025 06:20:26 PM
-- Design Name: 
-- Module Name: EXecute - Behavioral
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
use IEEE.std_logic_arith.ALL;

--use ieee.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity EXecute is
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
end EXecute;

architecture Behavioral of EXecute is
signal in1 : std_logic_vector(31 downto 0) := x"00000000";
signal in2 : std_logic_vector(31 downto 0) := x"00000000";
signal ALUCtrl : std_logic_vector(3 downto 0) := "0000";
signal result : std_logic_vector(31 downto 0) := X"00000000";

begin
in1 <= RD1;
in2 <= RD2 when ALUSrc='0' else Ext_Imm;

process (func, ALUOp)
begin
    case ALUOp is
        when "00" => --addi
            ALUCtrl <= "0000";
        when "01" => --subi
            ALUCtrl <= "1000";
        when "10" => --R
            case func is
                when "100000" => --add
                    ALUCtrl <= "0000";
                when "100001" => --sub
                    ALUCtrl <= "1000";
                when "001010" => --sll
                    ALUCtrl <= "0100";
                when "001100" => --srl
                    ALUCtrl <= "0101";
                when "001110" => --sllv
                    ALUCtrl <= "0111";
                when "010001" => --and
                    ALUCtrl <= "0001"; 
                when "010010" => --or
                    ALUCtrl <= "0010";
                when "010011" => --xor
                    ALUCtrl <= "0011";
                when others =>
                    ALUCtrl <= "1111";
            end case;
        when "11" => --slti
            ALUCtrl <= "1011";
        when others => 
            ALUCtrl <= "1111";
    end case;
end process;

process(ALUCtrl, sa, in1, in2)
begin
    case ALUCtrl is
        when "0000" => --add
            result <= in1 + in2;
        when "1000" => --sub
            result <= in1 - in2;
        when "0001" => --and
            result <= in1 and in2;
        when "0010" => --or
            result <= in1 or in2;
        when "0011" => --xor
            result <= in1 xor in2;
        when "0100" => --sll
            result <= to_stdlogicvector(to_bitvector(in2) sll conv_integer(sa));
        when "0101" => --srl
            result <= to_stdlogicvector(to_bitvector(in2) srl conv_integer(sa));
        when "0111" => --sllv
            result <= to_stdlogicvector(to_bitvector(in2) sll conv_integer(in1));
        when "1011" => --slti
            if signed(in1) < signed(in2) then
                result <= x"00000001";
            else
                result <= x"00000000";
            end if;
        when others =>
            result <= x"00000000";
    end case;
end process;

Zero <= '1' when in1 = in2 else '0';
GEZ <= '1' when signed(in2) >= 0 else '0';
ALURes <= result;

BranchAddress <= PC4 + (Ext_Imm(29 downto 0) & "00");

end Behavioral;
