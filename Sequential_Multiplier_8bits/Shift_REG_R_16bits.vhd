library IEEE;
use IEEE.std_logic_1164.all;

entity Shift_REG_R_16bits is 
generic (size : integer := 8);
port(
data_in : in std_logic_vector (size downto 0);
in_load , in_clk , in_shift , in_rst : in std_logic;
data_out 	: out std_logic_vector ((2*size-1) downto 0)
);
end Shift_REG_R_16bits;

architecture behave of Shift_REG_R_16bits is

signal reg_signal: std_logic_vector ((2*size) downto 0);
begin

process (in_clk , in_load , in_shift , in_rst)
	begin
	if in_rst = '1' then
		reg_signal <= (others => '0');
	elsif rising_edge(in_clk) then
		if in_load='1' then
		reg_signal((2*size) downto size)<= data_in;		
		elsif in_shift = '1' then
		reg_signal <= '0'& reg_signal(2*size downto 1); 
		end if; 
	end if;
end process;

data_out <= reg_signal((2*size-1) downto 0);

end architecture;
