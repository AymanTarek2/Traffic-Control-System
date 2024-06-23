library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;
use IEEE.numeric_std.ALL;

entity System is
    Port ( CLK : in STD_LOGIC;
           reset : in STD_LOGIC;
           pulseVector : in std_logic_vector (3 downto 0);
           triggerVector: out std_logic_vector (3 downto 0);
           beepVector: out std_logic_vector (3 downto 0);
           stopLamp: out std_logic_vector (3 downto 0));
end System;

architecture Behavioral of System is
component Circuit is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           en: out STD_LOGIC_VECTOR (3 downto 0));
end component;
component Range_Sensor is
    Port ( CLK: in STD_LOGIC;
           reset : in STD_LOGIC;
           pulse : in STD_LOGIC;
           triggerOut : out STD_LOGIC;
           lampOut : out std_logic); 
end component;

signal enable: std_logic_vector(3 downto 0);
signal resetSensor: std_logic_vector(3 downto 0) := not enable;
signal green: std_logic_vector(3 downto 0) := not enable;
signal red: std_logic_vector(3 downto 0) := enable;


begin

Circ : Circuit port map(CLK, reset, enable);
sensor0 : Range_Sensor port map(CLK, resetSensor(0), pulseVector(0), triggerVector(0), beepVector(0));
sensor1 : Range_Sensor port map(CLK, resetSensor(1), pulseVector(1), triggerVector(1), beepVector(1));
sensor2 : Range_Sensor port map(CLK, resetSensor(2), pulseVector(2), triggerVector(2), beepVector(2));
sensor3 : Range_Sensor port map(CLK, resetSensor(3), pulseVector(3), triggerVector(3), beepVector(3));

stopLamp <= red;
end Behavioral;
