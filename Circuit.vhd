library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Circuit is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC; 
           en: out STD_LOGIC_VECTOR (3 downto 0));
           
end Circuit;

architecture Behavioral of Circuit is
  component Counter is
    generic(n: positive:= 10);
    Port ( clk : in STD_LOGIC;
           en : in STD_LOGIC;
           reset : in STD_LOGIC;
           count : out STD_LOGIC_VECTOR (n-1 downto 0));
end component;
  signal timeInSeconds: STD_LOGIC_VECTOR (6 downto 0):= (others => '0');
  signal clkCycles: std_logic_vector (26 downto 0); --101111101011110000100000000
  signal resetCounter: std_logic;
  type state_type is (s0,s1,s2,s3); 
  signal s: state_type;
  signal en_temp: std_logic_vector (3 downto 0);
  begin
  clkd : Counter generic map(27) port map(clk,'1',resetCounter,clkCycles); 
  
  process(clk,reset)
    begin
    if(reset = '1') then
      resetCounter <= '1';
      timeInSeconds <= (others => '0');
      s <= s0;
    elsif(clk = '1' and clk 'event) then
      if(clkCycles <"101111101011110000100000000") then
        resetCounter <= '0';
      else
        resetCounter <= '1';
        timeInSeconds <= timeInSeconds + 1;
        if(timeInSeconds < "11110") then s <= s0;  -- <30
        elsif(timeInSeconds < "111100") then s <= s1;  -- <60
        elsif(timeInSeconds < "1011010") then s <= s2;  -- <90
        elsif(timeInSeconds < "1111000") then s <= s3;  -- <120
        else  -- >120
          timeInSeconds <= (others => '0');
          s <= s0;
        end if;
      end if;
    end if;
        
    end process;
  
  --process(clk,reset)
  --begin
    --if(reset = '1' or clkCycles > "101111101011110000100000000") then -- 100Mhz to sec
      --resetCounter <= '1';
      --timeInSeconds <= timeInSeconds + 1;
    --else
      --resetCounter <= '0';
    --end if;
  --end process;
  --process(timeInSeconds,reset) 
  --begin
    --if(reset = '1') then 
      --s <= s0;
      --timeInSeconds <= "00000";
    --elsif(timeInSeconds > "11101") then --condition for changing state is time exceeding 29 seconds
      --if(s = s0) then s <= s1;
      --elsif (s = s1) then s<= s2;
      --elsif (s = s2) then s<= s3;
      --else s<=s0;
      --end if;
    --timeInSeconds <= "00000";
    --end if;
  --end process;
  
  
  
  process(s)
  begin
    if(s = s0) then
      en_temp(0) <= '0' ; en_temp(1) <= '1'; en_temp(2) <= '1'; en_temp(3) <= '1';
    elsif(s = s1) then
      en_temp(0) <= '1'; en_temp(1) <= '0'; en_temp(2) <= '1'; en_temp(3) <= '1';
    elsif(s = s2) then
     en_temp(0) <= '1'; en_temp(1) <= '1'; en_temp(2) <= '0'; en_temp(3) <= '1';
    else
      en_temp(0) <= '1'; en_temp(1) <= '1'; en_temp(2) <= '1'; en_temp(3) <= '0';
    end if;        
  end process;
  en <= en_temp;
  
end Behavioral;
