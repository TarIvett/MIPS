----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/27/2025 07:25:59 PM
-- Design Name: 
-- Module Name: MPG - Behavioral
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

entity MPG is
    Port ( en : out STD_LOGIC;
           clk : in STD_LOGIC;
           btn : in STD_LOGIC);
end MPG;

architecture Behavioral of MPG is
signal cnt : std_logic_vector(15 downto 0) := (others => '0');
signal Q1, Q2, Q3 : std_logic;
begin
en <= Q2 and (not Q3);

process(clk)
begin
    if(clk'event and clk='1') then
        cnt <= cnt + 1;
    end if; 
end process;

process(clk)
begin
    if(clk'event and clk='1') then 
        if(cnt(15 downto 0) = "111111111111111") then 
            Q1 <= btn;
        end if;
        Q2 <= Q1;
        Q3 <= Q2;
    end if;
end process;

end Behavioral;
