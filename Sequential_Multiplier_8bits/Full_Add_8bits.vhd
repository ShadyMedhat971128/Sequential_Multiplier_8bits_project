library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
entity Full_Add_8bits is 
generic (size : integer := 8 );
port(
x,y : in std_logic_vector ((size-1) downto 0);
s	: out std_logic_vector (size downto 0)
);
end entity;

architecture behave of Full_Add_8bits is
begin
process(x,y)
variable c : std_logic_vector (size downto 0);
	begin
	c(0):= '0';
	for i in 0 to (size-1) loop
		s(i)<= x(i) xor y(i) xor c(i);
		c(i+1):= (x(i)and y(i))or(y(i)and c(i))or(x(i)and c(i));
	end loop;
	s(size) <= c(size);
	end process;
end behave;