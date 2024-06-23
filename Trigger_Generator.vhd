library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;
use IEEE.numeric_std.all;

entity Trigger_Generator is
    Port ( clk : in STD_LOGIC;
           trigger : out STD_LOGIC);
end Trigger_Generator;

architecture Behavioral of Trigger_Generator is
component Counter is
    generic(n: positive:= 10);
    Port ( clk : in STD_LOGIC;
           en : in STD_LOGIC;
           reset : in STD_LOGIC;
           count : out STD_LOGIC_VECTOR (n-1 downto 0));
end component;

signal resetCounter: std_logic;
signal outputCounter: std_logic_vector(23 downto 0);
signal ms250 : std_logic_vector(23 downto 0) := "101111101011110000100000";
signal ms250And100us : std_logic_vector(23 downto 0) := "101111101100111110101000";

begin
trigg : Counter generic map(24) port map (clk,'1',resetCounter,outputCounter);
process(clk)
begin

if(outputCounter > ms250 and outputCounter < ms250And100us) then
  trigger <= '1';
else
  trigger <= '0';
end if;

if(outputCounter = ms250And100us or outputCounter = "XXXXXXXXXXXXXXXXXXXXXXXX") then
  resetCounter <= '0';
else
    resetCounter <= '1';
end if;

end process;
end Behavioral;
