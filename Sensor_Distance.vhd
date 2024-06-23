library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_Unsigned.ALL;
use IEEE.numeric_std.all;

entity Sensor_Distance is
    Port ( clk : in STD_LOGIC;
           calc_reset : in STD_LOGIC; 
           pulse : in STD_LOGIC;
           distance : out std_logic_vector (8 downto 0));
end Sensor_Distance;

architecture Behavioral of Sensor_Distance is
component Counter is
generic(n: positive:= 10);
Port ( clk : in STD_LOGIC;
           en : in STD_LOGIC;
           reset : in STD_LOGIC;
           count : out STD_LOGIC_VECTOR (n-1 downto 0));
end component;

signal pulse_width: std_logic_vector (21 downto 0);
--signal t: integer;

signal invertCalc_reset: std_logic:= not calc_reset; --may use that
begin

counterPulse : Counter generic map(22) port map(clk, pulse, calc_reset, pulse_width);

Distance_Calc : process(pulse,clk)
variable result : integer;
variable multiplier : std_logic_vector(23 downto 0);
begin
if(pulse = '1' and clk = '1' and clk 'event) then
  multiplier := pulse_width * "11";
  result := to_integer(unsigned(multiplier(23 downto 13)));
  if(result > 458) then
    distance <= (others => '1');
  else
    distance <= std_logic_vector(to_unsigned(result,9));
  end if;
end if;
  --t <= to_integer(unsigned(pulse_width));
  --t <= t/100000000;
  --distance <= 17000 * t;
end process;
end Behavioral;
