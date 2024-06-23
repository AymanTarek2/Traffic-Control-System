library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;
use IEEE.numeric_std.ALL;

entity Range_Sensor is
    Port ( CLK, reset : in STD_LOGIC;
           pulse : in STD_LOGIC;
           triggerOut : out STD_LOGIC;
           lampOut : out std_logic);
           
end Range_Sensor;

architecture Behavioral of Range_Sensor is
component Sensor_Distance is
    Port ( clk : in STD_LOGIC;
           calc_reset : in STD_LOGIC; 
           pulse : in STD_LOGIC;
           distance : out STD_LOGIC_VECTOR (8 downto 0));
end component;

component Trigger_Generator is
    Port ( clk : in STD_LOGIC;
           trigger : out STD_LOGIC);
end component;

component Counter is
    generic(n: positive:= 10);
    Port ( clk : in STD_LOGIC;
           en : in STD_LOGIC;
           reset : in STD_LOGIC;
           count : out STD_LOGIC_VECTOR (n-1 downto 0));
end component;

signal triggOut: std_logic;
signal binaryDistance: STD_LOGIC_VECTOR (8 downto 0);
signal resetCounter: STD_LOGIC := '0';
signal widthClock: STD_LOGIC_VECTOR (27 downto 0);
begin
trigger_gen : Trigger_Generator port map(CLK,triggOut);
PulseWidth : Sensor_Distance port map(CLK,triggOut,pulse,binaryDistance);
count : Counter generic map(28) port map(clk, '1', resetCounter, widthClock);

process(pulse,reset,clk)
begin
if(reset = '1') then lampOut <= '0'; resetCounter <= '1';
elsif(clk = '1' and clk 'event) then
  resetCounter <= '0';
  if(widthClock = "0001001100010010110100000000") then -- 0.2sec delay
  if (binaryDistance < "1100100" and binaryDistance > "0") then
    lampOut <= '1';
  else
    lampOut <= '0';
  end if;
  resetCounter <= '1';
  end if;
end if;
end process;
triggerOut <= triggOut;


end Behavioral;
