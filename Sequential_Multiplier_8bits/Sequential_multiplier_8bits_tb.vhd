library ieee;
use ieee.std_logic_1164.all;

entity Sequential_multiplier_8bits_tb is
end entity;

architecture test of Sequential_multiplier_8bits_tb is
-------------------------------------------------------------
signal A , B : std_logic_vector(7 downto 0);
signal clk , rst , start : std_logic ;
signal done : std_logic;
signal P : std_logic_vector (15 downto 0);
-------------------------------------------------------------
component Sequential_Multiplier_8bits is
generic (n : integer := 8);
port(
clk , rst , start : in std_logic;
A , B : in std_logic_vector ((n-1) downto 0);
done : out std_logic;
P : out std_logic_vector ((2*n-1)downto 0)
);
end component;

begin

T1 :  Sequential_Multiplier_8bits
port map (clk,rst,start,A , B ,done,P);

clk <= '0', '1' after 10 ns, '0' after 20 ns, '1' after 30 ns,'0' after 40 ns,'1' after 50 ns,'0' after 60 ns;
start <= '1' , '0' after 20ns;
--rst <= '0', '1' after 40 ns, '0' after 60 ns;
a <= "00000101";
b <= "00001111";

end test;