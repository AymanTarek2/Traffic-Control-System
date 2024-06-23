library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_Arith.ALL;
use IEEE.STD_LOGIC_Unsigned.ALL;


entity Counter is
    generic(n: positive:= 10);
    Port ( clk : in STD_LOGIC;
           en : in STD_LOGIC;
           reset : in STD_LOGIC;
           count : out STD_LOGIC_VECTOR (n-1 downto 0));
end Counter;


architecture Behavioral of Counter is
signal c: std_logic_vector (n-1 downto 0);
begin

process(clk,reset)
begin

if(reset = '1') then
  c <= (others => '0');
elsif (clk = '1' and clk 'event and en = '1') then
  c <= c + 1;
end if;
end process;

count <= c;

end Behavioral;
