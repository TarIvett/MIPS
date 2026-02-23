----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/10/2025 06:23:35 PM
-- Design Name: 
-- Module Name: MEMory - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MEMory is
    Port ( MemWrite : in STD_LOGIC;
           ALUResIn : in STD_LOGIC_VECTOR (31 downto 0);
           ALUResOut : out STD_LOGIC_VECTOR (31 downto 0);
           RD2 : in STD_LOGIC_VECTOR (31 downto 0);
           MemData : out STD_LOGIC_VECTOR (31 downto 0);
           CLK: in STD_LOGIC;
           EN : in STD_LOGIC);
end MEMory;

architecture Behavioral of MEMory is
type ram_type is array (0 to 63) of std_logic_vector(31 downto 0);
signal ram : ram_type := (
    X"00000018",
    X"00000024",
    X"00000000",
    X"00000000",
    X"00000000",
    X"00000000",
    X"00000000",
    X"00000000",
    others => X"00000000");
begin

process(clk)
begin
    if rising_edge(clk) then
        if EN = '1' then
            if MemWrite = '1' then
                ram(conv_integer(ALUResIn(7 downto 2))) <= RD2;
            end if;
        end if;
    end if;
end process;

MemData <= ram(conv_integer(ALUResIn(7 downto 2)));
ALUResOut <= ALUResIn;

end Behavioral;
