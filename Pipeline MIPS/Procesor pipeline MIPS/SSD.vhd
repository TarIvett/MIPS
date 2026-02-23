----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/06/2025 06:29:21 PM
-- Design Name: 
-- Module Name: SSD - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity SSD is
    Port ( Digit : in STD_LOGIC_VECTOR (31 downto 0);
           CLK : in STD_LOGIC;
           CAT : out STD_LOGIC_VECTOR (6 downto 0);
           AN : out STD_LOGIC_VECTOR (7 downto 0));
end SSD;

architecture Behavioral of SSD is
signal cnt: std_logic_vector (16 downto 0) := (others => '0');
signal rez: std_logic_vector (3 downto 0) := (others => '0');
begin

process(clk)
begin 
    if(rising_edge(clk)) then
        cnt <= cnt + 1;
    end if;
end process;

process(Digit, cnt(16 downto 14))
begin
    case cnt(16 downto 14) is
        when "000" => rez <= Digit(3 downto 0);
        when "001" => rez <= Digit(7 downto 4);
        when "010" => rez <= Digit(11 downto 8);
        when "011" => rez <= Digit(15 downto 12);
        when "100" => rez <= Digit(19 downto 16);
        when "101" => rez <= Digit(23 downto 20);
        when "110" => rez <= Digit(27 downto 24);
        when "111" => rez <= Digit(31 downto 28);
        when others => rez <= "0000";
   end case;     
end process;

process(cnt(16 downto 14))
begin
    case cnt(16 downto 14) is
        when "000" => AN <= "11111110";
        when "001" => AN <= "11111101";
        when "010" => AN <= "11111011";
        when "011" => AN <= "11110111";
        when "100" => AN <= "11101111";
        when "101" => AN <= "11011111";
        when "110" => AN <= "10111111";
        when "111" => AN <= "01111111";
        when others => AN <= "00000000";
   end case;     
end process;


with rez select 
CAT<= "1111001" when "0001",   --1
     "0100100" when "0010",   --2
     "0110000" when "0011",   --3
     "0011001" when "0100",   --4
     "0010010" when "0101",   --5
     "0000010" when "0110",   --6
     "1111000" when "0111",   --7
     "0000000" when "1000",   --8
     "0010000" when "1001",   --9
     "0001000" when "1010",   --A
     "0000011" when "1011",   --b
     "1000110" when "1100",   --C
     "0100001" when "1101",   --d
     "0000110" when "1110",   --E
     "0001110" when "1111",   --F
     "1000000" when others;   --0

end Behavioral;
